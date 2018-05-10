package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.data.TreeData
import com.vaadin.data.provider.TreeDataProvider
import com.vaadin.event.selection.SelectionEvent
import com.vaadin.icons.VaadinIcons
import com.vaadin.shared.ui.dnd.DropEffect
import com.vaadin.shared.ui.dnd.EffectAllowed
import com.vaadin.shared.ui.grid.DropMode
import com.vaadin.ui.AbstractComponent
import com.vaadin.ui.Button
import com.vaadin.ui.Grid
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.HorizontalSplitPanel
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.Panel
import com.vaadin.ui.TextField
import com.vaadin.ui.TreeGrid
import com.vaadin.ui.UI
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.components.grid.GridDragSource
import com.vaadin.ui.components.grid.HeaderCell
import com.vaadin.ui.components.grid.TreeGridDragSource
import com.vaadin.ui.components.grid.TreeGridDropTarget
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.renderers.HtmlRenderer
import com.vaadin.ui.themes.ValoTheme
import de.steinwedel.messagebox.ButtonOption
import de.steinwedel.messagebox.MessageBox
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.stream.Collectors
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.TreeRecording
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.ui.RecordingView
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.web.util.RecordingUtil
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
@ViewScoped
@SuppressWarnings("unchecked", "serial")
class RecordingComponent {
    @Inject
    Messages messages

    @Inject
    Svdrp svdrp

    @Inject
    EpgDetailsWindow epgDetails

    var TreeGrid<TreeRecording> treeGrid
    var Grid<TreeRecording> grid
    var VDR currentVdr

    var TreeRecording selectedParent

    var HeaderCell startCell
    var HeaderCell durationCell

    var layout = new VerticalLayout

    def getComponent() {
        return layout
    }

    @PostConstruct
    def createMainComponent() {
        layout.setSizeFull();
        layout.setMargin(false);

        createTreeGrid(new ArrayList<TreeRecording>)
        createGrid(new ArrayList<TreeRecording>)

        createDragnDrop

        val panel = new Panel()
        val hsplit = new HorizontalSplitPanel();
        panel.setContent(hsplit);

        hsplit.firstComponent = treeGrid
        hsplit.secondComponent = grid

        hsplit.setSplitPosition(30.0f, false)

        layout.addComponentsAndExpand(panel)
    }

    def setParent(RecordingView parent) {
        return this
    }

    def setCurrentVdr(VDR vdr) {
        this.currentVdr = vdr
        return this
    }

    def updateRecordingList(List<Recording> recordings) {
        treeGrid.dataProvider = getTreeDataProvider(RecordingUtil.getTreeRecording(recordings))
        try {
            val rootItem = (treeGrid.getDataProvider() as TreeDataProvider<TreeRecording>).treeData.rootItems.get(0)
            treeGrid.expand(rootItem)
            treeGrid.select(rootItem)
        } catch (Exception e) {
            // ignore
        }
    }

    private def void createTreeGrid(List<TreeRecording> files) {
        // create treeGrid
        treeGrid = new TreeGrid<TreeRecording>();
        treeGrid.dataProvider = getTreeDataProvider(files)

        treeGrid.addColumn([s | s.name]) //
            .setCaption("Name") //
            .setId("NAME") //
            .setSortable(true) //
            .setEditorComponent(new TextField(), [ TreeRecording s, String b | rename(s, b) ]) //
            .editable = true

        treeGrid.addSelectionListener(f | selectTreeFolder(f))

        treeGrid.editor.enabled = true

        treeGrid.setSizeFull
    }

    private def void createGrid(List<TreeRecording> files) {
        grid = new Grid<TreeRecording>();
        grid.items = files

        grid.addColumn(f| getNameButton(f) ) //
            .setRenderer(new ComponentRenderer) //
            .setId("BUTTON") //
            .setExpandRatio(0) //
            .setMinimumWidthFromContent(true)

        grid.addColumn(f| f.name) //
            .setCaption(messages.captionRecName) //
            // .setRenderer(new ComponentRenderer) //
            .setId("NAME") //
            .setExpandRatio(1) //
            .setEditorComponent(new TextField(), [ TreeRecording s, String b | rename(s, b) ]) //
            .setMinimumWidthFromContent(true)
            .setStyleGenerator(ev | "wlb")

        grid.addColumn(f| createStart(f)) //
            .setCaption(messages.captionRecStart) //
            .setRenderer(new HtmlRenderer) //
            .setId("START") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)
            .sortable = false

        grid.addColumn(f| createDuration(f)) //
            .setCaption(messages.captionRecDuration) //
            //.setRenderer(new ComponentRenderer) //
            .setId("DURATION") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)
            .sortable = false

        grid.addColumn(f| createAction(f)) //
            .setCaption(messages.captionRecAction) //
            .setRenderer(new ComponentRenderer) //
            .setId("ACTION") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)
            .sortable = false

        grid.defaultHeaderRow.getCell("NAME").styleName = "wlb_header"

        startCell = grid.getHeaderRow(0).getCell("START")
        durationCell = grid.getHeaderRow(0).getCell("DURATION")

        grid.selectionMode = SelectionMode.MULTI
        grid.editor.enabled = true

        grid.setSizeFull
    }

    def createStart(TreeRecording treeRec) {
        if (treeRec.folder) {
            return HtmlSanitizer.clean(messages.recFolderInfo(treeRec.childCount, treeRec.newCount))
        } else {
            val rec = treeRec.recording
            var result = DateTimeUtil.toDate(rec.start, messages.formatDate) + " " + DateTimeUtil.toTime(rec.start, messages.formatTime)

            if (!rec.seen) {
                result = result + " " + VaadinIcons.STAR_O.html
            }

            return result
        }
    }

    def createDuration(TreeRecording treeRec) {
        if (treeRec.folder) {
            val minutes = treeRec.length / 60
            return String.format("%02d:%02d", minutes / 60, minutes % 60)
        } else {
            val minutes = treeRec.recording.length / 60
            return String.format("%02d:%02d", minutes / 60, minutes % 60)
        }
    }

    def createAction(TreeRecording treeRec) {
        val layout = cssLayout[
            if (!treeRec.isFolder) {
                button("") [
                    icon = VaadinIcons.PLAY
                    description = messages.recordingPlay
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | {
                        actionPlayRecording(treeRec.recording)
                    })
                ]
            }

            button("") [
                icon = VaadinIcons.TRASH
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    delete(treeRec)
                })
            ]
        ]

        return layout
    }

    def rename(TreeRecording recording, String newName) {
        recording.name = newName

        rename(getChangedFiles(recording))

        treeGrid.dataProvider.refreshItem(recording)
        grid.dataProvider.refreshItem(recording)
    }

    def void deleteSelected() {
        MessageBox.createQuestion()
            .withCaption(messages.confirmDeletionCaption)
            .withMessage(messages.confirmDeletionCaption)
            .withYesButton([
                grid.selectedItems.stream.forEach(s | {
                    delete(s)
                })
                ], ButtonOption.caption(messages.confirmDeletionYes))
            .withNoButton()
            .open();
    }

    def selectTreeFolder(SelectionEvent<TreeRecording> event) {
        if (event.firstSelectedItem.isPresent) {
            val selected = event.firstSelectedItem.get

            startCell.setText(HtmlSanitizer.clean(messages.recFolderInfo(selected.childCount, selected.newCount)))

            val minutes = selected.length / 60
            durationCell.setText(String.format("%02d:%02d", minutes / 60, minutes % 60))

            selectedParent = selected
            grid.items = selected.children
            grid.recalculateColumnWidths

            treeGrid.expand(selectedParent)
        }
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
                    val treeData = (treeGrid.dataProvider as TreeDataProvider<TreeRecording>).treeData
                    val newFolder = new TreeRecording(input.getValue())
                    selectedParent.children.add(newFolder)

                    treeData.addItem(selectedParent, newFolder)

                    treeGrid.dataProvider.refreshAll
                    grid.dataProvider.refreshAll
                ], ButtonOption.caption(messages.recordingCreateFolder))
            .withCancelButton()
            .open();
    }

    private def getTreeDataProvider(List<TreeRecording> list) {
        val treeData = new TreeData<TreeRecording>

        addFolders(treeData, null, list)

        return new TreeDataProvider<TreeRecording>(treeData);
    }

    private def void addFolders(TreeData<TreeRecording> treeData, TreeRecording parent, List<TreeRecording> childs) {
        if (childs === null) {
            return
        }

        childs.stream().filter(c | c.folder).forEach(c | {
            treeData.addItem(parent, c)

            if (c.children !== null) {
                addFolders(treeData, c, c.children)
            }
        })
    }

    private def createDragnDrop() {
        // treeGrid DragSource

        val folderDragSource = new TreeGridDragSource<TreeRecording>(treeGrid);
        folderDragSource.addGridDragStartListener[ s | folderDragSource.dragData = s.draggedItems ]
        folderDragSource.effectAllowed = EffectAllowed.MOVE;

        val folderDropTarget = new TreeGridDropTarget<TreeRecording>(treeGrid, DropMode.ON_TOP)
        folderDropTarget.dropEffect = DropEffect.MOVE;

        // grid DragSource

        val gridDragSource = new GridDragSource<TreeRecording>(grid);
        gridDragSource.addGridDragStartListener[ s | gridDragSource.dragData = s.draggedItems ]
        gridDragSource.effectAllowed = EffectAllowed.MOVE;

        // treeGrid DropTaget

        folderDropTarget.addGridDropListener[ event | {
            val dragSource = event.getDragSourceComponent()
            if (dragSource.isPresent) {
                if (!event.dragData.isPresent || !event.dropTargetRow.isPresent) {
                    return
                }

                val target = event.dropTargetRow.get
                val dataProvider = event.getComponent().getDataProvider() as TreeDataProvider<TreeRecording>
                val treeData = dataProvider.getTreeData()

                val dragData = (event.dragData.get as List<TreeRecording>)

                MessageBox
                    .createQuestion()
                    .withCaption(messages.recordingMoveConfirm)
                    .withMessage(messages.recordingMoveConfirm)
                    .withYesButton([ moveRecordings(dragSource, target, dataProvider, treeData, dragData) ], ButtonOption.caption(messages.recordingMoveCaption))
                    .withNoButton()
                    .asModal(true)
                    .open();
            }
        }]
    }

    private def void moveRecordings(Optional<AbstractComponent> dragSource, TreeRecording target, TreeDataProvider<TreeRecording> dataProvider, TreeData<TreeRecording> treeData, List<TreeRecording> dragData) {
        for (var int i = 0; i < dragData.size; i++) {
            val source = dragData.get(i)

            if (source !== target && !target.children.contains(source)) {
                if (dragSource.get() instanceof TreeGrid<?>) {
                    // drag and drop within the treeGrid
                    treeData.getParent(source).children.remove(source)
                    treeData.setParent(source, target)
                    target.children.add(source)

                    treeGrid.dataProvider.refreshAll
                    grid.dataProvider.refreshAll

                    rename(getChangedFiles(source))
                } else if (dragSource.get() instanceof Grid<?>) {
                    // drag and drop from grid to treeGrid
                    if (source.isFolder) {
                        treeData.getParent(source).children.remove(source)
                        treeData.setParent(source, target)
                    } else {
                        selectedParent.children.remove(source)
                    }

                    target.children.add(source)

                    treeGrid.dataProvider.refreshAll
                    grid.dataProvider.refreshAll

                    rename(getChangedFiles(source))
                }
            }
        }
    }

    private def showEpgDetails(TreeRecording rec) {
        if (rec.recording.epg === null) {
            svdrp.getRecordingEpg(currentVdr, rec.recording)
        }

        try {
            UI.current.addWindow(epgDetails.showWindow(null, currentVdr, rec.recording.epg, false, rec.recording.id))
        } catch (Exception e) {
            // Ignore this message: Window is already attached to an application.
        }
    }

    private def actionPlayRecording(Recording recording) {
        try {
            svdrp.playRecording(currentVdr, recording)
        } catch (Exception e) {
            Notification.show(messages.epgErrorSwitchFailed, Type.ERROR_MESSAGE)
        }
    }

    private def void delete(TreeRecording rec) {
        val deleteResult = new HashMap<Long, String>
        createFileNames(deleteResult, rec, rec.name);

        if (log.isDebugEnabled) {
            deleteResult.keySet.stream().forEach(s | println(String.format("Delete %d %s", s, deleteResult.get(s))))
        }

        selectedParent.children.remove(rec)

        try {
            treeGrid.treeData.removeItem(rec)
        } catch (Exception e) {
            // rec shall be deleted, but if it's already deleted, this error can be ignored
        }

        treeGrid.dataProvider.refreshAll
        grid.dataProvider.refreshAll

        svdrp.deleteRecordings(currentVdr, deleteResult.keySet)
    }

    private def void rename(Map<Long, String> recordings) {
        if (log.isDebugEnabled) {
            recordings.keySet.stream().forEach(s | println(String.format("Rename %d to %s", s, recordings.get(s))))
        }

        svdrp.renameRecordings(currentVdr, recordings)
    }

    private def getChangedFiles(TreeRecording rec) {
        val changedResult = new ArrayList<TreeRecording>
        getChangedFiles(changedResult, rec)

        val changedIds = changedResult.stream.map(s | s.recording.id).collect(Collectors.toSet)

        val allFileNames = new HashMap<Long, String>
        val root = (treeGrid.dataProvider as  TreeDataProvider<TreeRecording>).treeData.rootItems.get(0)
        createFileNames(allFileNames, root, "")

        // filter all changed filenames
        return allFileNames.keySet.stream.filter(s | changedIds.contains(s)).collect(Collectors.toMap([s|s], [s | allFileNames.get(s)]))
    }

    private def void getChangedFiles(List<TreeRecording> result, TreeRecording rec) {
        if (!rec.isFolder) {
            result.add(rec)
        } else {
            rec.children.stream.forEach(s | getChangedFiles(result, s))
        }
    }

    private def void createFileNames(Map<Long, String> result, TreeRecording root, String prefix) {
        if (root.isFolder) {
            root.children.stream.forEach(s | {
                createFileNames(result, s, (if (prefix.length > 0) prefix + "~" else prefix) + s.name)
            })
        } else {
            result.put(root.recording.id, prefix)
        }
    }

    private def getNameButton(TreeRecording rec) {
        val button = new Button("")

        if (rec.folder) {
            button.icon = VaadinIcons.FOLDER
            button.addClickListener(s | {
                treeGrid.expand(rec)
                treeGrid.select(rec)
            })
        } else {
            button.icon = VaadinIcons.FILE_MOVIE
            button.addClickListener(s | {
                showEpgDetails(rec)
            })
        }

        button.description = ""
        button.width = "22px"
        button.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

        return button
    }
}
