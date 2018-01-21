package vdr.jonglisto.osdserver

import vdr.jonglisto.model.Epg
import vdr.jonglisto.model.VDR
import vdr.jonglisto.xtend.annotation.Log

@Log
class OsdserverDispatch {

    public def static showOsd(VDR vdr, Integer port, String user, String command, String localeStr) {
        if (vdr === null || port === null || port == 0 || command === null) {
            log.warning("Ignore OsdServer command: " + vdr + ", " + port + ", " + command)
            return
        }

        // connect
        val connection = new OsdserverConnection(vdr.host, port)
        connection.connect

        switch(command) {
            case "favourite": {
                val fav = new OsdserverFavourite(vdr, connection, localeStr)
                fav.show
           }
        }

        connection.close
    }

    public def static showEpgAlarmMessageOsd(VDR vdr, Integer port, Epg epg, String localeStr) {
        if (vdr === null || port === null || port == 0 || epg === null) {
            log.warning("Ignore OsdServer command: " + vdr + ", " + port + ", " + epg.title)
            return
        }

        // connect
        val connection = new OsdserverConnection(vdr.host, port)
        connection.connect
        val m = new OsdserverAlarmMessage(vdr, connection, localeStr, epg)
        m.show
        connection.close
    }
}
