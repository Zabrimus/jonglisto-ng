package vdr.jonglisto.osdserver

import java.util.Locale
import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.osdserver.i18n.Messages
import vdr.jonglisto.svdrp.client.SvdrpClient

class OsdserverAlarmMessage {

    val OsdserverConnection connection
    val Messages messages
    val VDR vdr
    val Epg epg

    new(VDR vdr, OsdserverConnection connection, String localeStr, Epg epg) {
        this.vdr = vdr
        this.connection = connection
        val locale = Locale.forLanguageTag(localeStr)
        this.messages = new Messages(locale)
        this.epg = epg
    }

    def void show() {
        val response = connection.send("message -info -seconds 120 '" + messages.epgAlarm(epg.title) + "'")

        if (response.code == 300) {
            val r = response.message.split(" ")
            if (r.get(1) == "keyOk") {
                // switch to channel
                val ch = SvdrpClient.getInstance().getChannel(epg.channelId)
                SvdrpClient.getInstance().switchChannel(vdr, ch.id)
                return
            }
        }
    }
}

