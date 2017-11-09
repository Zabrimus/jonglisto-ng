package vdr.jonglisto.web.ui

import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Alignment
import com.vaadin.ui.DateField
import com.vaadin.ui.HorizontalLayout
import java.time.LocalDate
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.util.TimerOverlap
import vdr.jonglisto.web.ui.component.TimeLine
import vdr.jonglisto.web.ui.component.TimerGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class TimerView extends BaseView {

    var TimerGrid timerGrid
    var TimeLine timeLine
    var DateField  timeLineDateField
    var HorizontalLayout timeLineLayout

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

        timeLineLayout = horizontalLayout[
            width = "100%"
            timeLine = new TimeLine(800, LocalDate.now, SvdrpClient.get.getTimer(selectedVdr))
            addComponent(timeLine)
            setComponentAlignment(timeLine, Alignment.MIDDLE_CENTER);

            timeLineDateField = new DateField(messages.timerDate, LocalDate.now) => [
                addValueChangeListener(it | refreshTimeLine)
            ]

            addComponent(timeLineDateField)
        ]

        timeLineLayout.setExpandRatio(timeLine, 2.0f)

        prepareGrid
    }

    override protected def void changeVdr(VDR vdr) {
        if (timerGrid !== null) {
            val timers = SvdrpClient.get.getTimer(selectedVdr)
            timerGrid.grid.items = timers
            timerGrid.grid.getDataProvider().refreshAll();
            timerGrid.grid.recalculateColumnWidths
            timerGrid.currentVdr = vdr

            val overlap = new TimerOverlap(8, SvdrpClient.get.channels)
            overlap.addTimer(timers)
            overlap.collisions
        }

        refreshTimeLine()
    }

    private def refreshTimeLine() {
        if (timeLineLayout !== null) {
            var selDate = timeLineDateField.value
            if (selDate === null) {
                selDate = LocalDate.now
            }

            val oldTimeLine = timeLine
            timeLine = new TimeLine(800, selDate, SvdrpClient.get.getTimer(selectedVdr))

            timeLineLayout.replaceComponent(oldTimeLine, timeLine)
            timeLineLayout.setComponentAlignment(timeLine, Alignment.MIDDLE_CENTER);
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
