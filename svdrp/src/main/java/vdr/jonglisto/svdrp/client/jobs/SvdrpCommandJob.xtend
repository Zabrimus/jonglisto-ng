package vdr.jonglisto.svdrp.client.jobs

import org.knowm.sundial.Job
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

@Log
class SvdrpCommandJob extends Job {

    override doRun() {
        // get parameters
        val String vdrName = getJobContext().get("VDR_NAME")
        val String command = getJobContext().get("COMMAND")

        log.debug("Run job: " + vdrName + " -> " + command)

        val vdr = Configuration.instance.getVdr(vdrName)
        SvdrpClient.instance.processCommand(vdr, command)
    }
}
