package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Button
import com.vaadin.ui.CheckBox
import com.vaadin.ui.ComboBox
import com.vaadin.ui.DateField
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.Notification
import com.vaadin.ui.Notification.Type
import com.vaadin.ui.TextField
import java.time.LocalDate
import java.time.LocalTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.ArrayList
import java.util.Collections
import java.util.Comparator
import java.util.List
import java.util.Set
import java.util.regex.Pattern
import java.util.stream.Collectors
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.apache.commons.lang3.StringUtils
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.search.EpgSearch
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.EventGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
@CDIView(MainUI.EPG_VIEW)
class EpgView extends BaseView {

    public enum EPGTYPE {
        TIME, CHANNEL, SEARCH
    }

    @Inject
    private EventGrid eventGrid

    private EpgSearch epgSearch = EpgSearch.getInstance()

    var EPGTYPE epgType
    var DateField epgDateCriteria
    var List<String> timeSelectValues

    var Button epgNowButton
    var DateField epgDateSelect
    var ComboBox<String> epgTimeCriteria
    var ComboBox<Channel> epgChannelCriteria
    var NativeSelect<String> epgTypeSelect

    var CheckBox searchRegex
    var TextField searchTitle
    var TextField searchShortText
    var TextField searchDescription
    var Button searchButton

    var NativeSelect<String> tvRadioSelect
    var NativeSelect<String> ftaEncSelect
    var NativeSelect<String> favouriteSelect

    var NativeSelect<String> regexPattern

    @PostConstruct
    def void init() {
        super.init(BUTTON.EPG)
    }

    protected override createMainComponents() {
        timeSelectValues = new ArrayList<String>
        timeSelectValues.addAll(config.epgTimeSelect)

        cssLayout(this) [
            height = null
            width = "100%"
            spacing = true

            epgType = EPGTYPE.TIME

            epgTypeSelect = nativeSelect [
                styleName = "epg-type"

                emptySelectionAllowed = false
                items = #[messages.epgTypeTime, messages.epgTypeChannel, messages.epgTypeSearch]

                addSelectionListener(it | {
                    switch it.selectedItem.get {
                        case messages.epgTypeTime : {
                            epgNowButton.visible = true
                            epgDateSelect.visible = true
                            epgTimeCriteria.visible = true
                            epgChannelCriteria.visible = false

                            searchRegex.visible = false
                            searchTitle.visible = false
                            searchShortText.visible = false
                            searchDescription.visible = false
                            searchButton.visible = false

                            regexPattern.visible = false

                            epgType = EPGTYPE.TIME
                        }

                        case messages.epgTypeChannel: {
                            epgNowButton.visible = false
                            epgDateSelect.visible = false
                            epgTimeCriteria.visible = false
                            epgChannelCriteria.visible = true

                            searchRegex.visible = false
                            searchTitle.visible = false
                            searchShortText.visible = false
                            searchDescription.visible = false
                            searchButton.visible = false

                            regexPattern.visible = false

                            epgType = EPGTYPE.CHANNEL

                            updateChannelSelect
                            listChannel
                        }

                        case messages.epgTypeSearch: {
                            epgNowButton.visible = false
                            epgDateSelect.visible = false
                            epgTimeCriteria.visible = false
                            epgChannelCriteria.visible = false

                            searchRegex.visible = true
                            searchTitle.visible = true
                            searchShortText.visible = true
                            searchDescription.visible = true
                            searchButton.visible = true

                            regexPattern.visible = true

                            epgType = EPGTYPE.SEARCH
                        }
                    }

                    prepareGrid
                })
            ]

            if (config?.favourites?.favourite.size > 0) {
                favouriteSelect = nativeSelect [
                    emptySelectionAllowed = true
                    items = config.favourites.favourite.map[s | s.name]

                    addSelectionListener(it | {
                        switch(epgTypeSelect.selectedItem.get) {
                            case messages.epgTypeTime : {
                                listTime
                            }

                            case messages.epgTypeChannel : {
                                updateChannelSelect
                                listChannel
                            }

                            case messages.epgTypeSearch: {
                                if (regexPattern.selectedItem.isPresent) {
                                    listRegexEvents
                                } else {
                                    listSearchResult
                                }
                            }
                        }
                    })
                ]
            }

            epgNowButton = button(messages.epgFilterNow) [
                styleName = "epg-now"

                addClickListener [
                    listNow
                ]
            ]

            cssLayout(it) [
                styleName = "epg-time"

                epgDateSelect = epgDateCriteria = dateField [
                    value = LocalDate.now(config.defaultZoneId)
                    addValueChangeListener(it | listTime)
                ]

                epgTimeCriteria = comboBox(timeSelectValues) [
                    value = DateTimeUtil.toTime(messages.formatTime)
                    addValueChangeListener(it | listTime)
                    setNewItemHandler(it | {timeSelectValues.add(it); epgTimeCriteria.selectedItem = it})
                ]
            ]

            cssLayout(it) [
                styleName = "epg-channel"

                epgChannelCriteria = comboBoxChannel(svdrp.channels) [
                    emptySelectionAllowed = false
                    setItemCaptionGenerator(it | it.name)
                    addValueChangeListener(it | listChannel)
                ]
            ]

            cssLayout(it) [
                styleName = "epg-search"

                regexPattern = nativeSelect [
                    emptySelectionAllowed = true
                    items = epgSearch.allCompletePattern.keySet.sort

                    addSelectionListener(it | {
                        if (it.selectedItem.isPresent) {
                            searchRegex.visible = false
                            searchTitle.visible = false
                            searchShortText.visible = false
                            searchDescription.visible = false
                            searchButton.visible = false

                            listRegexEvents
                        } else {
                            searchRegex.visible = true
                            searchTitle.visible = true
                            searchShortText.visible = true
                            searchDescription.visible = true
                            searchButton.visible = true
                        }
                    })
                ]

                searchRegex = checkbox(messages.epgSearchRegex) [
                ]

                searchTitle = textField("") [
                    placeholder = messages.epgSearchTitle
                ]

                searchShortText = textField("") [
                    placeholder = messages.epgSearchShorttext
                ]

                searchDescription = textField("") [
                    placeholder = messages.epgSearchDescription
                ]

                searchButton = button(messages.epgSearchSearch) [
                    icon = VaadinIcons.SEARCH
                    description = messages.epgSearchSearch

                    addClickListener(s | {
                        listSearchResult
                    })
                ]
            ]

            cssLayout(it) [
                tvRadioSelect = nativeSelect [
                    emptySelectionAllowed = false
                    items = #["TV/Radio", "TV", "Radio"]
                    selectedItem = "TV/Radio"

                    addSelectionListener(it | {
                        switch(epgTypeSelect.selectedItem.get) {
                            case messages.epgTypeTime : {
                                listTime
                            }

                            case messages.epgTypeChannel : {
                                updateChannelSelect
                            }

                            case messages.epgTypeSearch: {
                                if (regexPattern.selectedItem.isPresent) {
                                    listRegexEvents
                                } else {
                                    listSearchResult
                                }
                            }
                        }
                    })
                ]

                ftaEncSelect = nativeSelect [
                    emptySelectionAllowed = false
                    items = #["All", "FTA", "Encrypted"]
                    selectedItem = "All"

                    addSelectionListener(it | {
                        switch(epgTypeSelect.selectedItem.get) {
                            case messages.epgTypeTime : {
                                listTime
                            }

                            case messages.epgTypeChannel : {
                                updateChannelSelect
                            }

                            case messages.epgTypeSearch: {
                                if (regexPattern.selectedItem.isPresent) {
                                    listRegexEvents
                                } else {
                                    listSearchResult
                                }
                            }
                        }
                    })
                ]
            ]

            epgTypeSelect.selectedItem = messages.epgTypeTime
        ]

        prepareGrid

        eventGrid.setSizeFull
        addComponentsAndExpand(eventGrid.grid)
    }

    public def searchRetransmissions(Epg epg) {
        epgTypeSelect.selectedItem = messages.epgTypeSearch
        searchTitle.value = epg.title
        searchShortText.value = epg.shortText.substring(0, Math.min(20, epg.shortText.length))
        listSearchResult
    }

    public def switchToChannelView(Epg epg) {
        epgTypeSelect.selectedItem = messages.epgTypeChannel
        epgChannelCriteria.selectedItem = svdrp.getChannel(epg.channelId)
    }

    private def listNow() {
        epgDateCriteria.value = LocalDate.now(config.defaultZoneId)
        epgTimeCriteria.value = DateTimeUtil.toTime(messages.formatTime)
        eventGrid.usedTime = System.currentTimeMillis / 1000L
        listTime
    }

    private def listTime() {
        eventGrid.items = timeEvents
        eventGrid.usedTime = secondsForSelectedTime
    }

    private def listChannel() {
        eventGrid.items = channelEvents
    }

    private def listRegexEvents() {
        eventGrid.items = getRegexEvents()
    }

    private def listSearchResult() {
        eventGrid.items = searchResultEvents
    }

    def filterChannel() {
        val tvRadio = tvRadioSelect.selectedItem.orElse("TV/Radio")
        val ftaEnc = ftaEncSelect.selectedItem.orElse("All")

        val tvRadioType = if (tvRadio == "TV/Radio") 1 else if (tvRadio == "Radio") 2 else 3
        val ftaEncType = if (ftaEnc == "All") 1 else if (ftaEnc == "Encrypted") 2 else 3

        var filterFavourite = false
        var Set<String> filterChannel
        if (favouriteSelect !== null) {
            val favouriteList = config.favourites.favourite.findFirst[s | s.name == favouriteSelect.selectedItem.orElse("")]
            if (favouriteList !== null && favouriteList.channel.size > 0) {
                filterFavourite = true
                filterChannel = favouriteList.channel.toSet
            }
        }

        val tmpFilter = filterFavourite
        val tmpChannel = filterChannel
        return svdrp.channels.stream.filter[ s | {
                ((tvRadioType == 1) || (s.isRadio && (tvRadioType == 2)) || (!s.isRadio && (tvRadioType == 3)))
            &&  ((ftaEncType == 1) || (s.encrypted && (ftaEncType == 2)) || (!s.encrypted && (ftaEncType == 3)))
            &&  (!tmpFilter || tmpChannel.contains(s.id))
        }]
        .map[s | s.id]
        .collect(Collectors.toSet)
    }

    private def updateChannelSelect() {
        val channels = filterChannel.map[s | svdrp.getChannel(s)].toList
            .sortInplace(new Comparator<Channel>() {
                override compare(Channel o1, Channel o2) {
                    return o1.number.compareTo(o2.number)
                }
            })

        epgChannelCriteria.items = channels
        epgChannelCriteria.selectedItem = channels.get(0)
    }

    private def getTimeEvents() {
        val millis = secondsForSelectedTime

        val filteredChannels = filterChannel

        val result = svdrp.epg.stream //
            .filter(it | filteredChannels.contains(it.channelId))
            .filter(it | it.startTime <= millis && it.startTime + it.duration > millis) //
            .collect(Collectors.toList)
            .sortInplace(new Comparator<Epg>() {
                override compare(Epg o1, Epg o2) {
                    return svdrp.getChannel(o1.channelId).number.compareTo(svdrp.getChannel(o2.channelId).number)
                }
            })

        return result
    }

    private def getSecondsForSelectedTime() {
        var LocalTime time
        try {
            time = LocalTime.parse(epgTimeCriteria.value, DateTimeFormatter.ofPattern(messages.formatTime))
        } catch (Exception e) {
            // time value is not valid -> switch back to current time
            epgTimeCriteria.value = DateTimeUtil.toTime(messages.formatTime)
            time = LocalTime.parse(epgTimeCriteria.value, DateTimeFormatter.ofPattern(messages.formatTime))
        }

        val date = epgDateCriteria.value.atTime(time)
        return date.atZone(config.defaultZoneId).toInstant().toEpochMilli() / 1000L
    }

    private def getChannelEvents() {
        if (!epgChannelCriteria.selectedItem.isPresent) {
            epgChannelCriteria.selectedItem = null
            return Collections.emptyList
        }

        val ch = epgChannelCriteria.selectedItem.get

        svdrp.epg.stream //
            .filter(it | it.channelId == ch.id && it.startTime+it.duration >= System.currentTimeMillis / 1000L) //
            .collect(Collectors.toList)
    }

    private def getSearchResultEvents() {
        val filteredChannels = filterChannel

        if (searchRegex.value) {
            val Pattern titlePattern = createPattern(searchTitle.value)
            val Pattern shorttextPattern = createPattern(searchShortText.value)
            val Pattern descriptionPattern = createPattern(searchDescription.value)

            if (titlePattern === null && shorttextPattern === null && descriptionPattern === null) {
                Notification.show("no valid search criteria found. Ignore search request", Type.ERROR_MESSAGE)
                return Collections.<Epg>emptyList
            }

            return svdrp.epg.stream //
                .filter(it | filteredChannels.contains(it.channelId))
                .filter(it | titlePattern.regexMatcher(it.title)) //
                .filter(it | shorttextPattern.regexMatcher(it.shortText)) //
                .filter(it | descriptionPattern.regexMatcher(it.description)) //
                .limit(100)
                .collect(Collectors.toList)
        } else {
            val title = searchTitle.value
            val shorttext = searchShortText.value
            val description = searchDescription.value

            if (StringUtils.isEmpty(title) && StringUtils.isEmpty(shorttext) && StringUtils.isEmpty(description)) {
                // Notification.show("no valid search criteria found. Ignore search request", Type.ERROR_MESSAGE)
                return Collections.<Epg>emptyList
            }

            return svdrp.epg.stream //
                .filter(it | filteredChannels.contains(it.channelId))
                .filter(it | title.stringMatcher(it.title)) //
                .filter(it | shorttext.stringMatcher(it.shortText)) //
                .filter(it | description.stringMatcher(it.description)) //
                .limit(100)
                .collect(Collectors.toList)
        }
    }

    private def getRegexEvents() {
        if (regexPattern.selectedItem.isPresent) {
            val patternName = regexPattern.selectedItem.get
            val filteredChannels = filterChannel
            return epgSearch.filterCompletePattern(patternName, svdrp.epg.stream.filter(it | filteredChannels.contains(it.channelId)).collect(Collectors.toList))
        } else {
            return getTimeEvents()
        }
    }

    private def prepareGrid() {
        var idx = -1
        var oldComponent = eventGrid?.grid

        if ((eventGrid !== null) && (eventGrid.grid !== null)) {
           idx = eventGrid.grid.componentIndex
        }

        val now = System.currentTimeMillis / 1000L
        switch (epgType) {
            case TIME: {
                eventGrid.setVdr(selectedVdr).setEpgType(epgType).setEvents(getTimeEvents()).createGrid(now)
                listTime
            }

            case CHANNEL: {
                eventGrid.setVdr(selectedVdr).setEpgType(epgType).setEvents(getChannelEvents()).createGrid(now)
            }

            case SEARCH: {
                eventGrid.setVdr(selectedVdr).setEpgType(epgType).setEvents(getSearchResultEvents()).createGrid(now)
            }
        }

        if (idx != -1) {
            eventGrid.grid.setSizeFull
            replaceComponent(oldComponent, eventGrid.grid)
        }
    }

    override protected def void changeVdr(VDR vdr) {
       if (eventGrid !== null) {
           eventGrid.vdr = vdr
       }
    }

    private def Pattern createPattern(String searchText) {
        try {
            if (StringUtils.isNotEmpty(searchText)) {
                return Pattern.compile("(?m)" + searchText)
            }
        } catch (Exception e) {
            Notification.show(messages.searchPatternInvalid(searchText), Type.ERROR_MESSAGE)
            return null;
        }
    }

    private def regexMatcher(Pattern pattern, String text) {
        if (pattern !== null) {
            if (StringUtils.isNotEmpty(text)) {
                return pattern.matcher(text.replaceAll("\\|", "\n")).find
            } else {
                return false
            }
        } else {
            return true
        }
    }

    private def stringMatcher(String pattern, String text) {
        if (pattern !== null) {
            if (StringUtils.isNotEmpty(text)) {
                return text.contains(pattern)
            } else {
                return false
            }
        } else {
            return true
        }
    }
}


