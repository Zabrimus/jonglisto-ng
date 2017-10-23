package vdr.jonglisto.web.ui.component

import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Button
import com.vaadin.ui.ComponentContainer
import com.vaadin.ui.TextArea
import com.vaadin.ui.Window
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class EpgDetailsWindow extends Window {

    val Messages messages
    var TextArea epgArea
    var VDR currentVdr

    new(VDR vdr, Messages messages, Epg epg, boolean editView) {
        super()
        this.messages = messages
        this.currentVdr = vdr

        caption = createCaption(epg)

        center();

        closable = true
        modal = true
        width = "60%"

        setContent(
            verticalLayout [
                label(it, epg.shortText)

                addDescription(it, epg, editView)

                button(it, messages.epgClose) [
                    addCloseButtonClickListener
                ]

                if (editView) {
                    button(it, messages.epgSave) [
                        it.addClickListener(s | {
                            SvdrpClient.get.saveEpgData(Configuration.get.epgVdr, epg, epgArea.value)
                            close
                        })
                    ]
                }
            ]
        )
    }

    def createCaption(Epg epg) {
        return String.format("%s  [%s,  %s - %s (%s)]",
            epg.title,
            DateTimeUtil.toDate(epg.startTime, messages.formatDate),
            DateTimeUtil.toTime(epg.startTime, messages.formatTime),
            DateTimeUtil.toTime(epg.startTime + epg.duration, messages.formatTime),
            DateTimeUtil.toTime(epg.duration, messages.formatTime)
        )
    }

    def addDescription(ComponentContainer container, Epg epg, boolean editView) {
        // clean description
        val epgdesc = HtmlSanitizer.clean(epg.description)

        if (!editView) {
            // prepare html code
            val str = epgdesc.replaceAll("\\|", "\n") //
                        .replaceAll("(?m)^([a-zA-Z]\\w*?:)", "<b>$1</b>") //
                        .replaceAll("\\n", "<br/>");

            label(container, str) [
                contentMode = ContentMode.HTML
                width = "100%"
            ]

        } else {
            val str = epgdesc.replaceAll("\\|", "\n");

            epgArea = textArea(container, messages.epgEditEpg, str) [
                width = "100%"
            ]
        }
    }

    def addCloseButtonClickListener(Button b) {
        b.addClickListener(s | {
            close
        })
    }
}
