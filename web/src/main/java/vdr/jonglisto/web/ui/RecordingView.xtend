package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Alignment
import com.vaadin.ui.Label
import com.vaadin.ui.Layout
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.RecordingTreeGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.RECORDING_VIEW)
class RecordingView extends BaseView {

    @Inject
    private RecordingTreeGrid recordingTreeGrid

    var Label sizeLabel
    var Layout layout

    @PostConstruct
    def void init() {
        super.init(BUTTON.RECORDING)
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
        if (recordingTreeGrid.treeGrid !== null) {
            recordingTreeGrid.recordings = svdrp.getRecordings(vdr)
            recordingTreeGrid.currentVdr = vdr
        } else {
            recordingTreeGrid.setCurrentVdr(selectedVdr).createTreeGrid(svdrp.getRecordings(selectedVdr))
        }

        updateSizeLabel(vdr)
    }

    private def prepareTreeGrid() {
        recordingTreeGrid.setCurrentVdr(selectedVdr).createTreeGrid(svdrp.getRecordings(selectedVdr))
        val grid = recordingTreeGrid.treeGrid
        grid.setSizeFull

        addComponentsAndExpand(grid)

        updateSizeLabel(selectedVdr)
    }

    private def void updateSizeLabel(VDR vdr) {
        if (layout !== null) {
            val stat = svdrp.getStat(vdr)
            val newSizeLabel = new Label("Total: " + stat.toStringTotal + ", Free: " + stat.toStringFree + " (" + stat.toStringFreePerc + "%)")

            layout.replaceComponent(sizeLabel, newSizeLabel)
            sizeLabel = newSizeLabel
        }
    }
}
