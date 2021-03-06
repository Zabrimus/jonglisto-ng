package vdr.jonglisto.web.ui.component

import com.vaadin.data.provider.ListDataProvider
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Button
import com.vaadin.ui.ComboBox
import com.vaadin.ui.Grid
import com.vaadin.ui.Grid.ItemClick
import com.vaadin.ui.Grid.SelectionMode
import com.vaadin.ui.Image
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.TextField
import com.vaadin.ui.UI
import com.vaadin.ui.components.grid.HeaderRow
import com.vaadin.ui.renderers.ComponentRenderer
import com.vaadin.ui.renderers.HtmlRenderer
import com.vaadin.ui.themes.ValoTheme
import de.steinwedel.messagebox.ButtonOption
import de.steinwedel.messagebox.MessageBox
import java.util.Collections
import java.util.HashSet
import java.util.List
import javax.inject.Inject
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.EpgCustomColumn
import vdr.jonglisto.model.EpgdSearchTimer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.ui.EpgView
import vdr.jonglisto.web.ui.EpgView.EPGTYPE
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static extension org.apache.commons.lang3.StringUtils.*
import static extension vdr.jonglisto.web.xtend.UIBuilder.*
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.EpgsearchSearchTimer.Field

@Log("jonglisto.web")
@SuppressWarnings("unchecked", "serial")
class EventGrid {
    @Inject
    Svdrp svdrp

    @Inject
    Config config

    @Inject
    Messages messages

    @Inject
    EpgDetailsWindow epgDetails

    @Inject
    TimerEditWindow timerEdit

    @Inject
    EpgAlarmWindow alarmEdit

    @Inject
    ChannelLogo channelLogo

    @Inject
    SearchTimerEpgdEditWindow epgdWindow

    @Inject
    SearchTimerEpgsearchEditWindow epgsearchWindow

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

    var List<Epg> events = Collections.emptyList
    var long usedUnixTime

    var ComboBox<String> genreFilter
    var ComboBox<String> categoryFilter

    var EPGTYPE epgType

    def setEvents(List<Epg> events) {
        this.events = events
        return this
    }

    def setVdr(VDR vdr) {
        currentVdr = vdr
        return this
    }

    def setEpgType(EPGTYPE epgType) {
        this.epgType = epgType
        return this
    }

    def getGrid() {
        return grid
    }

    def void createGrid(long unixTime) {
        grid = new Grid
        grid.items = events

        usedUnixTime = unixTime

        if (epgType == EPGTYPE.TIME || epgType == EPGTYPE.SEARCH) {
            grid.addColumn(ev|createChannel(ev)) //
                .setRenderer(new ComponentRenderer)
                .setCaption(messages.epgChannelCaption) //
                .setId(COL_CHANNEL) //
                .setExpandRatio(0) //
                .setComparator([ev1, ev2|(createChannel(ev1).data as String).compareToIgnoreCase(createChannel(ev2).data as String)])
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

        if (config.epgGenre.key !== null) {
            grid.addColumn(ev|createGenre(ev)) //
                .setCaption(messages.epgGenreCaption) //
                .setId(COL_GENRE) //
                .setExpandRatio(1) //
                // .setComparator([ev1, ev2|ev1.description.compareToIgnoreCase(ev2.description)])
                .setMinimumWidthFromContent(false)
        }

        if (config.epgCategory.key !== null) {
            grid.addColumn(ev|createCategory(ev)) //
                .setCaption(messages.epgCategoryCaption) //
                .setId(COL_CATEGORY) //
                .setExpandRatio(1) //
                // .setComparator([ev1, ev2|ev1.description.compareToIgnoreCase(ev2.description)])
                .setMinimumWidthFromContent(false)
        }

        val customList = config.epgCustom
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
        grid.recalculateColumnWidths
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

        if (config.epgGenre.key !== null) {
            fillGenreFilter
        }

        if (config.epgCategory.key !== null) {
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

    def void actionPlay(Epg epg) {
        try {
            svdrp.switchChannel(currentVdr, epg.channelId)
        } catch (Exception e) {
            Notification.show(messages.epgErrorSwitchFailed, Type.ERROR_MESSAGE)
        }
    }

    def void actionSearch(Epg epg) {
        if (grid.parent instanceof EpgView) {
            (grid.parent as EpgView).searchRetransmissions(epg)
        } else {
            log.error("Parent component is not of type EpgView.")
        }
    }

    def void actionEdit(Epg epg) {
        editEpgDetails(epg)
    }

    def void actionRecord(Epg epg) {
        UI.current.addWindow(timerEdit.showWindow(currentVdr, epg))
    }

    def void actionAlarm(Epg epg) {
        UI.current.addWindow(alarmEdit.showWindow(currentVdr.name, epg))
    }

    private def showEpgDetails(Epg epg) {
        UI.current.addWindow(epgDetails.showWindow(this, currentVdr, epg, false, -1))
    }

    private def editEpgDetails(Epg epg) {
        UI.current.addWindow(epgDetails.showWindow(this, currentVdr, epg, true, -1))
    }

    def void actionCreateSearchTimer(Epg epg) {
        var epgsearchAvailable = svdrp.isPluginAvailable(currentVdr, "epgsearch")
        var epgdAvailable = config.isDatabaseConfigured

        if (!epgsearchAvailable && !epgdAvailable) {
            Notification.show(messages.epgSearchTimerNotPossible)
            return
        }

        if (epgsearchAvailable && epgdAvailable) {
            // we need a choice, which one is desired
            val mb = MessageBox.create();
            mb.asModal(true)
                .withCaption(messages.epgSelectSearchTimer)
                .withMessage(messages.epgWhichSearchTimer)
                .withCustomButton([ createEpgdTimer(epg) ], ButtonOption.caption("epgd"))
                .withCustomButton([ createEpgsearchTimer(epg)], ButtonOption.caption("epgsearch"))
                .open();
            return
        }

        if (epgsearchAvailable) {
            createEpgsearchTimer(epg)
            return
        }

        if (epgdAvailable) {
            createEpgdTimer(epg)
            return
        }
    }

    private def createEpgdTimer(Epg epg) {
        val timer = new EpgdSearchTimer => [
            type = 'R'
            name = epg.title
            active = 1
            repeatfields = 3
            searchfields = 1
            namingmode = 1
            searchmode = 4
            expression = epg.title
            directory = epg.title
            channelIds = epg.channelId
            chexclude = '0'
        ]

        UI.current.addWindow(epgdWindow.showWindow(timer))
    }

    private def createEpgsearchTimer(Epg epg) {
        val timer = new EpgsearchSearchTimer => [
            setField(Field.pattern, epg.title)
            setField(Field.use_channel, "1")
            setField(Field.channels, epg.channelId + "|" + epg.channelId)
            setField(Field.mode, "0")
            setField(Field.use_title, "1")
            setField(Field.use_subtitle, "1")
            setField(Field.has_action, "1")
            setField(Field.directory, epg.title)
            setField(Field.prio, "50")
            setField(Field.lft, "50")
            setField(Field.bstart, "5")
            setField(Field.bstop, "10")
            setField(Field.action, "0")
            setField(Field.avoid_repeats, "1")
            setField(Field.comp_title, "1")
            setField(Field.comp_subtitle, "2")
        ]

        UI.current.addWindow(epgsearchWindow.showWindow(currentVdr, timer))
    }

    private def createChannel(Epg ev) {
        val name = svdrp.getChannel(ev.channelId).name
        var Image image

        try {
            image = channelLogo.getImage(name)
        } catch (Exception e) {
            image = null
        }

        if (image !== null) {
            image.data = name
            image.addClickListener(s | (grid.parent as EpgView).switchToChannelView(ev))
            return image
        } else {
            val button = new Button(name)
            button.styleName = ValoTheme.BUTTON_BORDERLESS
            button.data = name
            button.addClickListener(s | (grid.parent as EpgView).switchToChannelView(ev))
            return button
        }
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

        if (ev.season.isNotEmpty) {
            builder.append("<div>").append(messages.epgSeason).append(": ").append(HtmlSanitizer.clean(ev.season)).append("</div>")
        }

        if (ev.part.isNotEmpty) {
            builder.append("<div>").append(messages.epgPart).append(": ").append(HtmlSanitizer.clean(ev.part))
            if (ev.parts.isNotEmpty) {
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
            styleName = "epgaction"

            button("") [
                icon = VaadinIcons.PLAY
                description = messages.epgSwitchChannel
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    actionPlay(epg)
                })
            ]

            button("") [
                icon = VaadinIcons.SEARCH
                description = messages.epgSearchRetransmission
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    actionSearch(epg)
                })
            ]

            button("") [
                icon = VaadinIcons.EDIT
                description = messages.epgEditEpg
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    actionEdit(epg)
                })
            ]

            button("") [
                icon = VaadinIcons.CIRCLE
                description = messages.epgRecord
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    actionRecord(epg)
                })
            ]

            button("") [
                icon = VaadinIcons.ALARM
                description = messages.epgAlarm
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    actionAlarm(epg)
                })
            ]

            button("") [
                icon = VaadinIcons.RETWEET
                description = messages.epgCreateSearchTimer
                width = "22px"
                styleName = ValoTheme.BUTTON_ICON_ONLY + " " + ValoTheme.BUTTON_BORDERLESS
                addClickListener(s | {
                    actionCreateSearchTimer(epg)
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

        if (config.epgGenre.key !== null) {
            filterRow.initGenreFilter
        }

        if (config.epgCategory.key !== null) {
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

        dataProvider.items.stream.filter(s | s.genre.isNotEmpty).map(s | s.genre).forEach(s | genre.add(s))
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

        dataProvider.items.stream.filter(s | s.category.isNotEmpty).map(s | s.category).forEach(s | categories.add(s))
        categoryFilter.items = categories.sort
    }

    private def updateFilter() {
        if (grid === null) {
            log.error("Internal Error: Grid is not yet initialized in updateFilter")
            return
        }

        val dataProvider = grid.dataProvider as ListDataProvider<Epg>

        dataProvider.setFilter([ s | {
            var result = true

            if ((filterChannel !== null) && (filterChannel.length > 0)) {
                var name = createChannel(s).data as String
                result = result && name.toUpperCase.startsWith(filterChannel.toUpperCase)
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
