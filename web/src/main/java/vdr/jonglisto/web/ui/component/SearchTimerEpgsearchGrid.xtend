package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Button
import com.vaadin.ui.Grid
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.Notification
import com.vaadin.ui.UI
import com.vaadin.ui.Window.CloseEvent
import com.vaadin.ui.Window.CloseListener
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.themes.ValoTheme
import java.util.List
import javax.inject.Inject
import org.apache.commons.lang3.StringUtils
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.EpgsearchSearchTimer.Field
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
@ViewScoped
class SearchTimerEpgsearchGrid {

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    @Inject
    private SearchTimerEpgsearchEditWindow editWindow

    val COL_ACTIVE = "active"
    val COL_TYPE = "type"
    val COL_CHANNELS = "channels"
    val COL_EXPRESSION = "expression"
    val COL_DIRECTORY = "directory"
    val COL_ACTION = "action"

    var Grid<EpgsearchSearchTimer> grid

    var List<EpgsearchSearchTimer> searchTimer
    var VDR vdr

    def init(VDR vdr) {
        this.vdr = vdr
        this.searchTimer = svdrp.getEpgsearchSearchTimerList(vdr)
        return getGrid()
    }

    def getGrid() {
        grid = new Grid
        grid.items = searchTimer

        grid.addColumn(ev | createActive(ev.getField(Field.has_action))) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.searchtimerActive) //
            .setId(COL_ACTIVE) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createType(ev.getField(Field.action))) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.searchtimerType) //
            .setId(COL_TYPE) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createChannels(ev.getField(Field.use_channel), ev.getField(Field.channels))) //
            .setCaption(messages.searchtimerChannel) //
            .setId(COL_CHANNELS) //
            .setExpandRatio(0) //

        grid.addColumn(ev | ev.getField(Field.pattern)) //
            .setCaption(messages.searchtimerExpression) //
            .setId(COL_EXPRESSION) //
            .setExpandRatio(1) //

        grid.addColumn(ev | ev.getField(Field.directory)) //
            .setCaption(messages.searchtimerDirectory) //
            .setId(COL_DIRECTORY) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createActions(ev)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.searchtimerAction) //
            .setId(COL_ACTION) //
            .setExpandRatio(0) //

        grid.selectionMode = SelectionMode.NONE

        grid.setSizeFull

        return grid
    }

    def refreshSearchTimer() {
        if (grid !== null) {
            grid.items = svdrp.getEpgsearchSearchTimerList(vdr)
        }
    }

    def newTimer() {
        openEditWindow(new EpgsearchSearchTimer)
    }

    def setVdr(VDR vdr) {
        this.vdr = vdr
        refreshSearchTimer
    }

    private def createType(String type) {
        var Button button

        // 0: create a timer
        // 1: announce only via OSD (no timer)
        // 2: switch only (no timer)
        switch (type) {
            case '0': {
                button = new Button("", VaadinIcons.ELLIPSIS_CIRCLE_O)
                button.description = messages.searchtimerRepeating
            }
            case '2': {
                button =  new Button("", VaadinIcons.PLAY)
                button.description = messages.searchtimerChangeChannel
            }
            case '1': {
                button = new Button("", VaadinIcons.SEARCH)
                button.description = messages.searchtimerSearch
            }
            default: {
                button = new Button("")
            }
        }

        button.width = "22px"
        button.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

        return button
    }

    private def createActive(String active) {
        var Button button

        switch(active) {
            case "2": {
                button = new Button("", VaadinIcons.CHECK)
                button.description = messages.searchtimerActive
            }

            case "1": {
                button = new Button("", VaadinIcons.CHECK)
                button.description = messages.searchtimerActive
            }

            case "0": {
                button = new Button("", VaadinIcons.CLOSE)
                button.description = messages.searchtimerInactive
            }
        }

        button.width = "22px"
        button.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

        return button
    }

    private def createChannels(String useChannel, String channels) {
        if (StringUtils.isNotEmpty(channels)) {
            switch (useChannel) {
                case "0": return "" /* nothing */

                case "1": { /* intervall */
                    val sp = channels.split("\\|")

                    val chan1 = svdrp.getChannel(sp.get(0)).name
                    var chan2 = ""

                    if (sp.length > 1) {
                        chan2 = svdrp.getChannel(sp.get(1)).name
                    }

                    if (chan2.length > 0) {
                        return (chan1 + " - " + chan2).trim
                    } else {
                        return chan1.trim
                    }
                }

                case "2": {
                    return channels
                }

                case "3": {
                    return "FTA only"
                }
            }

            return ""
        }

        return ""
    }

    private def createActions(EpgsearchSearchTimer timer) {
       val layout = cssLayout[
            button("") [
                icon = VaadinIcons.TRASH
                description = messages.searchtimerDelete
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    Notification.show("Not yet implemented: Delete search timer")
                })
            ]

            button("") [
                icon = VaadinIcons.EDIT
                description = messages.searchtimerEdit
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | openEditWindow(timer))
            ]
        ]

        return layout
    }

    private def openEditWindow(EpgsearchSearchTimer timer) {
        val w = editWindow.showWindow(vdr, timer)
        w.addCloseListener(new CloseListener() {
            override windowClose(CloseEvent e) {
                refreshSearchTimer
            }
        })

        UI.current.addWindow(w)
    }
}
