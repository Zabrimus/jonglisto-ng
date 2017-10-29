package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Window
import vdr.jonglisto.model.EpgsearchSearchTimer
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class SearchTimerEpgsearchEditWindow extends Window {

    val Messages messages
    var VDR vdr

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

        val layout = verticalLayout[
            textField("Suche") [
            ]

            comboBox(#["Ausdruck", "Alle Worte", "Ein Wort", "exakt", "regulärer Ausdruck", "unscharf"]) [
                caption = "Suchmodus"
            ]

            textField("Toleranz für unscharf") [
            ]

            checkbox("Groß/Klein") [
            ]

            label("Zu suchen in") [
            ]

            checkbox("Titel") [
            ]

            checkbox("Untertitel") [
            ]

            checkbox("Beschreibung") [
            ]

            checkbox("Verwende erweiterte EPG Infos") [
            ]

            checkbox("Ignoriere fehlende Kategorien") [
            ]

            // TODO: Liste der Kategorien: PLUG epgsearch LSTE

            comboBox(#["nein", "Bereich", "Kanalgruppe", "ohne PayTV"]) [
                caption = "Verwende Kanal"
            ]

            // TODO: Kanalgruppen: PLUG epgsearch LSTC
            comboBox(#["Kanalgruppe 1 ", "Kanalgruppe 2"]) [
                caption = "Kanalgruppe"
            ]

            checkbox("Verwende Uhrzeit") [
            ]

            textField("Start nach") [
            ]

            textField("Start vor") [
            ]

            checkbox("Verwende Dauer") [
            ]

            textField("Minimale Dauer") [
            ]

            textField("Maximale Dauer") [
            ]

            checkbox("Verwende Wochentag") [
            ]

            checkbox("Montag") [
            ]

            checkbox("Dienstag") [
            ]

            checkbox("Mittwoch") [
            ]

            checkbox("Donnerstag") [
            ]

            checkbox("Freitag") [
            ]

            checkbox("Samstag") [
            ]

            checkbox("Sonntag") [
            ]

            // TODO: Auswahllisten: plug epgsearch LSTB
            comboBox(#["Nein", "Auswahl", "Alle"]) [
                caption = "Verwende Ausschlusslisten"
            ]

            nativeSelect [
                items = #["Keine Ahnung", "Was steht hier"]
            ]

            comboBox(#["nein", "ja", "benutzerdefiniert"]) [
                caption = "Als Suchtimerverwenden"
            ]

            comboBox(#["Aufnehmen", "per OSD ankündigen", "nur umschalten", "ankündigen und umschalten", "per EMail ankündigen"]) [
            ]

            textField("erster Tag") [
            ]

            textField("letzter Tag") [
            ]

            comboBox(#["nein", "Anzahl Aufnahmen", "Anzahl Tage"]) [
                caption = "Automatisch löschen"
            ]

            textField("Nach ... Aufnahmen") [
            ]

            textField("Nach ... Tagen nach erster Aufnahme:") [
            ]

            // ----- Einstellungen für "nur umschalten"
            textField("Umschalten ... Minuten vor Start") [
            ]

            checkbox("Ton anschalten") [
            ]

            // ----- Einstellungen für "umschalten und ankündigen"
            textField("Nachfrage ... Minuten vor Start:") [
            ]

            checkbox("Ton anschalten") [
            ]

            // ----- Einstellungen für Aufnehmen
            checkbox("Serienaufnahme") [
            ]

            textField("Ordner") [
            ]

            textField("Aufnahme nach ... Tagen löschen") [
            ]

            textField("Behalte ... Aufnahmen: ") [
            ]

            textField("Pause, wenn ... Aufnahmen existieren:") [
            ]

            checkbox("Vermeide Wiederholungen") [
            ]

            textField("Erlaubte Wiederholungen:") [
            ]

            textField("Nur Wiederholungen innerhalb ... Tagen:") [
            ]

            label("Vergleiche") [
            ]

            checkbox("Titel") [
            ]

            checkbox("Untertitel") [
            ]

            checkbox("Beschreibung") [
            ]

            textField("Minimale Übereinstimmung der Beschreibung in %:") [
            ]

            // TODO: Liste der Kategorien: PLUG epgsearch LSTE

            textField("Priorität:") [
            ]

            textField("Lebenszeit") [
            ]

            textField("Zeitpuffer Anfang in Minuten :") [
            ]

            textField("Zeitpuffer Ende in Minuten :") [
            ]

            checkbox("VPS") [
            ]
        ]

        val mainLayout = verticalLayout[
            addComponent(layout)

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
