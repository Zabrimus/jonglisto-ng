package vdr.jonglisto.osdserver.jobs

import org.knowm.sundial.Job
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.osdserver.OsdserverDispatch

@Log
class OsdServerMessageJob extends Job {

    override doRun() {
        // get parameters
        val String vdrName = getJobContext().get("VDR_NAME")
        val String command = getJobContext().get("COMMAND")

        log.fine("Run job: " + vdrName + " -> " + command)

        val vdr = Configuration.instance.getVdr(vdrName)

        // split command to get all needed information
        try {
            val splitted = command.split(";")

            val osdserverPort = Integer.valueOf(splitted.get(0))
            val channel = SvdrpClient.getInstance().getChannel(splitted.get(1))
            val time = Long.valueOf(splitted.get(2))
            val locale = splitted.get(3)
            val epgEntry = SvdrpClient.getInstance().epg.findFirst[s | (s.channelId == channel.id) && (s.startTime <= time) && ((s.startTime + s.duration) > time)]

            OsdserverDispatch.showEpgAlarmMessageOsd(vdr, osdserverPort, epgEntry, locale)
        } catch (Exception e) {
            log.warning("Command '" + command + "' has invalid format for OsdServerMessageJob and will be ignored!")
        }
    }
}
