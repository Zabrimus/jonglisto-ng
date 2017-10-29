package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Alignment
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*
import com.vaadin.ui.CheckBox

@Log
class SearchTimerEpgsearchEditWindow extends Window {

    val Messages messages
    var VDR vdr

    CheckBox searchCase

    CheckBox useTime

    CheckBox useDuration

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
                ]

                textField(messages.searchtimerTolerance) [
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
                // TODO: Auswahllisten: plug epgsearch LSTB
                comboBox(#[messages.searchtimerNo, messages.searchtimerSelection, messages.searchtimerAll]) [
                    caption = messages.searchtimerUseBlacklist
                ]

                nativeSelect [
                    caption = ""
                    items = #["Keine Ahnung", "Was steht hier"]
                ]
            ]

            horizontalLayout(it) [
                comboBox(#[messages.searchtimerNo, messages.searchtimerYes, messages.searchtimerUserdefined]) [
                    caption = messages.searchtimerUseastimer
                ]

                comboBox(#[messages.searchtimerRecord, messages.searchtimerAnnounceOsd, messages.searchtimerChangeChannel, messages.searchtimerAskchannelswitch, messages.searchtimerAnnounceEmail]) [
                    caption = ""
                ]
            ]

            horizontalLayout(it) [
                textField(messages.searchtimerFirstDay) [
                ]

                textField(messages.searchtimerLastDay) [
                ]
            ]

            horizontalLayout(it) [
                comboBox(#[messages.searchtimerNo, messages.searchtimerCountRecords, messages.searchtimerCountDays]) [
                    caption = messages.searchtimerAutoDelete
                ]

                textField(messages.searchtimerAfterXRecord) [
                ]

                textField(messages.searchtimerAfterXDays) [
                ]
            ]
        ]

        val tab2 = verticalLayout[
            checkbox(messages.searchtimerExtendedEpg) [
            ]

            checkbox(messages.searchtimerIgnoreMissingCategories) [
            ]

            // TODO: Liste der Kategorien: PLUG epgsearch LSTE
        ]

        val tab3 = verticalLayout[
            comboBox(#[messages.searchtimerNo, messages.searchtimerInterval, messages.searchtimerChannelGroup, messages.searchtimerFta]) [
                caption = messages.searchtimerUseChannel
            ]

            // TODO: Kanalgruppen: PLUG epgsearch LSTC
            comboBox(#["Kanalgruppe 1 ", "Kanalgruppe 2"]) [
                caption = messages.searchtimerChannelGroup
            ]
        ]

        val tab4 = verticalLayout [
            horizontalLayout(it) [
                useTime = checkbox(messages.searchtimerUseTime) [
                ]

                textField(messages.searchtimerStartAfter) [
                ]

                textField(messages.searchtimerStartBefore) [
                ]

                setComponentAlignment(useTime, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                useDuration = checkbox(messages.searchtimerUseDuration) [
                ]

                textField(messages.searchtimerMinDuration) [
                ]

                textField(messages.searchtimerMaxDuration) [
                ]

                setComponentAlignment(useDuration, Alignment.MIDDLE_CENTER);
            ]

            horizontalLayout(it) [
                checkbox(messages.searchtimerWeekdays) [
                ]

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

            checkbox(messages.searchtimerAvoidRepeating) [
            ]

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

                label(messages.searchtimerFuzzyDescription) [
                ]

                textField("") [
                    caption = null
                ]
            ]

            // TODO: Liste der Kategorien: PLUG epgsearch LSTE

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

        val tabsheet = tabsheet[
            addTab(tab1, messages.searchtimerConfiguration)
            addTab(tab2, messages.searchtimerExtended)
            addTab(tab3, messages.searchtimerChannels)
            addTab(tab4, messages.searchtimerStartdate)
            addTab(tab5, messages.searchtimerChannelswitch)
            addTab(tab6, messages.searchtimerAskchannelswitch)
            addTab(tab7, messages.searchtimerRecording)

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);
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
}
