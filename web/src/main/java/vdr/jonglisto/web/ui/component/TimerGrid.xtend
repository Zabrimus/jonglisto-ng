package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.data.provider.ListDataProvider
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Grid
import com.vaadin.ui.Grid.ItemClick
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.Label
import com.vaadin.ui.Notification
import com.vaadin.ui.UI
import com.vaadin.ui.Window.CloseEvent
import com.vaadin.ui.Window.CloseListener
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.themes.ValoTheme
import java.util.Collections
import java.util.List
import javax.inject.Inject
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.util.ChannelLogoSource
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@ViewScoped
class TimerGrid {

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    @Inject
    private EpgDetailsWindow epgDetails

    @Inject
    private TimerEditWindow timerEdit

    val COL_CHANNEL = "channel"
    val COL_ACTIVE = "active"
    val COL_DATE = "date"
    val COL_START = "start"
    val COL_END = "end"
    val COL_DURATION = "duration"
    val COL_TITLE = "title"
    val COL_ACTION = "action"

    var Grid<Timer> grid

    var List<Timer> timer = Collections.emptyList

    var VDR currentVdr

    def setTimer(List<Timer> timer) {
        this.timer = timer
        return this
    }

    def setCurrentVdr(VDR vdr) {
        currentVdr = vdr
        return this
    }

    def getGrid() {
        return grid
    }

    def createGrid() {
        grid = new Grid
        grid.items = timer
        grid.setSizeFull

        grid.addColumn(ev| createTimerActive(ev)) //
                .setCaption(messages.timerActiveCaption) //
                .setRenderer(new ComponentRenderer) //
                .setId(COL_ACTIVE) //
                .setExpandRatio(0)
                .setMinimumWidthFromContent(true)

        grid.addColumn(ev|createChannel(ev)) //
                .setRenderer(new ComponentRenderer)
                .setCaption(messages.epgChannelCaption) //
                .setId(COL_CHANNEL) //
                .setMinimumWidth(110) //
                .setExpandRatio(0) //
                .setComparator([ev1, ev2|(createChannel(ev1).data as String).compareToIgnoreCase(createChannel(ev2).data as String)])

        grid.addColumn(ev|createDate(ev)) //
            .setCaption(messages.timerDateCaption) //
            .setId(COL_DATE) //
            .setExpandRatio(0) //
            .setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])
            .setMinimumWidthFromContent(true)

        grid.addColumn(ev|createStart(ev)) //
            .setCaption(messages.timerStartCaption) //
            .setId(COL_START) //
            .setExpandRatio(0) //
            //.setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])
            .setMinimumWidthFromContent(true)

        grid.addColumn(ev|createEnd(ev)) //
            .setCaption(messages.timerEndCaption) //
            .setId(COL_END) //
            .setExpandRatio(0) //
            //.setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])
            .setMinimumWidthFromContent(true)

        grid.addColumn(ev|createDuration(ev)) //
            .setCaption(messages.timerDurationCaption) //
            .setId(COL_DURATION) //
            .setExpandRatio(0) //
            //.setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])
            .setMinimumWidthFromContent(true)

        grid.addColumn(ev|createTitle(ev)) //
            .setCaption(messages.timerTitleCaption) //
            .setId(COL_TITLE) //
            .setExpandRatio(2) //
            .setMinimumWidthFromContent(false)
            //.setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])

        grid.addColumn(ev| createActionButtons(ev)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.timerActionCaption) //
            .setId(COL_ACTION) //
            .setExpandRatio(0) //
            .setMinimumWidth(100) //
            //.setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])
            .setMinimumWidthFromContent(true)

        grid.addItemClickListener[event | clickListener(event)]

        grid.selectionMode = SelectionMode.MULTI
        grid.rowHeight = 55
    }

    def setSizeFull() {
        grid.setSizeFull
    }

    def void deleteSelectedTimer() {
        grid.selectedItems.stream.forEach(s | {
            try {
                svdrp.deleteTimer(currentVdr, s)
            } catch (Exception e) {
                // this can happen, if a repeating timer is selected more than once
                log.debug("Error in deleteSelectedTimer", e)
            }
        })

        refreshTimer
    }

    def void createNewTimer() {
        openEditWindow(new Timer())
    }

    private def clickListener(ItemClick<Timer> event) {
        event.item.showEpgDetails
    }

    private def showEpgDetails(Timer timer) {
        // determine the epg entry for this timer
        val filterResult = svdrp.epg.filter[epg |
            // first filter: channel
            epg.channelId == timer.channelId &&

            // second filter: start time
            epg.startTime <= timer.endEpoch &&

            // third filter: end time
            (epg.startTime + epg.duration) >= timer.startEpoch
        ]

        if ((filterResult === null) || (filterResult.size == 0)) {
            Notification.show(messages.messageNoEpg)
            return
        }

        val overlapResult = filterResult.map[epg |
            var overlap = 0.0
            var seconds = 0.0

            // inspired by VDR cTimer::Matches
            if (epg.startTime <= timer.startEpoch && timer.endEpoch <= (epg.startTime + epg.duration)) {
                overlap = 100
                seconds = timer.duration
            } else {
                seconds = Math.min(timer.endEpoch, epg.startTime + epg.duration) - Math.max(timer.startEpoch, epg.startTime)
                overlap = seconds * 100.0 / Math.max(epg.duration, 1)
            }

            epg -> (overlap -> seconds)
        ]

        val reduceResult = overlapResult.reduce[p1, p2|
            // compare overlap
            if (p1.value.key > p2.value.key) {
                return p1
            } else if (p1.value.key < p2.value.key) {
                return p2
            } else {
                // compare seconds
                if (p1.value.value > p2.value.value) {
                    return p1
                } else {
                    return p2
                }
            }
        ]

        UI.current.addWindow(epgDetails.showWindow(null, currentVdr, reduceResult.key, false))
    }

    /*
    private def createChannel(Timer ev) {
        return SvdrpClient.get.getChannel(ev.channelId).name
    }
    */

    private def createChannel(Timer ev) {
        val name = svdrp.getChannel(ev.channelId).name
        val image = new ChannelLogoSource(name).image

        if (image !== null) {
            image.data = name
            return image
        } else {
            val label = new Label(name)
            label.data = name
            return label
        }
    }

    private def createDate(Timer ev) {
        return DateTimeUtil.toDate(ev.startTime, messages.formatDate)
    }

    private def createStart(Timer ev) {
        return DateTimeUtil.toTime(ev.startTime, messages.formatTime)
    }

    private def createEnd(Timer ev) {
        return DateTimeUtil.toTime(ev.endTime, messages.formatTime)
    }

    private def createDuration(Timer ev) {
        return DateTimeUtil.toDurationTime(ev.endTime - ev.startTime, messages.formatTime)
    }

    private def createTitle(Timer ev) {
        return ev.path
    }

    private def createActionButtons(Timer timer) {
        val layout = cssLayout[
            button("") [
                icon = VaadinIcons.TRASH
                description = messages.timerDelete
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    svdrp.deleteTimer(currentVdr, timer)
                    refreshTimer
                })
            ]

            button("") [
                icon = VaadinIcons.EDIT
                description = messages.timerEdit
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | openEditWindow(timer))
            ]
        ]

        return layout
    }

    private def createTimerActive(Timer ev) {
        val css = cssLayout[
            if (ev.enabled) {
                button("") [
                    icon = VaadinIcons.CHECK
                    description = messages.timerDisable
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | toggleTimerEnabled(ev))
                ]
            } else {
                button("") [
                    icon = VaadinIcons.CLOSE
                    description = messages.timerEnable
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | toggleTimerEnabled(ev))
                ]
            }

            if (ev.isRepeatingTimer) {
                button("") [
                    icon = VaadinIcons.ELLIPSIS_CIRCLE_O
                    description = messages.timerRepeating
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                ]
            }

            if (ev.active) {
                button("") [
                    icon = VaadinIcons.CARET_SQUARE_DOWN_O
                    description = messages.timerRecording
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                ]
            }
        ]

        return css;
    }

    private def toggleTimerEnabled(Timer ev) {
        val provider = (grid.dataProvider) as ListDataProvider<Timer>

        provider.items.stream.filter(s | s.id == ev.id).forEach(s | s.enabled = !s.enabled)

        svdrp.updateTimer(currentVdr, ev)
        grid.dataProvider.refreshAll
    }

    private def openEditWindow(Timer timer) {
        val w = timerEdit.showWindow(currentVdr, timer)
        w.addCloseListener(new CloseListener() {
            override windowClose(CloseEvent e) {
                refreshTimer
            }
        })

        UI.current.addWindow(w)
    }

    private def refreshTimer() {
        grid.items = svdrp.getTimer(currentVdr)
    }
}
