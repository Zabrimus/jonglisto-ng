package vdr.jonglisto.web

import vdr.jonglisto.svdrp.client.VdrDiscoveryClient
import vdr.jonglisto.svdrp.server.VdrDiscoveryServer
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.configuration.Configuration

@Log("jonglisto.lifecycle")
class SvdrpDiscoveryLifecycle {

    VdrDiscoveryServer discoveryServer

    def onStartup() {
        System.out.println("Initialized web application: SvdrpDiscoveryLifecycle");

        if (Configuration.instance.getStartDiscovery) {
            log.info("Start VDR Discovery server at UDP Port 6419")
            discoveryServer = new VdrDiscoveryServer(10)
            new Thread(discoveryServer).start

            // Send discovery
            VdrDiscoveryClient.instance.sendDiscovery
        }
    }

    def onStop() {
        System.out.println("Stopped web application: SvdrpDiscoveryLifecycle");

        if (discoveryServer !== null) {
            discoveryServer.stop()
        }

        VdrDiscoveryClient.instance.stop
    }
}
