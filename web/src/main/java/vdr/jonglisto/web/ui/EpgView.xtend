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
import java.util.Collections
import java.util.Comparator
import java.util.List
import java.util.regex.Pattern
import java.util.stream.Collectors
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.apache.commons.lang3.StringUtils
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.EventGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.EPG_VIEW)
class EpgView extends BaseView {

    public enum EPGTYPE {
        TIME, CHANNEL, SEARCH
    }

    @Inject
    private EventGrid eventGrid

    // var EventGrid eventGrid

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

    @PostConstruct
    def void init() {
        super.init(BUTTON.EPG)
    }

    protected override createMainComponents() {
        timeSelectValues = Configuration.get.epgTimeSelect

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

                            epgType = EPGTYPE.CHANNEL
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

                            epgType = EPGTYPE.SEARCH
                        }
                    }

                    prepareGrid
                })
            ]

            epgNowButton = button(messages.epgFilterNow) [
                styleName = "epg-now"

                addClickListener [
                    listNow
                ]
            ]

            cssLayout(it) [
                styleName = "epg-time"

                epgDateSelect = epgDateCriteria = dateField [
                    value = LocalDate.now()
                    addValueChangeListener(it | listTime)
                ]

                epgTimeCriteria = comboBox(timeSelectValues) [
                    value = DateTimeUtil.toTime(messages.formatTime)
                    addValueChangeListener(it | listTime)
                    setNewItemHandler(it | timeSelectValues.add(it))
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
        epgChannelCriteria.selectedItem = svdrp.getChannel(epg.channelId)
        epgTypeSelect.selectedItem = messages.epgTypeChannel
    }

    private def listNow() {
        epgDateCriteria.value = LocalDate.now
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

    private def listSearchResult() {
        eventGrid.items = searchResultEvents
    }

    private def getTimeEvents() {
        val millis = secondsForSelectedTime

        val result = svdrp.epg.stream //
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
        val time = LocalTime.parse(epgTimeCriteria.value, DateTimeFormatter.ofPattern(messages.formatTime))
        val date = epgDateCriteria.value.atTime(time)
        return date.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli() / 1000L
    }

    private def getChannelEvents() {
        val ch = epgChannelCriteria.selectedItem.get as Channel

        svdrp.epg.stream //
            .filter(it | it.channelId == ch.id && it.startTime+it.duration >= System.currentTimeMillis / 1000L) //
            .collect(Collectors.toList)
    }

    private def getSearchResultEvents() {
        if (searchRegex.value) {
            val Pattern titlePattern = createPattern(searchTitle.value)
            val Pattern shorttextPattern = createPattern(searchShortText.value)
            val Pattern descriptionPattern = createPattern(searchDescription.value)

            if (titlePattern === null && shorttextPattern === null && descriptionPattern === null) {
                Notification.show("no valid search criteria found. Ignore search request", Type.ERROR_MESSAGE)
                return Collections.<Epg>emptyList
            }

            return svdrp.epg.stream //
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
                .filter(it | title.stringMatcher(it.title)) //
                .filter(it | shorttext.stringMatcher(it.shortText)) //
                .filter(it | description.stringMatcher(it.description)) //
                .limit(100)
                .collect(Collectors.toList)
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


