package vdr.jonglisto.web.ui

import com.vaadin.icons.VaadinIcons
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.ui.component.RecordingTreeGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class RecordingView extends BaseView {

    var RecordingTreeGrid recordingTreeGrid

    new() {
        super(BUTTON.RECORDING)
    }

    protected override createMainComponents() {
        horizontalLayout[
            button(messages.recordingRefresh) [
                icon = VaadinIcons.REFRESH
                addClickListener(s | {
                    changeVdr(selectedVdr)
                })
            ]

            button(messages.recordingAddFolder) [
                icon = VaadinIcons.FOLDER_ADD
                addClickListener(s | {
                    recordingTreeGrid.addFolder
                })
            ]

            button(messages.recordingAddRootFolder) [
                icon = VaadinIcons.FOLDER_ADD
                addClickListener(s | {
                    recordingTreeGrid.addRootFolder
                })
            ]

            button(messages.recordingDeleteSelected) [
                icon = VaadinIcons.TRASH
                addClickListener(s | {
                    recordingTreeGrid.deleteSelectedRecordings
                })
            ]
        ]

        prepareTreeGrid
    }

    override protected def void changeVdr(VDR vdr) {
        if (recordingTreeGrid !== null) {
            recordingTreeGrid.recordings = SvdrpClient.get.getRecordings(vdr)
            recordingTreeGrid.currentVdr = vdr
        }
    }

     private def prepareTreeGrid() {
        recordingTreeGrid = new RecordingTreeGrid(selectedVdr, messages)
        val grid = recordingTreeGrid.createTreeGrid(SvdrpClient.get.getRecordings(selectedVdr))
        grid.setSizeFull

        addComponentsAndExpand(grid)
    }
}
