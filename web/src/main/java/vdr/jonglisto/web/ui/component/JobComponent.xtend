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
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action
import vdr.jonglisto.delegate.Config
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

    String currentUser

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
        grid = new Grid

        refreshJobs

        grid.setSizeFull

        grid.addColumn(ev| createJobActive(ev)) //
                .setCaption("Active") //
                .setRenderer(new ComponentRenderer) //
                .setId("ACTIVE") //
                .setMinimumWidthFromContent(true)

        grid.addColumn(job | job.user) //
            .setCaption("User") //
            .setId("USER") //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | job.time) //
            .setCaption("Time") //
            .setId("TIME") //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createActionType(job.action)) //
            .setCaption("Type") //
            .setId("TYPE") //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createScriptOrVdr(job.action)) //
            .setCaption("Script/VDR") //
            .setId("DEST") //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createParameter(job.action)) //
            .setCaption("Parameter") //
            .setId("PARAM") //
            .setMinimumWidthFromContent(true)

        grid.addColumn(job | createActionButton(job.action)) //
            .setCaption("Action") //
            .setId("ACTION") //
            .setMinimumWidthFromContent(true)

        val root = verticalLayout [
            horizontalLayout(it) [
                button(it, "Create new Job") [
                    addClickListener(s | {
                        openNewJobWindow(new Jobs)
                    })
                ]
            ]

            addComponentsAndExpand(grid)
        ]

        compositionRoot = root
    }

    private def createActionType(Action action) {
        if (action.shellAction !== null) {
            return "Shell script"
        } else if (action.vdrAction !== null) {
            switch (action.vdrAction.type) {
                case "switchChannel": return "Switch channel"
                case "osdMessage" : return "OSD message"
                case "svdrp" : return "SVDRP command"
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

    private def createActionButton(Action action) {
        // TODO: Implement something useful
        return null;
    }

    private def void openNewJobWindow(Jobs job) {
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
                    description = "AKTIV"
                    width = "22px"
                    styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                    addClickListener(s | toggleJobActive(ev))
                ]
            } else {
                button(it, "") [
                    icon = VaadinIcons.CLOSE
                    description = "AKTIV"
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
    }
}
