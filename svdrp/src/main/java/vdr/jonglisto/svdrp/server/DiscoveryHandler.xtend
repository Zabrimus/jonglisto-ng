package vdr.jonglisto.svdrp.server

import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.svdrp.client.VdrDiscoveryClient
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.discovery")
class DiscoveryHandler {

    def VDR process(String ip, String request) {
        var VDR vdr = DiscoveryUtil.findVdr(ip, request)

        if (vdr !== null) {
            try {
                log.info("Send CONN to " + ip + " , " + request + " failed")
                SvdrpClient.instance.sendConn(vdr)
            } catch (Exception e) {
                log.info("Discovery request received, but connection to " + ip + " , " + request + " failed")
                vdr = null
            }

            // send new discovery
            VdrDiscoveryClient.instance.sendDiscovery
        }

        return vdr
    }
}
