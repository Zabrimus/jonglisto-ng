package vdr.jonglisto.web.ui.component

import com.vaadin.data.Binder
import com.vaadin.data.ValueProvider
import com.vaadin.data.validator.LongRangeValidator
import com.vaadin.data.validator.StringLengthValidator
import com.vaadin.server.Setter
import com.vaadin.ui.AbstractComponent
import com.vaadin.ui.Alignment
import com.vaadin.ui.CheckBox
import com.vaadin.ui.ComboBox
import com.vaadin.ui.DateField
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.ListSelect
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.Notification
import com.vaadin.ui.TabSheet.Tab
import com.vaadin.ui.TextField
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import java.util.ArrayList
import java.util.Collections
import java.util.List
import java.util.Set
import java.util.stream.Collectors
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.EpgsearchSearchTimer.Field
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension org.apache.commons.lang3.StringUtils.*
import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class SearchTimerEpgsearchEditWindow extends Window {
    val Messages messages
    var VDR vdr

    val binder = new Binder<EpgsearchSearchTimer>
    val EpgsearchSearchTimer currentTimer

    var CheckBox matchCase
    var CheckBox useTime
    var CheckBox useDuration
    var TextField fuzzyTolerance
    var VerticalLayout extendedEpgInfos
    var ComboBox<String> channelGroupCombo
    var HorizontalLayout channelIntervalSelect
    var HorizontalLayout timeFields
    var HorizontalLayout durationFields
    var HorizontalLayout daysCheckboxes
    var ListSelect<String> blacklistSelect
    var Tab tabObject1
    var Tab tabObject2
    var Tab tabObject3
    var Tab tabObject4
    var Tab tabObject5
    var Tab tabObject6
    var Tab tabObject7
    var Tab tabObject8
    var ComboBox<String> actionCombo
    var List<String> actionComboItems
    var HorizontalLayout firstLastDay
    var ComboBox<String> typeCombo
    var List<String> typeComboItems
    var VerticalLayout repeatConfiguration
    var TextField deleteAfterRecordings
    var TextField deleteAfterDays
    var TextField pattern
    var ComboBox<String> searchMode
    var List<String> searchModeItems
    var CheckBox searchInTitle
    var CheckBox searchInShortText
    var CheckBox searchInDescription
    var ComboBox<String> blacklistMode
    var List<String> blacklistItems
    var DateField firstDay
    var DateField lastDay
    var ComboBox<String> deleteSearchTimer
    var List<String> deleteSearchTimerItems
    var CheckBox useExtendedEpg
    var ComboBox<String> channelGroupSelect
    var List<String> channelGroupSelectItems
    var NativeSelect<Channel> channelFrom
    var NativeSelect<Channel> channelTo
    var TextField startAfter
    var TextField startBefore
    var TextField durationMin
    var TextField durationMax
    var CheckBox useWeekdays
    var CheckBox monday
    var CheckBox tuesday
    var CheckBox wednesday
    var CheckBox thursday
    var CheckBox friday
    var CheckBox saturday
    var CheckBox sunday
    var TextField switchMinutes
    var CheckBox unmute
    var TextField askSwitchMinutes
    var CheckBox recordSeries
    var TextField recordDirectory
    var TextField recordDeleteDays
    var TextField recordKeepCount
    var TextField recordPauseCount
    var TextField recordPriority
    var TextField recordLifetime
    var TextField marginStart
    var TextField marginEnd
    var CheckBox vps
    var CheckBox avoidRepeating
    var TextField allowRepeatingCount
    var TextField allowRepeatingDays
    var CheckBox repeatingTitle
    var CheckBox repeatingShortText
    var CheckBox repeatingDescription
    var TextField repeatingFuzzyDescription
    var CheckBox ignoreMissingEpg

    var extendedEpg = new ArrayList<AbstractComponent>

    new(VDR vdr, Messages messages, EpgsearchSearchTimer timer) {
        super()
        this.vdr = vdr
        this.messages = messages
        closable = true
        modal = true
        width = "60%"
        center();

        currentTimer = timer
        fillDefaultLists

        createLayout(timer)
        createBinder()
        fillTimerValues()
    }

    def createLayout(EpgsearchSearchTimer timer) {
        caption = createCaption(timer)

        val tab1 = verticalLayout[
            horizontalLayout(it) [
                pattern = textField(messages.searchtimerSearch) [
                ]

                searchMode = comboBox(searchModeItems) [
                    caption = messages.searchtimerSearch
                    emptySelectionAllowed = false
                    selectedItem = messages.searchtimerPattern

                    addSelectionListener(s | {
                        if (s.selectedItem.isPresent && s.selectedItem.get == messages.searchtimerFuzzy) {
                            fuzzyTolerance.visible = true
                        } else {
                            fuzzyTolerance.visible = false
                        }
                    })
                ]

                fuzzyTolerance = textField(messages.searchtimerTolerance) [
                    visible = false
                ]

                matchCase = checkbox(messages.searchtimerCasesensitiv) [
                ]

                setComponentAlignment(matchCase, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                label(messages.searchtimerContains) [
                ]

                searchInTitle = checkbox(messages.searchtimerTitle) [
                ]

                searchInShortText = checkbox(messages.searchtimerShorttext) [
                ]

                searchInDescription = checkbox(messages.searchtimerDescription) [
                ]
            ]

            horizontalLayout(it) [
                val blacklist = SvdrpClient.get.getEpgsearchSearchBlacklist(vdr)

                if (blacklist.size > 0) {
                    val names = blacklist.stream().map[s | s.getField(Field.pattern)].collect(Collectors.toList)

                    blacklistMode = comboBox(blacklistItems) [
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
                typeCombo = comboBox(typeComboItems) [
                    caption = messages.searchtimerUseastimer
                    selectedItem = messages.searchtimerNo
                    emptySelectionAllowed = false

                    addSelectionListener(s | setTabsVisible(s.selectedItem.get, actionCombo.selectedItem.get))
                ]

                actionCombo = comboBox(actionComboItems) [
                    caption = ""
                    emptySelectionAllowed = false
                    selectedItem = messages.searchtimerRecord

                    addSelectionListener(s | setTabsVisible(typeCombo.selectedItem.get, s.selectedItem.get))
                ]
            ]

            firstLastDay = horizontalLayout(it) [
                firstDay = dateField(messages.searchtimerFirstDay) [
                ]

                lastDay = dateField(messages.searchtimerLastDay) [
                ]
            ]

            horizontalLayout(it) [
                deleteSearchTimer = comboBox(deleteSearchTimerItems) [
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
            useExtendedEpg = checkbox(messages.searchtimerExtendedEpg) [
                addValueChangeListener(s | extendedEpgInfos.visible = s.value)
            ]

            extendedEpgInfos = verticalLayout(it) [
                ignoreMissingEpg = checkbox(messages.searchtimerIgnoreMissingCategories) [
                ]

                val categories = SvdrpClient.get.getEpgsearchCategories(vdr)
                if (categories !== null && categories.size > 0) {
                    horizontalLayout(it) [
                        for (s : categories) {
                            var AbstractComponent c
                            if (s.values !== null && s.values.size > 0) {
                                c = listSelect [
                                    items = s.values
                                    caption = s.publicName
                                    data = s.publicName
                                    rows = 4
                                ]
                            } else {
                                c = textField(s.publicName) [
                                    data = s.publicName
                                ]
                            }

                            extendedEpg.add(c)
                        }

                        addStyleName(ValoTheme.LAYOUT_HORIZONTAL_WRAPPING);
                    ]
                }

                visible = false
            ]
        ]

        val tab3 = verticalLayout[
            val channelGroups = SvdrpClient.get.getEpgsearchChannelGroups(vdr)

            channelGroupSelect = comboBox(channelGroupSelectItems) [
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

                channelFrom = nativeChannelSelect [
                    items = channelList
                    itemCaptionGenerator = [s | s.name]
                    caption = messages.searchtimerFrom
                ]

                channelTo = nativeChannelSelect [
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
                    startAfter = textField(messages.searchtimerStartAfter) [
                    ]

                    startBefore = textField(messages.searchtimerStartBefore) [
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
                    durationMin = textField(messages.searchtimerMinDuration) [
                    ]

                    durationMax = textField(messages.searchtimerMaxDuration) [
                    ]

                    visible = false
                ]

                setComponentAlignment(useDuration, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                useWeekdays = checkbox(messages.searchtimerWeekdays) [
                    addValueChangeListener(s | daysCheckboxes.visible = s.value)
                ]

                daysCheckboxes = horizontalLayout(it) [
                    monday = checkbox(messages.searchtimerStartMonday) [
                    ]

                    tuesday = checkbox(messages.searchtimerStartTuesday) [
                    ]

                    wednesday = checkbox(messages.searchtimerStartWednesday) [
                    ]

                    thursday = checkbox(messages.searchtimerStartThursday) [
                    ]

                    friday = checkbox(messages.searchtimerStartFriday) [
                    ]

                    saturday = checkbox(messages.searchtimerStartSaturday) [
                    ]

                    sunday = checkbox(messages.searchtimerStartSunday) [
                    ]

                    visible = false
                ]
            ]
        ]

        val tab5 = verticalLayout [
            // ----- Einstellungen für "nur umschalten"
            switchMinutes = textField(messages.searchtimerSwitchMinutes) [
            ]

            unmute = checkbox(messages.searchtimerUnmute) [
            ]
        ]

        val tab6 = verticalLayout [
            // ----- Einstellungen für "umschalten und ankündigen"
            askSwitchMinutes = textField(messages.searchtimerAskSwitchMinutes) [
            ]

            unmute = checkbox(messages.searchtimerUnmute) [
            ]
        ]

        val tab7 = verticalLayout [
            // ----- Einstellungen für Aufnehmen
            recordSeries = checkbox(messages.searchtimerRecordSeries) [
            ]

            recordDirectory = textField(messages.searchtimerDirectory) [
            ]

            horizontalLayout(it) [
                recordDeleteDays = textField(messages.searchtimerDeleteRecordDays) [
                ]

                recordKeepCount = textField(messages.searchtimerKeepRecord) [
                ]

                recordPauseCount = textField(messages.searchtimerPause) [
                ]
            ]

            horizontalLayout(it) [
                recordPriority = textField(messages.searchtimerPriority) [
                ]

                recordLifetime = textField(messages.searchtimerLifetime) [
                ]
            ]

            horizontalLayout(it) [
                marginStart = textField(messages.searchtimerMarginStart) [
                ]

                marginEnd = textField(messages.searchtimerMarginEnd) [
                ]
            ]

            vps = checkbox("VPS") [
            ]
        ]

        val tab8 = verticalLayout [
            avoidRepeating = checkbox(messages.searchtimerAvoidRepeating) [
                addValueChangeListener(s | repeatConfiguration.visible = s.value)
            ]

            repeatConfiguration = verticalLayout(it) [
                horizontalLayout(it) [
                    allowRepeatingCount = textField(messages.searchtimerAllowRepeating) [
                    ]

                    allowRepeatingDays = textField(messages.searchtimerAllowRepeatingDays) [
                    ]
                ]

                horizontalLayout(it) [
                    label(messages.searchtimerCompare) [
                    ]

                    repeatingTitle = checkbox(messages.searchtimerTitle) [
                    ]

                    repeatingShortText = checkbox(messages.searchtimerShorttext) [
                    ]

                    repeatingDescription = checkbox(messages.searchtimerDescription) [
                    ]
                ]

                horizontalLayout(it) [
                    label(messages.searchtimerFuzzyDescription) [
                    ]

                    repeatingFuzzyDescription = textField("") [
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
                        if (saveTimer()) {
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
    }

    private def createBinder() {
        pattern.bindMandTextField(Field.pattern)
        searchMode.bindListBox(searchModeItems, Field.mode)
        fuzzyTolerance.bindIntTextField(null, 100L, Field.fuzzy_tolerance, "Value must be between 1 and 100")
        matchCase.bindCheckBox(Field.matchcase)
        searchInTitle.bindCheckBox(Field.use_title)
        searchInShortText.bindCheckBox(Field.use_subtitle)
        searchInDescription.bindCheckBox(Field.use_descr)
        blacklistMode.bindListBox(blacklistItems, Field.use_blacklists)
        // TODO: binder for blacklistSelect
        typeCombo.bindListBox(typeComboItems, Field.has_action)
        actionCombo.bindListBox(actionComboItems, Field.action)
        firstDay.bindDateField(Field.searchtimer_from)
        lastDay.bindDateField(Field.searchtimer_until)
        deleteSearchTimer.bindListBox(deleteSearchTimerItems, Field.autodelete)
        deleteAfterRecordings.bindIntTextField(null, null, Field.del_after_recs, "Must be an positive Integer")
        deleteAfterDays.bindIntTextField(null, null, Field.del_after_days, "Must be an positive Integer")
        useExtendedEpg.bindCheckBox(Field.use_extepg)
        ignoreMissingEpg.bindCheckBox(Field.ignore_missing_epgcats)

        for (var i = 0; i < extendedEpg.size(); i++) {
            extendedEpg.get(i).bindExtendedEpg(String.valueOf(i+1))
        }

        channelGroupSelect.bindListBox(channelGroupSelectItems, Field.use_channel)
        useTime.bindCheckBox(Field.use_time)
        startAfter.bindTextField(Field.time_start)
        startBefore.bindTextField(Field.time_stop)
        useDuration.bindCheckBox(Field.use_duration)
        durationMin.bindTextField(Field.min_duration)
        durationMax.bindTextField(Field.max_duration)
        useWeekdays.bindCheckBox(Field.use_days)
        sunday.bindWeekdayCheckBox(Field.which_days, 0, 1)
        monday.bindWeekdayCheckBox(Field.which_days, 1, 2)
        tuesday.bindWeekdayCheckBox(Field.which_days, 2, 4)
        wednesday.bindWeekdayCheckBox(Field.which_days, 3, 8)
        thursday.bindWeekdayCheckBox(Field.which_days, 4, 16)
        friday.bindWeekdayCheckBox(Field.which_days, 5, 32)
        saturday.bindWeekdayCheckBox(Field.which_days, 6, 64)
        switchMinutes.bindTextField(Field.switch_before)
        askSwitchMinutes.bindTextField(Field.switch_before)
        unmute.bindCheckBox(Field.unmute)
        recordSeries.bindCheckBox(Field.is_series)
        recordDirectory.bindTextField(Field.directory)
        recordDeleteDays.bindIntTextField(null, null, Field.del_after_recs, "Must be a numeric value")
        recordKeepCount.bindIntTextField(null, null, Field.keep_recordings, "Must be a numeric value")
        recordPauseCount.bindIntTextField(null, null, Field.pause, "Must be a numeric value")
        recordPriority.bindIntTextField(0L, 99L, Field.prio, "Value must be between 0 and 99")
        recordLifetime.bindIntTextField(0L, 99L, Field.lft, "Value must be between 0 and 99")
        marginStart.bindIntTextField(null, null, Field.bstart, "Must be a numeric value")
        marginEnd.bindIntTextField(null, null, Field.bstop, "Must be a numeric value")
        vps.bindCheckBox(Field.use_vps)
        avoidRepeating.bindCheckBox(Field.avoid_repeats)
        allowRepeatingCount.bindIntTextField(null, null, Field.allowed_repeats, "Must be a numeric value")
        allowRepeatingDays.bindIntTextField(null, null, Field.repeats_in_days, "Must be a numeric value")
        repeatingTitle.bindCheckBox(Field.comp_title)
        repeatingShortText.bindCheckBox(Field.comp_subtitle)
        repeatingDescription.bindCheckBox(Field.comp_descr)
        repeatingFuzzyDescription.bindIntTextField(null, 100L, Field.min_match, "Must be a numeric value")

        // TODO: bind für repeating categories
    }

    private def bindMandTextField(TextField text, Field field) {
        if (text === null) {
            // do nothing
            return
        }

        binder.forField(text)
                .withConverter( [s|s.trim], [s | s.trim] )
                .withValidator( new StringLengthValidator("Pattern length must be greater than 0", 1, null) )
                .bind([s | s.getField(field)], [ s1, s2 | s1.setField(field, s2)] )
    }

    private def bindTextField(TextField text, Field field) {
        if (text === null) {
            // do nothing
            return
        }

        binder.forField(text)
                .withConverter( [s|s.trim], [s | s.trim] )
                .bind([s | s.getField(field)], [ s1, s2 | s1.setField(field, s2)] )
    }

    private def void bindIntTextField(TextField textField, Long from, Long to, Field field, String errorMessage) {
        if (textField === null) {
            // do nothing
            return
        }

        var b = binder.forField(textField)
               .withConverter( [s | Long.parseLong(s)], [s | String.valueOf(s)])

        if (from !== null || to !== null) {
            b = b.withValidator( new LongRangeValidator(errorMessage, from, to))
        }

        b.bind( [s | s.getLongField(field)], [s1,s2 | s1.setLongField(field, s2)] )
    }

    private def bindDateField(DateField dateField, Field field) {
        if (dateField === null) {
            // do nothing
            return
        }

        binder.forField(dateField)
            .bind([s | s.getDateField(field)], [ s1, s2 | s1.setDateField(field, s2)] )
    }

    private def void bindCheckBox(CheckBox box, Field field) {
        if (box === null) {
            // do nothing
            return
        }

        binder.forField(box)
               .bind( [s | s.getBooleanField(field)], [s1,s2 | s1.setBooleanField(field, s2)] )
    }

    private def void bindExtendedEpg(AbstractComponent component, String idx) {
        if (component instanceof TextField) {
            binder.forField(component)
                .bind( [s | if (s.getSearchCategories(idx) !== null && s.searchCategories.size > 0) {
                                s.getSearchCategories(idx).stream.collect(Collectors.joining(","))
                            } else {
                                ""
                            }
                        ],
                        [s1,s2 | s1.setSearchCategories(idx, s2)])
        } else if (component instanceof ListSelect<?>) {
            binder.forField(component)
                .bind(new ValueProvider<EpgsearchSearchTimer, Set<?>>() {
                        override def Set<String> apply(EpgsearchSearchTimer t) {
                            return t.getSearchCategories(idx)
                        }
                      },
                      new Setter<EpgsearchSearchTimer, Set<?>>() {
                        override def void accept(EpgsearchSearchTimer t, Set<?> values) {
                          t.setSearchCategories(idx, values)
                        }
                      })
        }
    }

    private def void bindWeekdayCheckBox(CheckBox box, Field field, int posNr, int negNr) {
        if (box === null) {
            // do nothing
            return
        }

        binder.forField(box)
               .bind([s | val w = s.getLongField(Field.which_days)
                          if (w >= 0) {
                            w == posNr
                          } else {
                            getBitFlag(negNr, -w)
                          }],
                    [s1,s2 | var w = s1.getLongField(Field.which_days)
                        var long wneu
                        if (w >= 0) {
                            switch (w) {
                                case 0: wneu = setBitFlag(true, 1L, 0L)
                                case 1: wneu = setBitFlag(true, 2L, 0L)
                                case 2: wneu = setBitFlag(true, 4L, 0L)
                                case 3: wneu = setBitFlag(true, 8L, 0L)
                                case 4: wneu = setBitFlag(true, 16L, 0L)
                                case 5: wneu = setBitFlag(true, 32L, 0L)
                                case 6: wneu = setBitFlag(true, 64L, 0L)
                            }
                        } else {
                            wneu = -w
                        }

                        wneu = setBitFlag(box.value, negNr, wneu)
                        s1.setField(Field.which_days, String.valueOf(-wneu))
                    ]
               )
    }

    private def void bindListBox(ComboBox<String> box, List<String> items, Field field) {
        if (box === null) {
            // do nothing
            return
        }

        binder.forField(box)
               .withConverter( [s | Long.valueOf(items.indexOf(s))], [s | items.get(s.intValue)])
               .bind( [s | s.getLongField(field)], [s1,s2 | s1.setLongField(field, s2)])
    }

    private def doManualBindingRead() {
        //  6 - use channel? 0 = no,  1 = Interval, 2 = Channel group, 3 = FTA only
        //  7 - if 'use channel' = 1 then channel id[|channel id] in vdr format,
        //      one entry or min/max entry separated with |, if 'use channel' = 2
        //      then the channel group name
        // --> channelGroupCombo, channelFrom, channelTo
        val channels = currentTimer.getField(Field.channels)
        val idx = channelGroupSelectItems.indexOf(channelGroupSelect.selectedItem.get)

        if (idx == 1) {
            val splitted = channels.split("\\|")
            if (splitted.length == 1) {
                channelFrom.selectedItem = SvdrpClient.get.getChannel(splitted.get(0))
                channelTo.selectedItem = SvdrpClient.get.getChannel(splitted.get(0))
            } else if (splitted.length == 2 && splitted.get(0).isNotEmpty) {
                channelFrom.selectedItem = SvdrpClient.get.getChannel(splitted.get(0))
                channelTo.selectedItem = SvdrpClient.get.getChannel(splitted.get(1))
            } else if (splitted.length == 2 && !splitted.get(0).isNotEmpty) {
                channelTo.selectedItem = SvdrpClient.get.getChannel(splitted.get(1))
            }
        } else if (idx == 2) {
            channelGroupCombo.selectedItem = channels
        }
    }

    private def doManualBindingWrite() {
        //  6 - use channel? 0 = no,  1 = Interval, 2 = Channel group, 3 = FTA only
        //  7 - if 'use channel' = 1 then channel id[|channel id] in vdr format,
        //      one entry or min/max entry separated with |, if 'use channel' = 2
        //      then the channel group name
        // --> channelGroupCombo, channelFrom, channelTo
        val idx = channelGroupSelectItems.indexOf(channelGroupSelect.selectedItem.get)

        var result = ""

        if (idx == 1) {
            if (channelFrom.selectedItem.isPresent) {
                result = channelFrom.selectedItem.get.id
            }

            if (channelTo.selectedItem.isPresent && result != channelTo.selectedItem.get.id) {
                result = "|" + channelTo.selectedItem.get.id
            }
        } else if (idx == 2) {
            if (channelGroupCombo.selectedItem.isPresent) {
                result = channelGroupCombo.selectedItem.get
            }
        }

        currentTimer.setField(Field.channels, result)

        return true
    }

    private def createCaption(EpgsearchSearchTimer timer) {
        return  messages.searchtimerEdit
    }

    private def fillTimerValues() {
        println("Timer: " + currentTimer)
        binder.readBean(currentTimer)
        doManualBindingRead
    }

    private def getBitFlag(long idx, Long field) {
        if (field === null) {
            return false
        }

        return field.bitwiseAnd(idx) > 0
    }

    private def setBitFlag(boolean value, long idx, Long field) {
        var f = field

        if (f === null) {
            f = 0L
        }

        if (value) {
            return f.bitwiseOr(idx)
        } else {
            return f.bitwiseAnd(idx.bitwiseNot)
        }
    }

    private def saveTimer() {
        var isValid = binder.writeBeanIfValid(currentTimer);
        isValid = isValid && doManualBindingWrite

        if (isValid) {
            println("Yaa.. Valid")
            return true
        } else {
            val  status = binder.validate();
            Notification.show(status.getValidationErrors().stream()
                    .map(s | s.errorMessage)
                    .collect(Collectors.joining("; ")))
            return false
        }
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

    private def fillDefaultLists() {
        searchModeItems = #[messages.searchtimerPattern, messages.searchtimerAllWords, messages.searchtimerOneWord, messages.searchtimerExact, messages.searchtimerRegex, messages.searchtimerFuzzy]
        blacklistItems = #[messages.searchtimerNo, messages.searchtimerSelection, messages.searchtimerAll]
        typeComboItems = #[messages.searchtimerNo, messages.searchtimerYes, messages.searchtimerUserdefined]
        actionComboItems = #[messages.searchtimerRecord, messages.searchtimerAnnounceOsd, messages.searchtimerChangeChannel, messages.searchtimerAskchannelswitch, messages.searchtimerAnnounceEmail]
        deleteSearchTimerItems = #[messages.searchtimerNo, messages.searchtimerCountRecords, messages.searchtimerCountDays]
        channelGroupSelectItems = #[messages.searchtimerNo, messages.searchtimerInterval, messages.searchtimerChannelGroup, messages.searchtimerFta]
    }
}
