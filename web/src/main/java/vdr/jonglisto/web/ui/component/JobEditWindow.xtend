package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.ui.Button
import com.vaadin.ui.CheckBox
import com.vaadin.ui.Label
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.TextField
import com.vaadin.ui.Window
import java.util.ArrayList
import java.util.Random
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action.ShellAction
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action.VdrAction
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.util.Utils
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@ViewScoped
class JobEditWindow extends Window {

    @Inject
    private Config config

    @Inject
    private Messages messages

    private CheckBox active
    private TextField time
    private NativeSelect<String> type
    private NativeSelect<String> vdr
    private TextField script
    private TextField parameter
    private NativeSelect<String> vdrType
    private Label next

    private Jobs editJob
    private Random rand = new Random()

    new() {
        super()
    }

    def showWindow(Jobs job) {
        val currentUser = SecurityUtils.subject

        editJob = job

        caption = messages.configJobsEditJob

        center();

        closable = true
        modal = true
        width = "40%"

        setContent(
            verticalLayout [

                formLayout(it) [
                    active = checkbox(it, messages.configJobsActive) [
                        width = "100%"
                        value = editJob.active
                    ]

                    time = textField(it, messages.configJobsTimeFormat) [
                        width = "100%"
                        value = editJob.time ?: ""

                        addBlurListener(s | {
                            try {
                                next.value = messages.configJobsNextExecution + ": " + Utils.getNextScheduleTime(time.value, messages.formatDate, messages.formatTime)
                            } catch (Exception e) {
                                next.value = messages.configJobsTimeInvalid
                            }
                        })
                    ]

                    next = label(it, messages.configJobsNextExecution) [
                        if (time.value !== null) {
                            try {
                                value = messages.configJobsNextExecution + ": " + Utils.getNextScheduleTime(time.value, messages.formatDate, messages.formatTime)
                            } catch (Exception e) {
                                value = messages.configJobsTimeInvalid
                            }
                        }
                    ]

                    type = nativeSelect(it) [
                        width = "100%"
                        caption = "Type"

                        var typeList = new ArrayList<String>

                        if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:svdrp")) {
                            typeList.add(messages.configJobsVdr)
                        }

                        if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:shell")) {
                            typeList.add(messages.configJobsShell)
                        }

                        items =  typeList

                        emptySelectionAllowed = false
                        selectedItem = typeList.get(0)

                        if (editJob.action !== null) {
                            if (editJob.action.vdrAction !== null) {
                                selectedItem = messages.configJobsVdr
                            } else if (editJob.action.shellAction !== null) {
                                selectedItem = messages.configJobsShell
                            }
                        }

                        addSelectionListener(s | {
                            if (s.value == messages.configJobsVdr) {
                                vdr.visible = true
                                script.visible = false
                                parameter.visible = true
                                vdrType.visible = true
                            }  else if (s.value == messages.configJobsShell) {
                                vdr.visible = false
                                script.visible = true
                                parameter.visible = true
                                vdrType.visible = false
                            } else {
                                vdr.visible = false
                                script.visible = false
                                parameter.visible = false
                                vdrType.visible = false
                            }
                        })
                    ]

                    vdr = nativeSelect(it) [
                        val vdrNames = config.getVdrNames(currentUser)
                        width = "100%"
                        caption = messages.configJobsVdr

                        items = vdrNames
                        emptySelectionAllowed = false
                        selectedItem = vdrNames.get(0)

                        if (editJob.action !== null && editJob.action.vdrAction !== null) {
                            selectedItem = editJob.action.vdrAction.vdr
                            visible = true
                        } else {
                            visible = false
                        }
                    ]

                    vdrType = nativeSelect(it) [
                        width = "100%"
                        caption = messages.configJobsVdrCommandType
                        items = #[messages.configJobsVdrSwitchChannel, messages.configJobsVdrOsdMessage, messages.configJobsVdrSvdrpCommand]
                        emptySelectionAllowed = false

                        if (editJob.action.vdrAction !== null) {
                            switch (editJob.action.vdrAction.type) {
                                case "switchChannel": selectedItem = messages.configJobsVdrSwitchChannel
                                case "osdMessage": selectedItem = messages.configJobsVdrOsdMessage
                                case "svdrp": selectedItem = messages.configJobsVdrSvdrpCommand
                            }
                        } else {
                            // default
                            selectedItem = messages.configJobsVdrSwitchChannel
                        }

                        visible = type.selectedItem.get == messages.configJobsVdr
                    ]

                    script = textField(it, messages.configJobsShell) [
                        width = "100%"
                        if (editJob.action !== null && editJob.action.shellAction !== null) {
                            value = editJob.action.shellAction.script ?: ""
                            visible = true
                        } else {
                            visible = false
                        }
                    ]

                    parameter = textField(it, messages.configJobsParameter) [
                        width = "100%"
                        if (editJob.action !== null) {
                            if (editJob.action.vdrAction !== null) {
                                value = editJob.action.vdrAction.parameter ?: ""
                            } else if (editJob.action.shellAction !== null) {
                                value = editJob.action.shellAction.parameter ?: ""
                            }
                            visible = true
                        } else {
                            visible = false
                        }
                    ]

                    if (job.id === null) {
                        vdr.visible = true
                        script.visible = false
                        parameter.visible = true
                    }
                ]

                cssLayout(it) [
                    width = "100%"
                    button(it, messages.configJobsSave) [
                        it.addClickListener(s | {
                            val newJob = editJob.id === null

                            try {
                                Utils.getNextScheduleTime(time.value, messages.formatDate, messages.formatTime)
                            } catch (Exception e) {
                                return
                            }

                            if (newJob) {
                                editJob.id = rand.nextInt.toString
                            }

                            editJob.active = active.value
                            editJob.user = SecurityUtils.subject.principal as String
                            editJob.time = time.value

                            if ((!type.selectedItem.isPresent) || (time.value === null) || (time.value.length == 0)) {
                                if (newJob) {
                                    editJob.id = null
                                }

                                return
                            }

                            switch (type.selectedItem.get) {
                                case messages.configJobsVdr: {
                                    val vdrAction = new VdrAction
                                    vdrAction.parameter = parameter.value
                                    vdrAction.vdr = vdr.selectedItem.get

                                    switch (vdrType.selectedItem.get) {
                                        case messages.configJobsVdrSwitchChannel: {
                                            vdrAction.type = "switchChannel"
                                        }

                                        case messages.configJobsVdrOsdMessage: {
                                            vdrAction.type = "osdMessage"
                                        }

                                        case messages.configJobsVdrSvdrpCommand: {
                                            vdrAction.type = "svdrp"
                                        }
                                    }

                                    val action = new Action
                                    action.vdrAction = vdrAction
                                    editJob.action = action
                                }

                                case messages.configJobsShell: {
                                    val shellAction = new ShellAction
                                    shellAction.parameter = parameter.value
                                    shellAction.script = script.value

                                    val action = new Action
                                    action.shellAction = shellAction
                                    editJob.action = action
                                }
                            }

                            if (newJob) {
                                config.addJob(editJob)
                                // config.jcron.jobs.add(editJob)
                            } else {
                                config.changeJob(editJob)

                                // val old = config.jcron.jobs.findFirst[j | j.id == editJob.id]
                                // config.jcron.jobs.remove(old)
                                // config.jcron.jobs.add(editJob)
                            }

                            config.saveJcron
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
