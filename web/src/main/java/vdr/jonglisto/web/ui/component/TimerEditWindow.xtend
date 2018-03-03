package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.data.provider.ListDataProvider
import com.vaadin.server.UserError
import com.vaadin.ui.Alignment
import com.vaadin.ui.CheckBox
import com.vaadin.ui.ComboBox
import com.vaadin.ui.DateField
import com.vaadin.ui.TextArea
import com.vaadin.ui.TextField
import com.vaadin.ui.Window
import java.time.DayOfWeek
import java.time.LocalDate
import java.util.regex.Pattern
import javax.inject.Inject
import org.apache.commons.lang3.StringUtils
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.Timer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import com.vaadin.ui.Notification

@Log
@ViewScoped
class TimerEditWindow extends Window {

    private static Pattern timePattern = Pattern.compile("\\d{2}:\\d{2}")
    private static Pattern twoDigitPattern = Pattern.compile("\\d{1,2}")

    @Inject
    private Svdrp svdrp

    @Inject
    private Config config

    @Inject
    private Messages messages

    var VDR currentVdr

    var ComboBox<Channel> channel
    var CheckBox active
    var CheckBox vps
    var DateField date
    var TextField start
    var TextField end
    var CheckBox monday
    var CheckBox tuesday
    var CheckBox wednesday
    var CheckBox thursday
    var CheckBox friday
    var CheckBox saturday
    var CheckBox sunday
    var TextField title
    var TextArea aux
    var TextField priority
    var TextField lifetime

    var ComboBox<String> selectVdr

    new() {
        super()
    }

    def showWindow(VDR vdr, Epg epg) {
        this.currentVdr = vdr
        closable = true
        modal = true
        width = "60%"
        center();

        val timer = createTimerFromEpg(epg)
        createLayout(timer)

        return this
    }

    def showWindow(VDR vdr, Timer timer) {
        this.currentVdr = vdr
        closable = true
        modal = true
        width = "60%"
        center();

        createLayout(timer)

        this
    }

    def createLayout(Timer timer) {
        val currentUser = SecurityUtils.subject

        caption = createCaption(timer)

        setContent(
            verticalLayout [
                label(it, "Edit Timer")

                horizontalLayout(it) [
                    selectVdr = comboBox(it, config.getVdrNames(currentUser)) [
                        caption = messages.timerVdrCaption
                        emptySelectionAllowed = false
                        selectedItem = currentVdr.name
                    ]

                    channel = comboBoxChannel(it, svdrp.channels) [
                        caption = messages.timerChannelCaption
                        emptySelectionAllowed = false
                        setItemCaptionGenerator(it | it.name)
                    ]

                    active = checkbox(it, messages.timerActive) [
                    ]

                    vps =  checkbox(it, messages.timerVps) [
                    ]

                    setComponentAlignment(channel, Alignment.MIDDLE_CENTER)
                    setComponentAlignment(active, Alignment.MIDDLE_CENTER)
                    setComponentAlignment(vps, Alignment.MIDDLE_CENTER)
                ]

                horizontalLayout(it) [
                    date = dateField(it) [
                        caption = messages.timerDate
                        value = LocalDate.now()
                    ]

                    start = textField(it, messages.timerStart) [
                        placeholder = "hh:mm"
                        maxLength = 5
                    ]

                    end = textField(it, messages.timerEnd) [
                        placeholder = "hh:mm"
                        maxLength = 5
                    ]
                ]

                horizontalLayout(it) [
                    monday = checkbox(it, messages.timerMonday) [
                    ]

                    tuesday = checkbox(it, messages.timerTuesday) [
                    ]

                    wednesday = checkbox(it, messages.timerWednesday) [
                    ]

                    thursday = checkbox(it, messages.timerThursday) [
                    ]

                    friday = checkbox(it, messages.timerFriday) [
                    ]

                    saturday = checkbox(it, messages.timerSaturday) [
                    ]

                    sunday = checkbox(it, messages.timerSunday) [
                    ]
                ]

                title = textField(it, messages.timerTitle) [
                    width = "100%"
                ]

                aux = textArea(it, messages.timerAux, null) [
                    width = "100%"
                    height = "100%"
                ]

                horizontalLayout(it) [
                    priority = textField(it, messages.timerPriority) [
                        value = "50"
                    ]

                    lifetime = textField(it, messages.timerLifetime) [
                        value = "50"
                    ]
                ]

                cssLayout(it) [
                    width = "100%"
                    button(it, messages.timerSave) [
                        it.addClickListener(s | {
                            if (saveTimer(timer)) {
                                close
                            }
                        })
                    ]

                    button(it, messages.timerCancel) [
                        it.addClickListener(s | {
                            close
                        })
                    ]
                ]
            ]
        )

        // fill data
        if (timer.id != 0) {
            // FIXME: this is necessary, because Channel does not implement equals method
            //        and this is the result of strange behavior in Trees and Grids after implementing equals.
            //        Check after some new Vaadin releases, if this problem still exists
            val internalChannel = (channel.dataProvider as ListDataProvider<Channel>).items.stream.filter(s | s.id == timer.channelId).findFirst
            channel.selectedItem = internalChannel.get

            active.value = timer.enabled
            vps.value = timer.vps
            date.value = timer.startDate
            start.value = timer.startAsString
            end.value = timer.endAsString
            title.value = timer.path

            if (timer.aux === null) {
                aux.value = ""
            } else {
                aux.value = timer.aux
            }

            priority.value = String.valueOf(timer.priority)
            lifetime.value = String.valueOf(timer.lifetime)

            if (timer.days !== null) {
                monday.value = timer.isWeekday(DayOfWeek.MONDAY)
                tuesday.value = timer.isWeekday(DayOfWeek.TUESDAY)
                wednesday.value = timer.isWeekday(DayOfWeek.WEDNESDAY)
                thursday.value = timer.isWeekday(DayOfWeek.THURSDAY)
                friday.value = timer.isWeekday(DayOfWeek.FRIDAY)
                saturday.value = timer.isWeekday(DayOfWeek.SATURDAY)
                sunday.value = timer.isWeekday(DayOfWeek.SUNDAY)
            }
        }
    }


    private def createCaption(Timer timer) {
        return  messages.timerEdit
    }

    private def createTimerFromEpg(Epg epg) {
        val timer = new Timer

        timer.id = -1
        timer.channelId = epg.channelId
        timer.enabled = true
        timer.vps = false
        timer.aux = null
        timer.priority = 50
        timer.lifetime = 50
        timer.startEpoch = epg.startTime - 10 * 60              // TODO: make this configurable (minus 10 minutes)
        timer.endEpoch = epg.startTime + epg.duration + 10 * 60 // TODO: make this configurable (plus 10 minutes)

        val pathBuilder = new StringBuilder
        pathBuilder.append(epg.title)

        if (StringUtils.isNotEmpty(epg.shortText)) {
            pathBuilder.append("~").append(epg.shortText)
        }

        timer.path = pathBuilder.toString

        return timer
    }

    private def saveTimer(Timer timer) {
        var checkResult = true

        // check all values
        val m1 = timePattern.matcher(start.value)
        if (!m1.matches) {
            start.setComponentError(new UserError(messages.timerErrorFormatTime));
            checkResult = false
        } else {
            start.componentError = null
        }

        val m2 = timePattern.matcher(end.value)
        if (!m2.matches) {
            end.setComponentError(new UserError(messages.timerErrorFormatTime));
            checkResult = false
        } else {
            start.componentError = null
        }

        val m3 = twoDigitPattern.matcher(priority.value)
        if (!m3.matches) {
            priority.setComponentError(new UserError(messages.timerErrorFormatDigit));
            checkResult = false
        } else {
            priority.componentError = null
        }

        val m4 = twoDigitPattern.matcher(lifetime.value)
        if (!m4.matches) {
            lifetime.setComponentError(new UserError(messages.timerErrorFormatDigit));
            checkResult = false
        } else {
            lifetime.componentError = null
        }

        if (StringUtils.isEmpty(title.value)) {
            title.setComponentError(new UserError(messages.timerErrorTitleEmpty));
            checkResult = false
        } else {
            title.componentError = null
        }

        if (!checkResult) {
            return checkResult
        }

        timer.channelId = channel.selectedItem.get.id
        timer.enabled = active.value
        timer.vps = vps.value
        timer.path = title.value
        timer.aux = aux.value
        timer.priority = if (StringUtils.isEmpty(priority.value)) 50 else Integer.parseInt(priority.value)
        timer.lifetime = if (StringUtils.isEmpty(lifetime.value)) 50 else Integer.parseInt(lifetime.value)
        timer.startDate = date.value
        timer.startAsString = start.value
        timer.endAsString = end.value

        timer.setWeekday(DayOfWeek.MONDAY, monday.value)
        timer.setWeekday(DayOfWeek.TUESDAY, tuesday.value)
        timer.setWeekday(DayOfWeek.WEDNESDAY, wednesday.value)
        timer.setWeekday(DayOfWeek.THURSDAY, thursday.value)
        timer.setWeekday(DayOfWeek.FRIDAY, friday.value)
        timer.setWeekday(DayOfWeek.SATURDAY, saturday.value)
        timer.setWeekday(DayOfWeek.SUNDAY, sunday.value)

        try {
            if (currentVdr.name == selectVdr.selectedItem.get) {
                // VDR has not been changed: Simple
                svdrp.updateTimer(currentVdr, timer)
            } else {
                // Another VDR has been selected
                if (timer.id > 0) {
                    // move existing timer: delete and add
                    svdrp.deleteTimer(currentVdr, timer)
                    svdrp.updateTimer(config.getVdr(selectVdr.selectedItem.get), timer)
                } else {
                    // new timer: simple
                    svdrp.updateTimer(config.getVdr(selectVdr.selectedItem.get), timer)
                }
            }
        } catch (Exception e) {
            // VDR is not running
            Notification.show(messages.errorVdrNotRunning)
        }

        return true
    }
}
