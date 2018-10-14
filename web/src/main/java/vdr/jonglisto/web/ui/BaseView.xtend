package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDINavigator
import com.vaadin.event.selection.SingleSelectionEvent
import com.vaadin.icons.VaadinIcons
import com.vaadin.navigator.View
import com.vaadin.server.VaadinSession
import com.vaadin.ui.Button
import com.vaadin.ui.ComboBox
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.themes.ValoTheme
import java.io.Serializable
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
@SuppressWarnings("serial")
abstract class BaseView extends VerticalLayout implements View, Serializable {

    protected enum BUTTON {
        HOME, TIMER, EPG, EPGD, EPGSEARCH, RECORDING, CHANNELCONFIG, OSD, CONFIG, LOGOUT
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
    Button epgsearchButton

    BUTTON currentView

    def init(BUTTON selectedButton) {
        // sanitiy check
        val currentUser = SecurityUtils.subject
        if (!currentUser.isAuthenticated) {
            navigator.navigateTo("")
        }

        createLayout(selectedButton)
        createMainComponents()

        setSizeFull
        currentView = selectedButton
    }

    abstract protected def void createMainComponents()
    abstract protected def void changeVdr(VDR vdr)
    abstract protected def void refresh()

    private def createLayout(BUTTON selectedButton) {
        val currentUser = SecurityUtils.subject

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
                addClickListener(s | {
                    if (navigator.state == MainUI.MAIN_VIEW) {
                        refresh
                    }

                    navigator.navigateTo(MainUI.MAIN_VIEW)
                })
            ]

            selectVdr = comboBox(config.getVdrNames(currentUser)) [
                emptySelectionAllowed = false
                addSelectionListener [
                    selectVdr(it)
                ]
            ]

            if (currentUser.isPermitted("view:" + MainUI.EPG_VIEW)) {
                button(messages.menuEpg) [
                    icon = VaadinIcons.NEWSPAPER
                    styleName = (if (selectedButton == BUTTON.EPG) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.EPG_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.EPG_VIEW)
                    })
                ]
            }

            if (currentUser.isPermitted("view:" + MainUI.TIMER_VIEW)) {
                button(messages.menuTimer) [
                    icon = VaadinIcons.CLOCK
                    styleName = (if (selectedButton == BUTTON.TIMER) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.TIMER_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.TIMER_VIEW)
                    })
                ]
            }

            if (currentUser.isPermitted("view:" + MainUI.SEARCHTIMER_EPGD_VIEW)) {
                // Show the button only, if database is configured
                if (config.isDatabaseConfigured) {
                    button(messages.menuSearchTimerEpgd) [
                        icon = VaadinIcons.CLOCK
                        styleName = (if (selectedButton == BUTTON.EPGD) ValoTheme.BUTTON_PRIMARY else "")
                        addClickListener(s | {
                            if (navigator.state == MainUI.SEARCHTIMER_EPGD_VIEW) {
                                refresh
                            }

                            navigator.navigateTo(MainUI.SEARCHTIMER_EPGD_VIEW)
                        })
                    ]
                }
            }

            if (currentUser.isPermitted("view:" + MainUI.SEARCHTIMER_EPGSEARCH_VIEW)) {
                epgsearchButton = button(messages.menuSearchTimerEpgsearch) [
                    icon = VaadinIcons.CLOCK
                    visible = svdrp.isPluginAvailable(selectedVdr.name, "epgsearch")
                    styleName = (if (selectedButton == BUTTON.EPGSEARCH) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.SEARCHTIMER_EPGSEARCH_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.SEARCHTIMER_EPGSEARCH_VIEW)
                    })
                ]
            }

            if (currentUser.isPermitted("view:" + MainUI.RECORDING_VIEW)) {
                button(messages.menuRecordings) [
                    icon = VaadinIcons.FILM
                    styleName = (if (selectedButton == BUTTON.RECORDING) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.RECORDING_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.RECORDING_VIEW)
                    })
                ]
            }

            if (currentUser.isPermitted("view:" + MainUI.OSD_VIEW)) {
                button(messages.menuOsd) [
                    icon = VaadinIcons.LAPTOP
                    styleName = (if (selectedButton == BUTTON.OSD) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.OSD_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.OSD_VIEW)
                    })
                ]
            }

            if (currentUser.isPermitted("view:" + MainUI.CHANNEL_CONFIG_VIEW)) {
                button(messages.channelConfig) [
                    icon = VaadinIcons.COG
                    styleName = (if (selectedButton == BUTTON.CHANNELCONFIG) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.CHANNEL_CONFIG_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.CHANNEL_CONFIG_VIEW)
                    })
                ]
            }

            if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW)) {
                button(messages.configView) [
                    icon = VaadinIcons.LIFEBUOY
                    styleName = (if (selectedButton == BUTTON.CONFIG) ValoTheme.BUTTON_PRIMARY else "")
                    addClickListener(s | {
                        if (navigator.state == MainUI.CONFIG_VIEW) {
                            refresh
                        }

                        navigator.navigateTo(MainUI.CONFIG_VIEW)
                    })
                ]
            }

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
        log.debug("Got Event: {} --> {}", event, event.selectedItem.get)

        VaadinSession.current.setAttribute("SELECTED_VDR", event.selectedItem.get)
        changeVdr(config.getVdr(event.selectedItem.get))

        // check if epgsearch plugin is available in selectedVdr
        if (epgsearchButton !== null) {
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
    }

    def getSelectedVdr() {
        config.getVdr(selectVdr.selectedItem.orElse(""))
    }
}
