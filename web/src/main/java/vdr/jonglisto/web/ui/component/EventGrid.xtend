package vdr.jonglisto.web.ui.component

import com.vaadin.data.provider.ListDataProvider
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.ComboBox
import com.vaadin.ui.Grid
import com.vaadin.ui.Grid.ItemClick
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.TextField
import com.vaadin.ui.UI
import com.vaadin.ui.components.grid.HeaderRow
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.renderers.HtmlRenderer
import com.vaadin.ui.themes.ValoTheme
import java.util.Collections
import java.util.HashSet
import java.util.List
import org.apache.commons.lang3.StringUtils
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.EpgCustomColumn
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.ui.EpgView
import vdr.jonglisto.web.ui.EpgView.EPGTYPE
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class EventGrid {

    val COL_CHANNEL = "channel"
    val COL_DATE = "date"
    val COL_TIME = "time"
    val COL_TITLE = "title"
    val COL_SERIES = "series"
    val COL_CATEGORY = "category"
    val COL_GENRE = "genre"
    val COL_ACTION = "action"
    val COL_CUSTOM = "custom"

    var Grid<Epg> grid

    var String filterChannel
    var String filterTitle
    var String filterGenre
    var String filterCategory

    var VDR currentVdr

    var List<Epg> events
    val Messages messages
    var long usedUnixTime

    var ComboBox<String> genreFilter
    var ComboBox<String> categoryFilter

    val EPGTYPE epgType

    new (VDR vdr, EPGTYPE epgType, Messages messages) {
        this.currentVdr = vdr
        this.events = Collections.emptyList
        this.messages = messages
        this.epgType = epgType
    }

    def setEvents(List<Epg> events) {
        this.events = events
        return this
    }

    def getGrid() {
        return grid
    }

    def setVdr(VDR vdr) {
        currentVdr = vdr
    }

    def void createGrid(long unixTime) {
        grid = new Grid
        grid.items = events

        usedUnixTime = unixTime

        if (epgType == EPGTYPE.TIME || epgType == EPGTYPE.SEARCH) {
            grid.addColumn(ev|createChannel(ev)) //
                .setCaption(messages.epgChannelCaption) //
                .setId(COL_CHANNEL) //
                .setExpandRatio(0) //
                .setComparator([ev1, ev2|createChannel(ev1).compareToIgnoreCase(createChannel(ev2))])
        }

        if (epgType == EPGTYPE.CHANNEL || epgType == EPGTYPE.SEARCH) {
            grid.addColumn(ev|createDate(ev)) //
                .setCaption(messages.epgDateCaption) //
                .setId(COL_DATE) //
                .setExpandRatio(0) //
                .setComparator([ev1, ev2|ev1.startTime.compareTo(ev2.startTime)])
        }

        grid.addColumn(ev|createTimeProgress(ev)) //
            .setRenderer(new ComponentRenderer) //
            .setCaption(messages.epgTimeCaption) //
            .setId(COL_TIME) //
            .setExpandRatio(0) //
            .setWidth(140)
            .setComparator([ev1, ev2 | ev1.startTime.compareTo(ev2.startTime)])

        grid.addColumn(ev | createTitle(ev))
            .setRenderer(new HtmlRenderer)
            .setCaption(messages.epgTitleCaption) //
            .setId(COL_TITLE) //
            .setExpandRatio(2)
            .setComparator([ev1, ev2|ev1.title.compareToIgnoreCase(ev2.title)])
            .setMinimumWidthFromContent(false)

        grid.addColumn(ev|createSeries(ev)) //
            .setRenderer(new HtmlRenderer)
            .setCaption(messages.epgSeriesCaption) //
            .setId(COL_SERIES) //
            .setExpandRatio(1) //
            // .setComparator([ev1, ev2|ev1.description.compareToIgnoreCase(ev2.description)])
            .setMinimumWidthFromContent(false)

        if (Configuration.get.epgGenre.key !== null) {
            grid.addColumn(ev|createGenre(ev)) //
                .setCaption(messages.epgGenreCaption) //
                .setId(COL_GENRE) //
                .setExpandRatio(1) //
                // .setComparator([ev1, ev2|ev1.description.compareToIgnoreCase(ev2.description)])
                .setMinimumWidthFromContent(false)
        }

        if (Configuration.get.epgCategory.key !== null) {
            grid.addColumn(ev|createCategory(ev)) //
                .setCaption(messages.epgCategoryCaption) //
                .setId(COL_CATEGORY) //
                .setExpandRatio(1) //
                // .setComparator([ev1, ev2|ev1.description.compareToIgnoreCase(ev2.description)])
                .setMinimumWidthFromContent(false)
        }

        val customList = Configuration.get.epgCustom
        for (var i = 0; i < customList.size; i++) {
            val idx = i
            grid.addColumn(ev|createCustom(ev, customList.get(idx))) //
                .setCaption(customList.get(idx).header)
                .setRenderer(new HtmlRenderer) //
                .setId(COL_CUSTOM + idx) //
                .setExpandRatio(1) //
                .setMinimumWidthFromContent(false)
        }

        grid.addColumn(ev | createActionButtons(ev)) //
            .setCaption(messages.epgActionCaption) //
            .setRenderer(new ComponentRenderer) //
            .setId(COL_ACTION) //
            .setExpandRatio(0)

        initFilter

        grid.addItemClickListener[event | handleItemClick(event)] //event.item.showEpgDetails]

        grid.selectionMode = SelectionMode.NONE
        grid.rowHeight = 55
    }

    def handleItemClick(ItemClick<Epg> event) {
        if (event.column.id ==  COL_CHANNEL) {
            if (grid.parent instanceof EpgView) {
                (grid.parent as EpgView).switchToChannelView(event.item)
            } else {
                log.error("Parent component is not of type EpgView.")
            }
        } else {
            event.item.showEpgDetails
        }
    }

    def setItems(List<Epg> list) {
        grid.items = list

        if (Configuration.get.epgGenre.key !== null) {
            fillGenreFilter
        }

        if (Configuration.get.epgCategory.key !== null) {
            fillCategoryFilter
        }

        // fillCustomFilter
    }

    def setUsedTime(Long usedUnixTime) {
        this.usedUnixTime = usedUnixTime
    }

    def setSizeFull() {
        grid.setSizeFull
    }

    def void setSelectedVdr(String v) {
        selectedVdr = v
    }

    private def showEpgDetails(Epg epg) {
        UI.current.addWindow(new EpgDetailsWindow(currentVdr, messages, epg, false))
    }

    private def editEpgDetails(Epg epg) {
        UI.current.addWindow(new EpgDetailsWindow(currentVdr, messages, epg, true))
    }

    private def createChannel(Epg ev) {
        return SvdrpClient.get.getChannel(ev.channelId).name
    }

    private def createDate(Epg ev) {
        return DateTimeUtil.toDate(ev.startTime, messages.formatDate)
    }

    private def createTimeProgress(Epg ev) {
        val start = DateTimeUtil.toTime(ev.startTime, messages.formatTime)
        val end = DateTimeUtil.toTime(ev.startTime + ev.duration, messages.formatTime)

        val layout = cssLayout[
            label(start + " - " + end)

            val progress = Math.max(0f, (usedUnixTime as float- ev.startTime as float) / ev.duration as float)

            if (progress > 0) {
                progressBar(progress)
            }

            setSizeUndefined
        ]

        return layout;
    }

    private def createTitle(Epg ev) {
        val writer = new StringBuilder
        writer.append("<div class='component-wrap'>")
        writer.append("<div class='bold'>").append(HtmlSanitizer.clean(ev.title)).append("</div>")
        writer.append("<div>").append(HtmlSanitizer.clean(ev.shortText)).append("</div>")
        writer.append("</div>")

        return writer.toString
    }

    private def createSeries(Epg ev) {
        val builder = new StringBuilder

        builder.append("<div class='component-wrap'>")

        if (StringUtils.isNotEmpty(ev.season)) {
            builder.append("<div>").append(messages.epgSeason).append(": ").append(HtmlSanitizer.clean(ev.season)).append("</div>")
        }

        if (StringUtils.isNotEmpty(ev.part)) {
            builder.append("<div>").append(messages.epgPart).append(": ").append(HtmlSanitizer.clean(ev.part))
            if (StringUtils.isNotEmpty(ev.parts)) {
                builder.append(" &#47; ").append(HtmlSanitizer.clean(ev.parts))
            }
            builder.append("</div>")
        }

        builder.append("</div>")

        return builder.toString
    }

    private def createGenre(Epg ev) {
        return ev.genre
    }

    private def createCategory(Epg ev) {
        return ev.category
    }

    private def createCustom(Epg ev, EpgCustomColumn column) {
        return ev.getCustom(column.header)
    }

    private def createActionButtons(Epg epg) {
        val layout = cssLayout[
            button("") [
                icon = VaadinIcons.PLAY
                description = messages.epgSwitchChannel
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    try {
                        SvdrpClient.get.switchChannel(currentVdr, epg.channelId)
                    } catch (Exception e) {
                        Notification.show(messages.epgErrorSwitchFailed, Type.ERROR_MESSAGE)
                    }
                })
            ]

            button("") [
                icon = VaadinIcons.SEARCH
                description = messages.epgSearchRetransmission
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    if (grid.parent instanceof EpgView) {
                        (grid.parent as EpgView).searchRetransmissions(epg)
                    } else {
                        log.error("Parent component is not of type EpgView.")
                    }
                })
            ]

            button("") [
                icon = VaadinIcons.EDIT
                description = messages.epgEditEpg
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    editEpgDetails(epg)
                })
            ]

            button("") [
                icon = VaadinIcons.CIRCLE
                description = messages.epgRecord
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    val w = new TimerEditWindow(currentVdr, messages, epg)
                    UI.addWindow(w)
                })
            ]

            button("") [
                // TODO: implement event/button alarm
                icon = VaadinIcons.ALARM
                description = messages.epgAlarm
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    Notification.show("Not yet implemented: " + "Alarm actions, Switch to channel, OSD message")
                })
            ]
        ]

        return layout
    }

    private def initFilter() {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in initFilter")
            return
        }

        val filterRow = grid.appendHeaderRow();

        if (epgType == EPGTYPE.TIME) {
            filterRow.initChannelFilter
        }

        filterRow.initTitleFilter

        if (Configuration.get.epgGenre.key !== null) {
            filterRow.initGenreFilter
        }

        if (Configuration.get.epgCategory.key !== null) {
            filterRow.initCategoryFilter
        }

        // filterRow.initCustomFilter
    }

    private def initChannelFilter(HeaderRow filterRow) {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in initChannelFilter")
            return
        }

        val channelFilterCell = filterRow.getCell(COL_CHANNEL);
        val channelFilter = new TextField()
        channelFilter.placeholder = messages.filterChannel
        channelFilter.addValueChangeListener([event | filterChannel = event.value; updateFilter])
        channelFilter.width = "100%"
        channelFilterCell.component = channelFilter
    }

    private def initTitleFilter(HeaderRow filterRow) {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in initTitleFilter")
            return
        }

        val titleFilterCell = filterRow.getCell(COL_TITLE);
        val titleFilter = new TextField()
        titleFilter.placeholder = messages.filterTitle
        titleFilter.addValueChangeListener([event | filterTitle = event.value; updateFilter])
        titleFilter.width = "100%"
        titleFilterCell.component = titleFilter
    }

    private def initGenreFilter(HeaderRow filterRow) {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in initGenreFilter")
            return
        }

        val genreFilterCell = filterRow.getCell(COL_GENRE);
        genreFilter = new ComboBox<String>
        genreFilter.textInputAllowed = true
        genreFilter.placeholder = messages.filterContent
        genreFilter.addValueChangeListener([event | filterGenre = event.value; updateFilter])
        genreFilter.width = "100%"

        fillGenreFilter
        genreFilterCell.component = genreFilter
    }

    private def fillGenreFilter() {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in fillGenreFilter")
            return
        }

        val genre = new HashSet<String>
        val dataProvider = grid.dataProvider as ListDataProvider<Epg>

        dataProvider.items.stream.filter(s | StringUtils.isNotEmpty(s.genre)).map(s | s.genre).forEach(s | genre.add(s))
        genreFilter.items = genre.sort
    }

    private def initCategoryFilter(HeaderRow filterRow) {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in initCategoryFilter")
            return
        }

        val categoryFilterCell = filterRow.getCell(COL_CATEGORY);
        categoryFilter = new ComboBox<String>
        categoryFilter.textInputAllowed = true
        categoryFilter.placeholder = messages.filterContent
        categoryFilter.addValueChangeListener([event | filterCategory = event.value; updateFilter])
        categoryFilter.width = "100%"

        fillCategoryFilter
        categoryFilterCell.component = categoryFilter
    }

    private def fillCategoryFilter() {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in fillCategoryFilter")
            return
        }

        val categories = new HashSet<String>
        val dataProvider = grid.dataProvider as ListDataProvider<Epg>

        dataProvider.items.stream.filter(s | StringUtils.isNotEmpty(s.category)).map(s | s.category).forEach(s | categories.add(s))
        categoryFilter.items = categories.sort
    }

    private def updateFilter() {
        if (grid === null) {
            log.error("Internal Error: Grid is yot yet initialized in updateFilter")
            return
        }

        val dataProvider = grid.dataProvider as ListDataProvider<Epg>

        dataProvider.setFilter([ s | {
            var result = true

            if ((filterChannel !== null) && (filterChannel.length > 0)) {
                result = result && createChannel(s).toUpperCase.startsWith(filterChannel.toUpperCase)
            }

            if ((filterTitle !== null) && (filterTitle.length > 0)) {
                var r = false
                if (s.title !== null) {
                    r = s.title.toUpperCase.contains(filterTitle.toUpperCase)
                }

                if (s.shortText !== null) {
                    r = r || s.shortText.toUpperCase.contains(filterTitle.toUpperCase)
                }

                result = result && r
            }

            if ((filterGenre !== null) && (filterGenre.length > 0)) {
                result = result && filterGenre == s.genre
            }

            if ((filterCategory !== null) && (filterCategory.length > 0)) {
                result = result && filterCategory == s.category
            }

            result
        }])
    }
}
