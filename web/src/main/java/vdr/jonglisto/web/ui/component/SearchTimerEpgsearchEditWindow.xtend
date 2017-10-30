package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Alignment
import com.vaadin.ui.CheckBox
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import java.util.Collections
import java.util.List
import java.util.stream.Collectors
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.EpgsearchSearchTimer.Field
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*
import com.vaadin.ui.TextField
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.ComboBox
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.ListSelect
import com.vaadin.ui.TabSheet.Tab

@Log
class SearchTimerEpgsearchEditWindow extends Window {

    val Messages messages
    var VDR vdr

    CheckBox searchCase

    CheckBox useTime

    CheckBox useDuration

    TextField searchTimerTolerance

    VerticalLayout extendedEpgInfos

    ComboBox<String> channelGroupCombo

    HorizontalLayout channelIntervalSelect

    HorizontalLayout timeFields

    HorizontalLayout durationFields

    HorizontalLayout daysCheckboxes

    ListSelect<String> blacklistSelect

    Tab tabObject1

    Tab tabObject2

    Tab tabObject3

    Tab tabObject4

    Tab tabObject5

    Tab tabObject6

    Tab tabObject7

    Tab tabObject8

    ComboBox<String> actionCombo

    HorizontalLayout firstLastDay

    new(VDR vdr, Messages messages, EpgsearchSearchTimer timer) {
        super()
        this.vdr = vdr
        this.messages = messages
        closable = true
        modal = true
        width = "60%"
        center();

        createLayout(timer)
    }

    def createLayout(EpgsearchSearchTimer timer) {
        caption = createCaption(timer)

        val tab1 = verticalLayout[
            horizontalLayout(it) [
                textField(messages.searchtimerSearch) [
                ]

                comboBox(#[messages.searchtimerPattern, messages.searchtimerAllWords, messages.searchtimerOneWord, messages.searchtimerExact, messages.searchtimerRegex, messages.searchtimerFuzzy]) [
                    caption = messages.searchtimerSearch
                    emptySelectionAllowed = false
                    selectedItem = messages.searchtimerPattern

                    addSelectionListener(s | {
                        if (s.selectedItem.isPresent && s.selectedItem.get == messages.searchtimerFuzzy) {
                            searchTimerTolerance.visible = true
                        } else {
                            searchTimerTolerance.visible = false
                        }
                    })
                ]

                searchTimerTolerance = textField(messages.searchtimerTolerance) [
                    visible = false
                ]

                searchCase = checkbox(messages.searchtimerCasesensitiv) [
                ]

                setComponentAlignment(searchCase, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                label(messages.searchtimerContains) [
                ]

                checkbox(messages.searchtimerTitle) [
                ]

                checkbox(messages.searchtimerShorttext) [
                ]

                checkbox(messages.searchtimerDescription) [
                ]
            ]

            horizontalLayout(it) [
                val blacklist = SvdrpClient.get.getEpgsearchSearchBlacklist(vdr)

                if (blacklist.size > 0) {
                    val names = blacklist.stream().map[s | s.getField(Field.pattern)].collect(Collectors.toList)

                    comboBox(#[messages.searchtimerNo, messages.searchtimerSelection, messages.searchtimerAll]) [
                        caption = messages.searchtimerUseBlacklist
                        emptySelectionAllowed = false
                        selectedItem = messages.searchtimerNo

                        addSelectionListener(s | {
                            if (s.selectedItem.isPresent) {
                                blacklistSelect.visible = s.selectedItem.get == messages.searchtimerSelection
                            }
                        })
                    ]

                    blacklistSelect = listSelect [
                        items = names
                        visible = false
                    ]
                }
            ]

            horizontalLayout(it) [
                typeCombo = comboBox(#[messages.searchtimerNo, messages.searchtimerYes, messages.searchtimerUserdefined]) [
                    caption = messages.searchtimerUseastimer
                    selectedItem = messages.searchtimerNo
                    emptySelectionAllowed = false

                    addSelectionListener(s | setTabsVisible(s.selectedItem.get, actionCombo.selectedItem.get))
                ]

                actionCombo = comboBox(#[messages.searchtimerRecord, messages.searchtimerAnnounceOsd, messages.searchtimerChangeChannel, messages.searchtimerAskchannelswitch, messages.searchtimerAnnounceEmail]) [
                    caption = ""
                    emptySelectionAllowed = false
                    selectedItem = messages.searchtimerRecord

                    addSelectionListener(s | setTabsVisible(typeCombo.selectedItem.get, s.selectedItem.get))
                ]
            ]

            firstLastDay = horizontalLayout(it) [
                textField(messages.searchtimerFirstDay) [
                ]

                textField(messages.searchtimerLastDay) [
                ]
            ]

            horizontalLayout(it) [
                comboBox(#[messages.searchtimerNo, messages.searchtimerCountRecords, messages.searchtimerCountDays]) [
                    caption = messages.searchtimerAutoDelete
                    emptySelectionAllowed = false
                    selectedItem = messages.searchtimerNo

                    addSelectionListener(s | {
                        deleteAfterRecordings.visible = false
                        deleteAfterDays.visible = false

                        if (s.selectedItem.get == messages.searchtimerCountRecords) {
                            deleteAfterRecordings.visible = true
                        } else if (s == messages.searchtimerCountDays) {
                            deleteAfterDays.visible = true
                        }
                    })
                ]

                deleteAfterRecordings = textField(messages.searchtimerAfterXRecord) [
                ]

                deleteAfterDays = textField(messages.searchtimerAfterXDays) [
                ]
            ]
        ]

        val tab2 = verticalLayout[
            checkbox(messages.searchtimerExtendedEpg) [
                addValueChangeListener(s | extendedEpgInfos.visible = s.value)
            ]

            extendedEpgInfos = verticalLayout(it) [
                checkbox(messages.searchtimerIgnoreMissingCategories) [
                ]

                val categories = SvdrpClient.get.getEpgsearchCategories(vdr)
                if (categories !== null && categories.size > 0) {
                    horizontalLayout(it) [
                        for (s : categories) {
                            if (s.values !== null && s.values.size > 0) {
                                comboBox(s.values) [
                                    caption = s.publicName
                                    emptySelectionAllowed = true
                                    selectedItem = null
                                ]
                            } else {
                                textField(s.publicName) [
                                ]
                            }
                        }

                        addStyleName(ValoTheme.LAYOUT_HORIZONTAL_WRAPPING);
                    ]
                }

                visible = false
            ]
        ]

        val tab3 = verticalLayout[
            val channelGroups = SvdrpClient.get.getEpgsearchChannelGroups(vdr)

            comboBox(#[messages.searchtimerNo, messages.searchtimerInterval, messages.searchtimerChannelGroup, messages.searchtimerFta]) [
                caption = messages.searchtimerUseChannel
                emptySelectionAllowed = false
                selectedItem = messages.searchtimerNo

                addSelectionListener(s | {
                    if (s.selectedItem.isPresent) {
                        switch (s.selectedItem.get) {
                            case messages.searchtimerInterval: {
                                channelIntervalSelect.visible = true
                                channelGroupCombo.visible = false
                            }

                            case messages.searchtimerChannelGroup: {
                                channelIntervalSelect.visible = false
                                channelGroupCombo.visible = true
                            }

                            default: {
                                channelIntervalSelect.visible = false
                                channelGroupCombo.visible = false
                            }
                        }
                    }
                })
            ]

            var List<String> list

            if (channelGroups !== null && channelGroups.size > 0) {
                list = channelGroups.stream.map(s | s.name).collect(Collectors.toList)
            } else {
                list = Collections.emptyList
            }

            channelGroupCombo = comboBox(list) [
                caption = messages.searchtimerChannelGroup
                selectedItem = null
                visible = false
            ]

            channelIntervalSelect = horizontalLayout(it) [
                val channelList = SvdrpClient.get.channels

                nativeChannelSelect [
                    items = channelList
                    itemCaptionGenerator = [s | s.name]
                    caption = messages.searchtimerFrom
                ]

                nativeChannelSelect [
                    items = channelList
                    itemCaptionGenerator = [s | s.name]
                    caption = messages.searchtimerTo
                ]

                visible = false
            ]
        ]

        val tab4 = verticalLayout [
            horizontalLayout(it) [
                useTime = checkbox(messages.searchtimerUseTime) [
                    addValueChangeListener(s | timeFields.visible = s.value)
                ]

                timeFields = horizontalLayout(it) [
                    textField(messages.searchtimerStartAfter) [
                    ]

                    textField(messages.searchtimerStartBefore) [
                    ]

                    visible = false
                ]

                setComponentAlignment(useTime, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                useDuration = checkbox(messages.searchtimerUseDuration) [
                    addValueChangeListener(s | durationFields.visible = s.value)
                ]

                durationFields = horizontalLayout(it) [
                    textField(messages.searchtimerMinDuration) [
                    ]

                    textField(messages.searchtimerMaxDuration) [
                    ]

                    visible = false
                ]

                setComponentAlignment(useDuration, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                checkbox(messages.searchtimerWeekdays) [
                    addValueChangeListener(s | daysCheckboxes.visible = s.value)
                ]

                daysCheckboxes = horizontalLayout(it) [
                    checkbox(messages.searchtimerStartMonday) [
                    ]

                    checkbox(messages.searchtimerStartTuesday) [
                    ]

                    checkbox(messages.searchtimerStartWednesday) [
                    ]

                    checkbox(messages.searchtimerStartThursday) [
                    ]

                    checkbox(messages.searchtimerStartFriday) [
                    ]

                    checkbox(messages.searchtimerStartSaturday) [
                    ]

                    checkbox(messages.searchtimerStartSunday) [
                    ]

                    visible = false
                ]
            ]
        ]

        val tab5 = verticalLayout [
            // ----- Einstellungen für "nur umschalten"
            textField(messages.searchtimerSwitchMinutes) [
            ]

            checkbox(messages.searchtimerUnmute) [
            ]
        ]

        val tab6 = verticalLayout [
            // ----- Einstellungen für "umschalten und ankündigen"
            textField(messages.searchtimerAskSwitchMinutes) [
            ]

            checkbox(messages.searchtimerUnmute) [
            ]
        ]

        val tab7 = verticalLayout [
            // ----- Einstellungen für Aufnehmen
            checkbox(messages.searchtimerRecordSeries) [
            ]

            textField(messages.searchtimerDirectory) [
            ]

            horizontalLayout(it) [
                textField(messages.searchtimerDeleteRecordDays) [
                ]

                textField(messages.searchtimerKeepRecord) [
                ]

                textField(messages.searchtimerPause) [
                ]
            ]

            horizontalLayout(it) [
                textField(messages.searchtimerPriority) [
                ]

                textField(messages.searchtimerLifetime) [
                ]
            ]

            horizontalLayout(it) [
                textField(messages.searchtimerMarginStart) [
                ]

                textField(messages.searchtimerMarginEnd) [
                ]
            ]

            checkbox("VPS") [
            ]
        ]

        val tab8 = verticalLayout [
            checkbox(messages.searchtimerAvoidRepeating) [
                addValueChangeListener(s | repeatConfiguration.visible = s.value)
            ]

            repeatConfiguration = verticalLayout(it) [
                horizontalLayout(it) [
                    textField(messages.searchtimerAllowRepeating) [
                    ]

                    textField(messages.searchtimerAllowRepeatingDays) [
                    ]
                ]

                horizontalLayout(it) [
                    label(messages.searchtimerCompare) [
                    ]

                    checkbox(messages.searchtimerTitle) [
                    ]

                    checkbox(messages.searchtimerShorttext) [
                    ]

                    checkbox(messages.searchtimerDescription) [
                    ]
                ]

                horizontalLayout(it) [
                    label(messages.searchtimerFuzzyDescription) [
                    ]

                    textField("") [
                        caption = null
                    ]
                ]

                horizontalLayout(it) [
                    val categories = SvdrpClient.get.getEpgsearchCategories(vdr)
                    if (categories !== null && categories.size > 0) {
                        for (s : categories) {
                            checkbox(s.publicName) [
                            ]
                        }
                    }

                    addStyleName(ValoTheme.LAYOUT_HORIZONTAL_WRAPPING);
                ]

                visible = false
            ]
        ]

        val tabsheet = tabsheet[
            tabObject1 = addTab(tab1, messages.searchtimerConfiguration)
            tabObject2 = addTab(tab2, messages.searchtimerExtended)
            tabObject3 = addTab(tab3, messages.searchtimerChannels)
            tabObject4 = addTab(tab4, messages.searchtimerStartdate)
            tabObject5 = addTab(tab5, messages.searchtimerChannelswitch)
            tabObject6 = addTab(tab6, messages.searchtimerAskchannelswitch)
            tabObject7 = addTab(tab7, messages.searchtimerRecording)
            tabObject8 = addTab(tab8, messages.searchtimerRepeat)

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);

            tabObject5.visible = false
            tabObject6.visible = false
            tabObject7.visible = false
            tabObject8.visible = false
        ]

        val mainLayout = verticalLayout[
            addComponent(tabsheet)

            cssLayout(it) [
                width = "100%"
                button(it, messages.searchtimerSave) [
                    it.addClickListener(s | {
                        if (saveTimer(timer)) {
                            close
                        }
                    })
                ]

                button(it, messages.searchtimerCancel) [
                    it.addClickListener(s | {
                        close
                    })
                ]
            ]
        ]

        setContent(mainLayout)

        fillTimerValues(timer)
    }

    ComboBox<String> typeCombo

    VerticalLayout repeatConfiguration

    TextField deleteAfterRecordings

    TextField deleteAfterDays

    private def createCaption(EpgsearchSearchTimer timer) {
        return  messages.searchtimerEdit
    }

    private def fillTimerValues(EpgsearchSearchTimer timer) {
    }

    private def getBitFlag(int idx, Integer field) {
        if (field === null) {
            return false
        }

        return field.bitwiseAnd(idx) > 0
    }

    private def setBitFlag(boolean value, int idx, Integer field) {
        var f = field

        if (f === null) {
            f = 0
        }

        if (value) {
            return f.bitwiseOr(idx)
        } else {
            return f.bitwiseAnd(idx.bitwiseNot)
        }
    }

    private def saveTimer(EpgsearchSearchTimer timer) {
        return true
    }

    private def setTabsVisible(String searchTimerType, String searchTimerMode) {
        tabObject5.visible = false
        tabObject6.visible = false
        tabObject7.visible = false
        tabObject8.visible = false

        if (searchTimerType == messages.searchtimerYes || searchTimerType == messages.searchtimerUserdefined) {
            if (searchTimerMode == messages.searchtimerRecord) {
                tabObject7.visible = true
                tabObject8.visible = true
            } else if (searchTimerMode == messages.searchtimerChangeChannel) {
                tabObject5.visible = true
            } else if (searchTimerMode == messages.searchtimerAskchannelswitch) {
                tabObject6.visible = true
            }

            if (searchTimerType == messages.searchtimerUserdefined) {
                firstLastDay.visible = true
            } else {
                firstLastDay.visible = false
            }
        }

    }
}
