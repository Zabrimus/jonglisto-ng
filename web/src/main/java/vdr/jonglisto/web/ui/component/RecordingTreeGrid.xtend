package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.data.TreeData
import com.vaadin.data.provider.TreeDataProvider
import com.vaadin.icons.VaadinIcons
import com.vaadin.shared.ui.dnd.DropEffect
import com.vaadin.shared.ui.dnd.EffectAllowed
import com.vaadin.shared.ui.grid.DropMode
import com.vaadin.ui.Grid.ItemClick
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.TextField
import com.vaadin.ui.TreeGrid
import com.vaadin.ui.UI
import com.vaadin.ui.components.grid.EditorOpenEvent
import com.vaadin.ui.components.grid.EditorOpenListener
import com.vaadin.ui.components.grid.TreeGridDragSource
import com.vaadin.ui.components.grid.TreeGridDropTarget
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.renderers.HtmlRenderer
import com.vaadin.ui.themes.ValoTheme
import de.steinwedel.messagebox.ButtonOption
import de.steinwedel.messagebox.MessageBox
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import java.util.List
import java.util.stream.Collectors
import javax.inject.Inject
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@ViewScoped
class RecordingTreeGrid {
    private static val COLUMN_NAME = "NAME"
    private static val COLUMN_START = "START"
    private static val COLUMN_DURATION = "DURATION"
    private static val COLUMN_ACTION = "ACTION"

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    @Inject
    private EpgDetailsWindow epgDetails

    var TreeGrid<Recording> treeGrid

    var VDR currentVdr

    def setCurrentVdr(VDR vdr) {
        this.currentVdr = vdr
        return this
    }

    def setRecordings(List<Recording> recs) {
        treeGrid.dataProvider =  getTreeDataProvider(recs)
    }

    def getTreeGrid() {
        return treeGrid
    }

    def createTreeGrid(List<Recording> recordings) {
        treeGrid = new TreeGrid<Recording>();
        treeGrid.dataProvider = getTreeDataProvider(recordings)

        treeGrid.addColumn([s | s.folder]) //
            .setCaption(messages.captionRecName) //
            .setId(COLUMN_NAME) //
            .setSortable(true) //
            .setEditorComponent(new TextField(), [ Recording s, String b | renameRecordingSvdrp(s, b) ]) //
            .editable = true

        treeGrid.addColumn([s | createStart(s)]) //
            .setRenderer(new HtmlRenderer) //
            .setCaption(messages.captionRecStart) //
            .setId(COLUMN_START) //
            .sortable = false

        treeGrid.addColumn([s | createDuration(s)]) //
            .setCaption(messages.captionRecDuration) //
            .setId(COLUMN_DURATION) //
            .sortable = false

        treeGrid.addColumn([s | createActionButtons(s)]) //
            .setRenderer(new ComponentRenderer)
            .setCaption(messages.captionRecAction) //
            .setId(COLUMN_ACTION) //
            .sortable = false

        treeGrid.addItemClickListener[event | event.showEpgDetails]

        treeGrid.editor.addOpenListener(new EditorOpenListener<Recording>() {
            override onEditorOpen(EditorOpenEvent<Recording> event) {
                // allow editing only on recordings, not folders
                if (event.bean.id == 0) {
                    event.source.cancel
                }
            }
        })

        treeGrid.editor.enabled = true
        treeGrid.selectionMode = SelectionMode.MULTI


        // DragSource
        val channelDragSource = new TreeGridDragSource<Recording>(treeGrid);

        channelDragSource.effectAllowed = EffectAllowed.MOVE;
        channelDragSource.setDragDataGenerator("text") [s | String.valueOf(s.id)]

        // DragTarget
        val channelDropTarget = new TreeGridDropTarget<Recording>(treeGrid, DropMode.ON_TOP)
        channelDropTarget.dropEffect = DropEffect.MOVE;

        channelDragSource.addGridDragStartListener[ s | channelDragSource.dragData = s.draggedItems ]

        channelDragSource.addGridDragEndListener[ items | {
                // System.err.println("Dragged: " + items.draggedItems)
            }
        ]

        channelDropTarget.addGridDropListener[ event | {
            if (!event.dragData.isPresent || !event.dropTargetRow.isPresent) {
                // do nothing
                return
            }

            // get target and check if this is a folder, otherwise get parent
            val dataProvider = event.getComponent().getDataProvider() as TreeDataProvider<Recording>
            val treeData = dataProvider.getTreeData()
            var tmpTarget = event.dropTargetRow.get

            if (tmpTarget.id > 0) {
                tmpTarget = treeData.getParent(tmpTarget)
            };

            val target = tmpTarget as Recording

            // create summary
            val builder = new StringBuilder
            builder.append(messages.recordingMoveTarget + ":\n").append(target.getCompleteRecName(target.folder)).append("\n\n")
            builder.append(messages.recordingMoveSource + ":\n")
            (event.dragData.get as Collection<Recording>).forEach[rec |
                if (rec.id == 0) {
                    builder.append(messages.recordingFolder + ": ")
                } else {
                    builder.append(messages.recordingFile + ": ")
                }
                builder.append(rec.folder).append("\n")
            ]

            try {
                MessageBox.createQuestion()
                    .withCaption(messages.recordingMoveConfirm)
                    .withMessage(builder.toString)
                    .withYesButton([
                            (event.dragData.get as Collection<Recording>).forEach[rec |
                                if (rec != target) {
                                    treeData.setParent(rec, target)
                                    moveRecording(rec)
                                }
                            ]
                            dataProvider.refreshAll
                        ], ButtonOption.caption(messages.recordingMoveCaption))
                    .withNoButton()
                    .open();

                dataProvider.refreshAll
            } catch (Exception e) {
                Notification.show(messages.recordingMoveFailed + e.message)
            }
        }]

        return this
    }

    def renameRecordingSvdrp(Recording rec, String newName) {
        // FIXME: There must be another solution. This is a bad hack.
        //        My validation experiments were not successful.
        val fixedName = newName.replaceAll("~", "").replaceAll("^\\.+", "")

        val completePath = getCompleteRecName(rec, fixedName)

        try {
            val response = svdrp.renameRecording(currentVdr, rec.id, completePath)

            rec.folder = fixedName
            treeGrid.dataProvider.refreshItem(rec)

            val result = HtmlSanitizer.clean(response.lines.stream.collect(Collectors.joining("\n")).replaceAll("\"", ""))
            Notification.show(result)
        } catch (Exception e) {
            // rename failed
            log.info("Rename failed: " + e.message)
            Notification.show(messages.recordingRenameFailed + e.message, Type.ERROR_MESSAGE)
        }
    }

    def deleteSelectedRecordings() {
        val toDeleteRecording = new ArrayList<Recording>

        treeGrid.selectedItems.stream.forEach(s | {
            toDeleteRecording.addAll(getAllRecording(s))
        })

        showDeleteConfirmDialog(toDeleteRecording)
    }

    def addFolder() {
        if (treeGrid.selectedItems.size == 0) {
            MessageBox.createInfo()
                .withCaption(messages.recordingCreateFolder)
                .withMessage(messages.recordingNoSelection)
                .open();
            return
        }

        val input = new TextField(messages.recordingFolderName);

        MessageBox.createQuestion()
            .withCaption(messages.recordingCreateFolder)
            .withMessage(input)
            .withOkButton([
                    val treeData = (treeGrid.dataProvider as TreeDataProvider<Recording>).treeData

                    treeGrid.selectedItems.stream.forEach(f | {
                        val folder = new Recording()
                        folder.folder = input.getValue()

                        val parent = if (f.id > 0) {
                            treeData.getParent(f)
                        } else {
                            f
                        }

                        treeData.addItem(parent, folder)
                        treeData.moveAfterSibling(folder, null)
                    })
                    treeGrid.dataProvider.refreshAll
                ], ButtonOption.caption(messages.recordingCreateFolder))
            .withCancelButton()
            .open();
    }

    def addRootFolder() {
        val input = new TextField("name");

        MessageBox.createQuestion()
            .withCaption(messages.recordingCreateRootFolder)
            .withMessage(input)
            .withOkButton([
                    val treeData = (treeGrid.dataProvider as TreeDataProvider<Recording>).treeData
                    val rootFolder = new Recording()
                    rootFolder.folder = input.getValue()
                    treeData.addItem(null, rootFolder)
                    treeData.moveAfterSibling(rootFolder, null)
                    treeGrid.dataProvider.refreshAll
                ], ButtonOption.caption(messages.recordingCreateFolder))
            .withCancelButton()
            .open();
    }

    private def getTreeDataProvider(List<Recording> list) {
        val treeData = new TreeData<Recording>

        addRecFolders(treeData, null, list)

        return new TreeDataProvider<Recording>(treeData);
    }

    private def void addRecFolders(TreeData<Recording> treeData, Recording parent, List<Recording> childs) {
        // split the list into recordings and folders
        val folders = childs.stream.filter(s | s.path.indexOf("~") != -1).collect(Collectors.toList()).sortBy[s | s.path.toLowerCase]
        val recs = childs.stream.filter(s | s.path.indexOf("~") == -1).collect(Collectors.toList()).sortBy[s | s.path.toLowerCase]

        // add folder
        if (folders.size > 0) {
            val recordingsInFolder = folders.stream() //
                .map(m | {
                        val idx = m.path.indexOf("~")
                        if (idx != -1) {
                            m.folder = m.path.substring(0, idx)
                            m.path = m.path.substring(idx + 1)
                        }
                        return m
                    })
                .collect(Collectors.groupingBy([m | m.folder], Collectors.toList()));

            recordingsInFolder.keySet.sort.forEach[s | {
                val newFolder = new Recording(s)
                val ch = recordingsInFolder.get(s)

                treeData.addItem(parent, newFolder)
                addRecFolders(treeData, newFolder, ch)

                newFolder.length = ch.stream().map(l | l.length).reduce(p1, p2| p1 + p2).get
                newFolder.childCount = ch.stream().map(l | l.childCount).reduce(p1, p2| p1 + p2).get
                newFolder.newCount = ch.stream().map(l | l.newCount).reduce(p1, p2| p1 + p2).get
            }]
        }

        // add recordings
        recs.stream.forEach(r | {
            r.folder = r.path
            r.childCount = 1
            r.newCount = if (r.seen) 0 else 1
            treeData.addItem(parent, r)
        })
    }

    private def createDuration(Recording rec) {
        val minutes = rec.length / 60
        return String.format("%02d:%02d", minutes / 60, minutes % 60)
    }

    private def createStart(Recording rec) {
        if (rec.start == 0) {
            return HtmlSanitizer.clean(messages.recFolderInfo(rec.childCount, rec.newCount))
        }

        var result = DateTimeUtil.toDate(rec.start, messages.formatDate) + " " + DateTimeUtil.toTime(rec.start, messages.formatTime)

        if (!rec.seen) {
            result = result + " " + VaadinIcons.STAR_O.html
        }

        return result
    }

    private def createActionButtons(Recording recording) {
        val treeData = (treeGrid.dataProvider as TreeDataProvider<Recording>).treeData
        var boolean tmpLevelUpButton

        // check if there are any recordings (not folders)
        if (recording.id <= 0) {
            val found = treeData.getChildren(recording).stream().filter(s | s.id > 0).findFirst
            if (!found.present) {
                // no recording found
                return null
            }
        }

        if (treeData.getParent(recording) !== null) {
            tmpLevelUpButton = treeData.getParent(recording) !== null
        }

        val levelUpButton = tmpLevelUpButton
        val layout = cssLayout[
            if (recording.id > 0) {
                button("") [
                    icon = VaadinIcons.PLAY
                    description = messages.recordingPlay
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | {
                        actionPlayRecording(recording)
                    })
                ]
            }

            button("") [
                icon = VaadinIcons.TRASH
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    showDeleteConfirmDialog(getAllRecording(recording))
                })
            ]

            if (levelUpButton) {
                button("") [
                    icon = VaadinIcons.LEVEL_UP
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | {
                        showlevelUpConfirmDialog(recording)
                    })
                ]
            }

        ]

        return layout
    }

    private def showDeleteConfirmDialog(List<Recording> toDeleteRecordings) {
        val builder = new StringBuilder

        if (toDeleteRecordings.size > 0) {
            toDeleteRecordings.stream.forEach(s | builder.append(getCompleteRecName(s, s.folder)).append("\n"))
        }

        MessageBox.createQuestion()
            .withCaption(messages.confirmDeletionCaption)
            .withMessage(builder.toString)
            .withYesButton([
                    toDeleteRecordings.stream.forEach(s | { deleteRecording(s) })
                    treeGrid.dataProvider.refreshAll
                ], ButtonOption.caption(messages.confirmDeletionYes))
            .withNoButton()
            .open();
    }

    private def showlevelUpConfirmDialog(Recording recording) {
        MessageBox.createQuestion()
            .withCaption(messages.recordingConfirmLevelUpCaption)
            .withMessage(messages.recordingLevelUp(recording.folder))
            .withYesButton([
                    levelUpRecording(recording)
                    treeGrid.dataProvider.refreshAll
                ], ButtonOption.caption(messages.confirmLevelUpYes))
            .withNoButton()
            .open();
    }

    private def deleteRecording(Recording rec) {
        svdrp.deleteRecording(currentVdr, rec)

        // update all parent folder
        val newDec = if (rec.seen) 0 else 1
        var parent = treeGrid.treeData.getParent(rec)
        while (parent !== null) {
            parent.childCount = parent.childCount - 1
            parent.newCount = parent.newCount - newDec

            parent = treeGrid.treeData.getParent(parent)
        }

        // delete now the recording in TreeGrid
        treeGrid.treeData.removeItem(rec)
    }

    private def moveRecording(Recording rec) {
        // collect all new recordings
        val map = new HashMap<Long, String>
        moveRecordingSvdrp(rec, map)

        svdrp.batchRenameRecording(currentVdr, map)
    }

    private def levelUpRecording(Recording recording) {
        val data = treeGrid.treeData
        var Recording parent

        try {
            parent = data.getParent(data.getParent(recording))
        } catch (Exception e) {
            Notification.show(messages.recordingLevelUpImpossible)
        }

        data.setParent(recording, parent)
        moveRecording(recording)
    }

    private def void moveRecordingSvdrp(Recording rec, HashMap<Long, String> result) {
        if (rec.id > 0) {
            // check if the name already exists, otherwise append a number
            var i = 1
            var name = rec.folder
            while (countFolder(rec, name) > 1) {
                name = rec.folder + " (" + i + ")"
                i = i + 1
            }
            rec.folder = name

            // simple recording
            log.fine("Move: " + rec.id + " to " + rec.getCompleteRecName(name))
            result.put(rec.id, rec.getCompleteRecName(name))
        } else if (treeGrid.treeData.getChildren(rec).size > 0) {
            // it's a folder with children
            treeGrid.treeData.getChildren(rec).forEach[r |
                moveRecordingSvdrp(r, result)
            ]
        }
    }

    private def getAllRecording(Recording rec) {
        if (rec.id > 0) {
            return #[rec]
        } else {
            val treeData = (treeGrid.dataProvider as TreeDataProvider<Recording>).treeData
            return treeData.getChildren(rec).stream.filter(s | s.id > 0).collect(Collectors.toList)
        }
    }

    private def getShowEpgDetails(ItemClick<Recording> click) {
        val rec = click.item

        if ((click.column.id == COLUMN_DURATION || click.column.id == COLUMN_START) && (rec.id > 0)) {
            if (rec.epg === null) {
                svdrp.getRecordingEpg(currentVdr, rec)
            }
            UI.current.addWindow(epgDetails.showWindow(null, currentVdr, rec.epg, false))
        }
    }

    private def getCompleteRecName(Recording rec, String lastPart) {
        val treeData = (treeGrid.dataProvider as TreeDataProvider<Recording>).treeData

        var completePath = lastPart
        var Recording parent = treeData.getParent(rec)
        while(parent !== null) {
            completePath = parent.folder + "~" + completePath
            parent = treeData.getParent(parent)
        }

        return completePath
    }

    private def countFolder(Recording rec, String folder) {
        val parent = (treeGrid.dataProvider as TreeDataProvider<Recording>).treeData.getParent(rec)
        val children = treeGrid.treeData.getChildren(parent)

        return children.filter[s | s.folder == folder].size
    }

    def actionPlayRecording(Recording recording) {
        try {
            svdrp.playRecording(currentVdr, recording)
        } catch (Exception e) {
            Notification.show(messages.epgErrorSwitchFailed, Type.ERROR_MESSAGE)
        }
    }
}

