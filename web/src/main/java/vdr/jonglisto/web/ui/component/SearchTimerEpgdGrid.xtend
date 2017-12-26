package vdr.jonglisto.web.ui.component

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
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.apache.commons.lang3.StringUtils
import vdr.jonglisto.db.SearchTimerService
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.EpgdSearchTimer
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class SearchTimerEpgdGrid {

    @Inject
    private Svdrp svdrp

    @Inject
    private Config config

    @Inject
    private Messages messages

    @Inject
    private SearchTimerEpgdEditWindow editWindow

    val COL_ACTIVE = "active"
    val COL_NAME = "name"
    val COL_TYPE = "type"
    val COL_HITS = "hits"
    val COL_CHANNELS = "channels"
    val COL_EXPRESSION = "expression"
    val COL_EXPRESSION1 = "expression1"
    val COL_VDRNAME = "vdrname"
    val COL_DIRECTORY = "directory"
    val COL_ACTION = "action"

    var Grid<EpgdSearchTimer> grid

    var List<EpgdSearchTimer> searchTimer

    val service = new SearchTimerService

    @PostConstruct
    def void init() {
        this.searchTimer = service.searchTimers
    }

    def getGrid() {
        grid = new Grid
        grid.items = searchTimer

        grid.addColumn(ev | createActive(ev.active)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.searchtimerActive) //
            .setId(COL_ACTIVE) //
            .setExpandRatio(0) //

        grid.addColumn(ev | ev.name) //
            .setCaption(messages.searchtimerName) //
            .setId(COL_NAME) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createType(ev.type)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.searchtimerType) //
            .setId(COL_TYPE) //
            .setExpandRatio(0) //

        grid.addColumn(ev | ev.hits) //
            .setCaption(messages.searchtimerHits) //
            .setId(COL_HITS) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createChannels(ev.channelIds)) //
            .setCaption(messages.searchtimerChannel) //
            .setId(COL_CHANNELS) //
            .setExpandRatio(0) //

        grid.addColumn(ev | ev.expression) //
            .setCaption(messages.searchtimerExpression) //
            .setId(COL_EXPRESSION) //
            .setExpandRatio(1) //

        grid.addColumn(ev | ev.expression1) //
            .setCaption(messages.searchtimerExpression1) //
            .setId(COL_EXPRESSION1) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createVdrName(ev)) //
            .setCaption(messages.searchtimerVdr) //
            .setId(COL_VDRNAME) //
            .setExpandRatio(0) //

        grid.addColumn(ev | ev.directory) //
            .setCaption(messages.searchtimerDirectory) //
            .setId(COL_DIRECTORY) //
            .setExpandRatio(0) //

        grid.addColumn(ev | createActions(ev)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.searchtimerAction) //
            .setId(COL_ACTION) //
            .setExpandRatio(0) //

        // grid.addItemClickListener[event | handleItemClick(event)] //event.item.showEpgDetails]

        grid.selectionMode = SelectionMode.NONE
        // grid.rowHeight = 55

        grid.setSizeFull

        return grid
    }

    def refreshSearchTimer() {
        grid.items = service.searchTimers
    }

    def newTimer() {
        openEditWindow(new EpgdSearchTimer)
    }

    private def createType(String type) {
        var Button button

        // R: repeat
        // V: view / change change
        // S: search
        switch (type) {
            case 'R': {
                button = new Button("", VaadinIcons.ELLIPSIS_CIRCLE_O)
                button.description = messages.searchtimerRepeating
            }
            case 'V': {
                button =  new Button("", VaadinIcons.PLAY)
                button.description = messages.searchtimerChangeChannel
            }
            case 'S': {
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

    private def createActive(int active) {
        var Button button

        if (active == 1) {
            button = new Button("", VaadinIcons.CHECK)
            button.description = messages.searchtimerActive
        } else {
            button = new Button("", VaadinIcons.CLOSE)
            button.description = messages.searchtimerInactive
        }

        button.width = "22px"
        button.styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS

        return button
    }

    private def createChannels(String channelIds) {
        if (StringUtils.isNotEmpty(channelIds)) {
            val result = new StringBuilder
            val id = channelIds.split(",")

            for (ch : id) {
                result.append(svdrp.getChannel(ch).name).append(" ")
            }

            return result.toString.trim
        }

        return ""
    }

    private def createVdrName(EpgdSearchTimer timer) {
        if (timer.ip !== null) {
            val vdr = config.findVdr(timer.ip, timer.svdrp)

            if (vdr.present) {
                return vdr.get.name
            } else {
                return "(" + timer.vdrname + ")"
            }
        } else {
            return "Auto"
        }
    }

    private def createActions(EpgdSearchTimer timer) {
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

    private def openEditWindow(EpgdSearchTimer timer) {
        val w = editWindow.showWindow(timer)
        w.addCloseListener(new CloseListener() {
            override windowClose(CloseEvent e) {
                refreshSearchTimer
            }
        })

        UI.current.addWindow(w)
    }
}
