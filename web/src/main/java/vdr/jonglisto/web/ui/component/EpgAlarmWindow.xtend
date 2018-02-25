package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.ui.Button
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.TextField
import com.vaadin.ui.Window
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action.VdrAction
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Epg
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import vdr.jonglisto.util.Utils

@Log
@ViewScoped
class EpgAlarmWindow extends Window {

    @Inject
    private Config config

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    private TextField parameter
    private TextField minutes
    private NativeSelect<String> vdrType

    private Jobs editJob

    new() {
        super()
    }

    def showWindow(String vdrName, Epg epg) {
        caption = messages.configJobsEditJob

        center();

        closable = true
        modal = true
        width = "40%"

        setContent(
            verticalLayout [

                formLayout(it) [
                    vdrType = nativeSelect(it) [
                        width = "100%"
                        caption = messages.configJobsVdrCommandType
                        items = #[messages.configJobsVdrSwitchChannel, messages.configJobsVdrOsdMessage, messages.configJobsVdrOsdMessage2, messages.configJobsVdrSvdrpCommand]
                        emptySelectionAllowed = false
                        selectedItem = messages.configJobsVdrSwitchChannel

                        addSelectionListener(s | {
                            switch (s.selectedItem.get) {
                                case messages.configJobsVdrSwitchChannel: {
                                    parameter.visible = false
                                    parameter.value = epg.channelId
                                }

                                case messages.configJobsVdrOsdMessage: {
                                    parameter.visible = true
                                    parameter.value = messages.epgAlarmOsd(epg.title + " - " + epg.shortText, svdrp.getChannel(epg.channelId).name)
                                }

                                case messages.configJobsVdrOsdMessage2: {
                                    parameter.visible = true
                                    parameter.value = ""
                                }

                                case messages.configJobsVdrSvdrpCommand: {
                                    parameter.visible = true
                                    parameter.value = ""
                                }
                            }
                        })
                    ]

                    parameter = textField(it, messages.configJobsParameter) [
                        value = epg.channelId
                        width = "100%"
                        visible = false
                    ]

                    minutes = textField(it, messages.configJobsMinutes) [
                        value = "5"
                        width = "100%"
                        visible = true
                    ]
                ]

                cssLayout(it) [
                    width = "100%"
                    button(it, messages.configJobsSave) [
                        it.addClickListener(s | {
                            editJob = new Jobs

                            val minusMinutes = Integer.valueOf(minutes.value ?: "0")
                            val dateTime = DateTimeUtil.toDateTime(epg.startTime)
                            val timeFormat = String.format("0 %d %d %d %d ? %d", dateTime.minute - minusMinutes, dateTime.hour, dateTime.dayOfMonth, dateTime.monthValue, dateTime.year)

                            editJob.id = Utils.nextRand.toString
                            editJob.active = true
                            editJob.user = SecurityUtils.subject.principal as String
                            editJob.time = timeFormat

                            val vdrAction = new VdrAction
                            vdrAction.vdr = vdrName

                            switch (vdrType.selectedItem.get) {
                                case messages.configJobsVdrSwitchChannel: {
                                    vdrAction.type = "switchChannel"
                                    vdrAction.parameter = parameter.value
                                }

                                case messages.configJobsVdrOsdMessage: {
                                    vdrAction.type = "osdMessage"
                                    vdrAction.parameter = parameter.value
                                }

                                case messages.configJobsVdrOsdMessage2: {
                                    vdrAction.type = "pluginMessage"
                                    vdrAction.parameter = "plug jonglisto " + epg.channelId + " " + epg.title
                                }

                                case messages.configJobsVdrSvdrpCommand: {
                                    vdrAction.type = "svdrp"
                                    vdrAction.parameter = parameter.value
                                }
                            }

                            val action = new Action
                            action.vdrAction = vdrAction
                            action.vdrAction.parameter = parameter.value
                            editJob.action = action

                            config.addJob(editJob)
                            close
                        })
                    ]

                    button(it, messages.configJobsCancel) [
                        it.addClickListener(s | {
                            close
                        })
                    ]
                ]
            ]
        )

        return this
    }

    def addCloseButtonClickListener(Button b) {
        b.addClickListener(s | {
            close
        })
    }
}
