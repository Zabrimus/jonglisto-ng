package vdr.jonglisto.web.ui

import com.vaadin.icons.VaadinIcons
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.ui.component.TimerGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class TimerView extends BaseView {

    var TimerGrid timerGrid

    new() {
        super(BUTTON.TIMER)
    }

    protected override createMainComponents() {
        horizontalLayout[
            button(messages.timerRefresh) [
                icon = VaadinIcons.REFRESH
                addClickListener(s | {
                    changeVdr(selectedVdr)
                })
            ]

            button(messages.timerNewTimer) [
                icon = VaadinIcons.PLUS
                addClickListener(s | {
                    timerGrid.createNewTimer
                })
            ]

            button(messages.timerDeleteSelected) [
                icon = VaadinIcons.TRASH
                addClickListener(s | {
                    timerGrid.deleteSelectedTimer
                })
            ]
        ]

        prepareGrid
    }

    override protected def void changeVdr(VDR vdr) {
        if (timerGrid !== null) {
            val timers = SvdrpClient.get.getTimer(selectedVdr)
            timerGrid.grid.items = timers
            timerGrid.grid.getDataProvider().refreshAll();
            timerGrid.grid.recalculateColumnWidths
            timerGrid.currentVdr = vdr
        }
    }

    private def prepareGrid() {
        var idx = -1

        if ((timerGrid !== null) && (timerGrid.grid !== null)) {
           idx = timerGrid.grid.componentIndex
        }

        timerGrid = new TimerGrid(selectedVdr, messages)
        timerGrid.setTimer(SvdrpClient.get.getTimer(selectedVdr)).createGrid()
        timerGrid.grid.setSizeFull

        addComponentsAndExpand(timerGrid.grid)
    }

}
