package vdr.jonglisto.web.ui.component

import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Composite
import com.vaadin.ui.Grid
import com.vaadin.ui.Window.CloseEvent
import com.vaadin.ui.Window.CloseListener
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.themes.ValoTheme
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import org.apache.shiro.subject.Subject
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.util.Utils
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class JobComponent extends Composite {

    @Inject
    private Config config

    @Inject
    private Messages messages

    @Inject
    private JobEditWindow jobEdit

    private Grid<Jobs> grid

    private Subject currentSubject
    private String currentUser

    def showAll() {
        currentUser = null
        createLayout(null)
        return this
    }

    def showUser() {
        currentUser = SecurityUtils.subject.principal as String
        createLayout(currentUser)
        return this
    }

    private def void createLayout(String user) {
        currentSubject = SecurityUtils.subject

        grid = new Grid

        refreshJobs

        grid.setSizeFull

        grid.addColumn(ev| createJobActive(ev)) //
                .setCaption(messages.configJobsActive) //
                .setRenderer(new ComponentRenderer) //
                .setId("ACTIVE") //
                .setExpandRatio(1) //
                .setMinimumWidthFromContent(true)

        if (currentUser === null) {
            grid.addColumn(job | job.user) //
                .setCaption(messages.configJobsUser) //
                .setId("USER") //
                .setExpandRatio(1) //
                .setMinimumWidthFromContent(true)
        }

        grid.addColumn(job | job.time) //
            .setCaption(messages.configJobsTimeFormat) //
            .setId("TIME") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | getNextTime(job.time)) //
            .setCaption(messages.configJobsNextExecution) //
            .setId("NEXT") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createActionType(job.action)) //
            .setCaption("Type") //
            .setId("TYPE") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createScriptOrVdr(job.action)) //
            .setCaption(messages.configJobsScriptVdr) //
            .setId("DEST") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createParameter(job.action)) //
            .setCaption(messages.configJobsParameter) //
            .setId("PARAM") //
            .setExpandRatio(1) //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createActionButton(job)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.configJobsAction) //
            .setId("ACTION") //
            .setExpandRatio(0) //
            .setMinimumWidth(100) //
            .setMinimumWidthFromContent(true)

        val root = verticalLayout [
            horizontalLayout(it) [
                button(it, messages.configJobsNewJob) [
                    addClickListener(s | {
                        openEditJobWindow(new Jobs)
                    })
                ]
            ]

            addComponentsAndExpand(grid)
        ]

        compositionRoot = root
    }

    private def createActionType(Action action) {
        if (action.shellAction !== null) {
            return messages.configJobsShell
        } else if (action.vdrAction !== null) {
            switch (action.vdrAction.type) {
                case "switchChannel": return messages.configJobsVdrSwitchChannel
                case "osdMessage" : return messages.configJobsVdrOsdMessage
                case "svdrp" : return messages.configJobsVdrSvdrpCommand
            }
        }
    }

    private def createScriptOrVdr(Action action) {
        if (action.shellAction !== null) {
            return action.shellAction.script
        } else if (action.vdrAction !== null) {
            return action.vdrAction.vdr
        }
    }

    private def createParameter(Action action) {
        if (action.shellAction !== null) {
            return action.shellAction.parameter
        } else if (action.vdrAction !== null) {
            return action.vdrAction.parameter
        }
    }

    private def createActionButton(Jobs job) {
        val layout = cssLayout[
            button(it, "") [
                icon = VaadinIcons.TRASH
                description = messages.configJobsDelete
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    val old = config.jcron.jobs.findFirst[j | j.id == job.id]
                    config.jcron.jobs.remove(old)
                    config.saveJcron
                    refreshJobs
                })
            ]

            val editEnabled = ((job.action.vdrAction !== null) && currentSubject.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:svdrp"))
                           || ((job.action.shellAction !== null) && currentSubject.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:shell"))

            if (editEnabled) {
                button(it, "") [
                    icon = VaadinIcons.EDIT
                    description = messages.configJobsEdit
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | openEditJobWindow(job))
                ]
            }
        ]

        return layout
    }

    private def void openEditJobWindow(Jobs job) {
        val w = jobEdit.showWindow(job)
        w.addCloseListener(new CloseListener() {
            override windowClose(CloseEvent e) {
                refreshJobs
            }
        })

        getUI().addWindow(w)
    }

    private def void refreshJobs() {
        if (currentUser === null) {
            grid.items = config.jcron.jobs
        } else {
            grid.items = config.jcron.jobs.filter[s | s.user == currentUser].toList
        }
    }

    private def createJobActive(Jobs ev) {
        val css = cssLayout[
            if (ev.active) {
                button(it, "") [
                    icon = VaadinIcons.CHECK
                    description = messages.configJobsActive
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | toggleJobActive(ev))
                ]
            } else {
                button(it, "") [
                    icon = VaadinIcons.CLOSE
                    description = messages.configJobsInactive
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | toggleJobActive(ev))
                ]
            }
        ]

        return css;
    }

    private def toggleJobActive(Jobs job) {
        job.active = !job.active
        config.saveJcron
        refreshJobs
    }


    private def getNextTime(String cronAsString) {
        try {
            Utils.getNextScheduleTime(cronAsString, messages.formatDate, messages.formatTime)
        } catch (Exception e) {
            return messages.configJobsTimeInvalid
        }
    }
}
