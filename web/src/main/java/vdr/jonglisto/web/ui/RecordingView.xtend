package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Alignment
import com.vaadin.ui.Button
import com.vaadin.ui.Grid
import com.vaadin.ui.Label
import com.vaadin.ui.Layout
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.TabSheet
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.renderers.HtmlRenderer
import com.vaadin.ui.themes.ValoTheme
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.VDR
import vdr.jonglisto.model.VDRDiskStat
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.RecordingTreeGrid
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*
import vdr.jonglisto.web.ui.component.RecordingComponent

@Log("jonglisto.web")
@CDIView(MainUI.RECORDING_VIEW)
class RecordingView extends BaseView {

    @Inject
    private RecordingComponent recordingTreeGrid

    private Grid<Recording> deleteGrid

    var Label sizeLabel
    var Layout layout

    @PostConstruct
    def void init() {
        super.init(BUTTON.RECORDING)
    }

    public def reloadRecordings() {
        changeVdr(selectedVdr)
    }

    protected override createMainComponents() {
        val tabsheet = new TabSheet
        tabsheet.setSizeFull
        tabsheet.addStyleName(ValoTheme.TABSHEET_FRAMED);
        tabsheet.addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);

        val recLayout = verticalLayout[
            layout = horizontalLayout2[
                width = "100%"
                button(messages.recordingRefresh) [
                    setSizeUndefined
                    icon = VaadinIcons.REFRESH
                    addClickListener(s | {
                        changeVdr(selectedVdr)
                    })
                ]

                val b1 = button(messages.recordingAddFolder) [
                    setSizeUndefined
                    icon = VaadinIcons.FOLDER_ADD
                    addClickListener(s | {
                        recordingTreeGrid.addFolder
                    })
                ]

                val b3 = button(messages.recordingDeleteSelected) [
                    setSizeUndefined
                    icon = VaadinIcons.TRASH
                    addClickListener(s | {
                        recordingTreeGrid.deleteSelected
                    })
                ]

                sizeLabel = label("0") [ ]

                setComponentAlignment(b1, Alignment.MIDDLE_LEFT)
                setComponentAlignment(b3, Alignment.MIDDLE_LEFT)
                setComponentAlignment(sizeLabel, Alignment.MIDDLE_RIGHT)
                setExpandRatio(sizeLabel, 4.0f)
            ]

            addComponent(layout)

            recordingTreeGrid.setParent(this).setCurrentVdr(selectedVdr).updateRecordingList(svdrp.getRecordings(selectedVdr))

            addComponentsAndExpand(recordingTreeGrid.getComponent())
            updateSizeLabel(selectedVdr)
        ]

        val delRecLayout = verticalLayout[
            layout = horizontalLayout2[
                // width = "100%"
                button(messages.recordingRefresh) [
                    setSizeUndefined
                    icon = VaadinIcons.REFRESH
                    addClickListener(s | {
                        changeVdr(selectedVdr)
                    })
                ]
            ]

            addComponent(layout)

            deleteGrid = new Grid<Recording>
            deleteGrid.addColumn([s | s.path]) //
                .setCaption(messages.captionRecName) //
                .setId("NAME") //
                .setSortable(true)

            deleteGrid.addColumn([s | createStart(s)]) //
                .setRenderer(new HtmlRenderer) //
                .setCaption(messages.captionRecStart) //
                .setId("START") //
                .sortable = false

            deleteGrid.addColumn([s | createDuration(s)]) //
                .setCaption(messages.captionRecDuration) //
                .setId("DURATION") //
                .sortable = false

            deleteGrid.addColumn([s | createActionButtons(s)]) //
                .setRenderer(new ComponentRenderer)
                .setCaption(messages.captionRecAction) //
                .setId("ACTION") //
                .sortable = false

            deleteGrid.setSizeFull

            addComponentsAndExpand(deleteGrid)
        ]


        tabsheet.addTab(recLayout, messages.recordingCaptionRec)
        tabsheet.addTab(delRecLayout, messages.recordingCaptionDelrec)

        addComponentsAndExpand(tabsheet)
    }

    override protected def void changeVdr(VDR vdr) {
        if (recordingTreeGrid !== null) {
            recordingTreeGrid.updateRecordingList(svdrp.getRecordings(vdr))
            recordingTreeGrid.currentVdr = vdr
        } else {
            recordingTreeGrid.setParent(this).setCurrentVdr(selectedVdr).updateRecordingList(svdrp.getRecordings(selectedVdr))
        }

        if (deleteGrid !== null) {
            deleteGrid.items = svdrp.getDeletedRecordings(vdr)
        }

        updateSizeLabel(vdr)
    }

    private def void updateSizeLabel(VDR vdr) {
        if (layout !== null && vdr !== null) {
            var VDRDiskStat stat
            try {
                stat = svdrp.getStat(vdr)
            } catch (Exception e) {
                // VDR is not running
                stat = new VDRDiskStat(0, 0)
            }

            val newSizeLabel = new Label("Total: " + stat.toStringTotal + ", Free: " + stat.toStringFree + " (" + stat.toStringUsedPerc + "%)")

            layout.replaceComponent(sizeLabel, newSizeLabel)
            sizeLabel = newSizeLabel
        }
    }

        private def createDuration(Recording rec) {
        val minutes = rec.length / 60
        return String.format("%02d:%02d", minutes / 60, minutes % 60)
    }

    private def createStart(Recording rec) {
        var result = DateTimeUtil.toDate(rec.start, messages.formatDate) + " " + DateTimeUtil.toTime(rec.start, messages.formatTime)

        if (!rec.seen) {
            result = result + " " + VaadinIcons.STAR_O.html
        }

        return result
    }

    private def createActionButtons(Recording recording) {
        val undeleteButton = new Button()
        undeleteButton.icon = VaadinIcons.RECYCLE
        undeleteButton.description = messages.recordingUndelete
        undeleteButton.width = "22px"
        undeleteButton.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

        undeleteButton.addClickListener(s | {
            try {
                svdrp.undeleteRecording(selectedVdr, recording)
                deleteGrid.items = svdrp.getDeletedRecordings(selectedVdr)
            } catch (Exception e) {
                log.info("undelete failed", e)
                Notification.show(messages.recordingErrorUndelete, Type.ERROR_MESSAGE)
            }
        })

        return undeleteButton
    }

}
