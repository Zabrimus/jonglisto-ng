package vdr.jonglisto.web.ui

import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Alignment
import com.vaadin.ui.Label
import com.vaadin.ui.Layout
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.ui.component.RecordingTreeGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class RecordingView extends BaseView {

    var Label sizeLabel
    var Layout layout
    var RecordingTreeGrid recordingTreeGrid

    new() {
        super(BUTTON.RECORDING)
    }

    protected override createMainComponents() {
        layout = horizontalLayout[
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

            val b2 = button(messages.recordingAddRootFolder) [
                setSizeUndefined
                icon = VaadinIcons.FOLDER_ADD
                addClickListener(s | {
                    recordingTreeGrid.addRootFolder
                })
            ]

            val b3 = button(messages.recordingDeleteSelected) [
                setSizeUndefined
                icon = VaadinIcons.TRASH
                addClickListener(s | {
                    recordingTreeGrid.deleteSelectedRecordings
                })
            ]

            sizeLabel = label("0") [ ]

            setComponentAlignment(b1, Alignment.MIDDLE_LEFT)
            setComponentAlignment(b2, Alignment.MIDDLE_LEFT)
            setComponentAlignment(b3, Alignment.MIDDLE_LEFT)
            setComponentAlignment(sizeLabel, Alignment.MIDDLE_RIGHT)
            setExpandRatio(sizeLabel, 4.0f)
        ]

        prepareTreeGrid
    }

    override protected def void changeVdr(VDR vdr) {
        if (recordingTreeGrid !== null) {
            recordingTreeGrid.recordings = SvdrpClient.get.getRecordings(vdr)
            recordingTreeGrid.currentVdr = vdr
        }

        updateSizeLabel(vdr)
    }

     private def prepareTreeGrid() {
        recordingTreeGrid = new RecordingTreeGrid(selectedVdr, messages)
        val grid = recordingTreeGrid.createTreeGrid(SvdrpClient.get.getRecordings(selectedVdr))
        grid.setSizeFull

        addComponentsAndExpand(grid)

        updateSizeLabel(selectedVdr)
    }

    private def void updateSizeLabel(VDR vdr) {
        if (layout !== null) {
            val stat = SvdrpClient.get.getStat(vdr)
            val newSizeLabel = new Label("Total: " + stat.toStringTotal + ", Free: " + stat.toStringFree + " (" + stat.toStringFreePerc + "%)")

            log.error("Layout: " + layout)
            log.error("size: " + sizeLabel)

            layout.replaceComponent(sizeLabel, newSizeLabel)
            sizeLabel = newSizeLabel
        }
    }
}
