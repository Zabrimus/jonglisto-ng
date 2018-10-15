package vdr.jonglisto.svdrp.server

import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.svdrp.client.VdrDiscoveryClient
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.configuration.Configuration

@Log("jonglisto.discovery")
class DiscoveryHandler {

    def VDR process(String ip, String request) {
        var VDR vdr = DiscoveryUtil.findVdr(ip, request)

        if (vdr !== null) {
            try {
                try {
                    // wait a little bit
                    Thread.sleep(1000)
                } catch (InterruptedException e) {
                    // ignore
                }

                log.info("Send CONN to {}, {}", ip, request)
                SvdrpClient.instance.sendConn(vdr)
            } catch (Exception e) {
                log.info("Discovery request received, but connection to {} , {} failed", ip, request)
                if (!vdr.isConfigured) {
                    Configuration.instance.removeVdr(vdr)
                }
                vdr = null
            }

            if (vdr !== null) {
                // get list of plugins
                SvdrpClient.instance.fillPlugins(vdr)
            }

            // send new discovery
            VdrDiscoveryClient.instance.sendDiscovery
        }

        return vdr
    }
}
