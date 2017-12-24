package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Alignment
import com.vaadin.ui.DateField
import com.vaadin.ui.HorizontalLayout
import java.time.LocalDate
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.TimerOverlap
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.TimeLine
import vdr.jonglisto.web.ui.component.TimerGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.TIMER_VIEW)
class TimerView extends BaseView {

    @Inject
    private TimerGrid timerGrid

    var TimeLine timeLine
    var DateField  timeLineDateField
    var HorizontalLayout timeLineLayout

    @PostConstruct
    def void init() {
        super.init(BUTTON.TIMER)
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
            timeLine = new TimeLine().setSvdrp(svdrp).setComponentWidth(800).setDate(LocalDate.now).setTimer(svdrp.getTimer(selectedVdr))
            timeLine.createComposite

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
        if (timerGrid.grid !== null) {
            val timers = svdrp.getTimer(selectedVdr)
            timerGrid.grid.items = timers
            timerGrid.grid.getDataProvider().refreshAll();
            timerGrid.grid.recalculateColumnWidths
            timerGrid.currentVdr = vdr

            val overlap = new TimerOverlap(8, svdrp.channels)
            overlap.addTimer(timers)
            overlap.collisions
        } else {
            timerGrid.setCurrentVdr(selectedVdr).setTimer(svdrp.getTimer(selectedVdr)).createGrid()
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
            timeLine = new TimeLine().setSvdrp(svdrp).setComponentWidth(800).setDate(selDate).setTimer(svdrp.getTimer(selectedVdr))
            timeLine.createComposite

            timeLineLayout.replaceComponent(oldTimeLine, timeLine)
            timeLineLayout.setComponentAlignment(timeLine, Alignment.MIDDLE_CENTER);
        }
    }

    private def prepareGrid() {
        /*
        var idx = -1

        if ((timerGrid !== null) && (timerGrid.grid !== null)) {
           idx = timerGrid.grid.componentIndex
        }
        */

        timerGrid.setCurrentVdr(selectedVdr).setTimer(svdrp.getTimer(selectedVdr)).createGrid()
        addComponentsAndExpand(timerGrid.grid)
    }

}
