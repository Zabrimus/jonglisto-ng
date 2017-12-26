package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDINavigator
import com.vaadin.event.selection.SingleSelectionEvent
import com.vaadin.icons.VaadinIcons
import com.vaadin.navigator.View
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.server.VaadinSession
import com.vaadin.ui.Button
import com.vaadin.ui.ComboBox
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.themes.ValoTheme
import javax.inject.Inject
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
abstract class BaseView extends VerticalLayout implements View {
    protected enum BUTTON {
        HOME, TIMER, EPG, EPGD, EPGSEARCH, RECORDING, CHANNELCONFIG, OSD, LOGOUT
    }

    @Inject
    protected Svdrp svdrp

    @Inject
    protected Config config

    @Inject
    protected CDINavigator navigator;

    @Inject
    protected var Messages messages

    var ComboBox<String> selectVdr
    private Button epgsearchButton

    private BUTTON currentView

    public def init(BUTTON selectedButton) {
        createLayout(selectedButton)
        createMainComponents()

        setSizeFull
        currentView = selectedButton
    }

    abstract protected def void createMainComponents()
    abstract protected def void changeVdr(VDR vdr)

    override enter(ViewChangeEvent event) {
    }

    private def createLayout(BUTTON selectedButton) {
        setSizeFull

        margin = false

        // horizontalLayout [
        cssLayout(this) [
            height = null
            width = "100%"
            spacing = false

            button("") [
                icon = VaadinIcons.HOME
                description = "Home"
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + (if (selectedButton == BUTTON.HOME) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.MAIN_VIEW) })
            ]

            selectVdr = comboBox(config.vdrNames) [
                emptySelectionAllowed = false
                addSelectionListener [
                    selectVdr(it)
                ]
            ]

            button(messages.menuEpg) [
                icon = VaadinIcons.NEWSPAPER
                styleName = (if (selectedButton == BUTTON.EPG) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.EPG_VIEW) })
            ]

            button(messages.menuTimer) [
                icon = VaadinIcons.CLOCK
                styleName = (if (selectedButton == BUTTON.TIMER) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.TIMER_VIEW) })
            ]

            // Show the button only, if database is configured
            if (config.isDatabaseConfigured) {
                button(messages.menuSearchTimerEpgd) [
                    icon = VaadinIcons.CLOCK
                    styleName = (if (selectedButton == BUTTON.EPGD) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | { navigator.navigateTo(MainUI.SEARCHTIMER_EPGD_VIEW) })
                ]
            }

            epgsearchButton = button(messages.menuSearchTimerEpgsearch) [
                icon = VaadinIcons.CLOCK
                visible = false // disabled per default
                styleName = (if (selectedButton == BUTTON.EPGSEARCH) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.SEARCHTIMER_EPGSEARCH_VIEW) })
            ]

            button(messages.menuRecordings) [
                icon = VaadinIcons.FILM
                styleName = (if (selectedButton == BUTTON.RECORDING) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.RECORDING_VIEW) })
            ]

            button(messages.menuOsd) [
                icon = VaadinIcons.LAPTOP
                styleName = (if (selectedButton == BUTTON.OSD) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.OSD_VIEW) })
            ]

            button(messages.channelConfig) [
                icon = VaadinIcons.COG
                styleName = (if (selectedButton == BUTTON.CHANNELCONFIG) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { navigator.navigateTo(MainUI.CHANNEL_CONFIG_VIEW) })
            ]

            button(messages.menuLogout) [
                icon = VaadinIcons.EXIT
                styleName = (if (selectedButton == BUTTON.LOGOUT) ValoTheme.BUTTON_PRIMARY else "")
                addClickListener(s | { (UI as MainUI).doLogout })
            ]
        ]

        val sessionVdr = VaadinSession.current.getAttribute("SELECTED_VDR") as String
        if (sessionVdr !== null) {
            selectVdr.selectedItem = sessionVdr
        }
    }

    def selectVdr(SingleSelectionEvent<String> event) {
        log.fine("Got Event: " + event +  " --> " + event.selectedItem.get)

        VaadinSession.current.setAttribute("SELECTED_VDR", event.selectedItem.get)
        changeVdr(config.getVdr(event.selectedItem.get))

        // check if epgsearch plugin is available in selectedVdr
        if (svdrp.isPluginAvailable(event.selectedItem.get, "epgsearch")) {
            epgsearchButton.visible = true
        } else {
            epgsearchButton.visible = false
            if (currentView == BUTTON.EPGSEARCH) {
                // this view do not exists for this VDR -> change to home
                UI.navigator.navigateTo(MainUI.MAIN_VIEW)
            }
        }
    }

    def getSelectedVdr() {
        config.getVdr(selectVdr.selectedItem.get)
    }
}
