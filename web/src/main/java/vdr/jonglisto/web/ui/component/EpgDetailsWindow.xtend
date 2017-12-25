package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.icons.VaadinIcons
import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Alignment
import com.vaadin.ui.Button
import com.vaadin.ui.ComponentContainer
import com.vaadin.ui.Label
import com.vaadin.ui.TextArea
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import javax.inject.Inject
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.util.DateTimeUtil
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.web.util.HtmlSanitizer
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@ViewScoped
class EpgDetailsWindow extends Window {

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    @Inject
    private ChannelLogo channelLogo

    var TextArea epgArea
    var VDR currentVdr
    var EventGrid parentGrid

    new() {
        super()
    }

    def showWindow(EventGrid parent, VDR vdr, Epg epg, boolean editView) {
        this.currentVdr = vdr
        this.parentGrid = parent

        caption = createCaption(epg)

        center();

        closable = true
        modal = true
        width = "60%"

        setContent(
            verticalLayout [
                val headerLabel = label(it, epg.shortText)
                val header = horizontalLayout(it) [
                    it.addComponent(createChannel(epg))
                    it.addComponent(headerLabel)
                ]

                header.setComponentAlignment(headerLabel, Alignment.MIDDLE_LEFT)

                addDescription(it, epg, editView)

                horizontalLayout(it) [
                    button(it, messages.epgClose) [
                        addCloseButtonClickListener
                    ]

                    if (editView) {
                        button(it, messages.epgSave) [
                            it.addClickListener(s | {
                                svdrp.saveEpgData(Configuration.get.epgVdr, epg, epgArea.value)
                                close
                            })
                        ]
                    }

                    if (parentGrid !== null && !editView) {
                        button(it, messages.epgSwitchChannel) [
                            icon = VaadinIcons.PLAY
                            description = messages.epgSwitchChannel
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | parentGrid.actionPlay(epg))
                        ]

                        button(it, messages.epgSearchRetransmission) [
                            icon = VaadinIcons.SEARCH
                            description = messages.epgSearchRetransmission
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionSearch(epg) })
                        ]

                        button(it, messages.epgEditEpg) [
                            icon = VaadinIcons.EDIT
                            description = messages.epgEditEpg
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionEdit(epg) })
                        ]

                        button(it, messages.epgRecord) [
                            icon = VaadinIcons.CIRCLE
                            description = messages.epgRecord
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionRecord(epg) })
                        ]

                        button(it, messages.epgAlarm) [
                            icon = VaadinIcons.ALARM
                            description = messages.epgAlarm
                            styleName = ValoTheme.BUTTON_BORDERLESS
                            it.addClickListener(s | { close; parentGrid.actionAlarm(epg) })
                        ]
                    }
                ]
            ]
        )

        return this
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

    private def createChannel(Epg ev) {
        val name = svdrp.getChannel(ev.channelId).name
        val image = channelLogo.getImage(name)

        if (image !== null) {
            image.data = name
            return image
        } else {
            val label = new Label(name)
            label.data = name
            return label
        }
    }
}
