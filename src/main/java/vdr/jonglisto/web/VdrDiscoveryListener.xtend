package vdr.jonglisto.web

import javax.servlet.ServletContextEvent
import javax.servlet.ServletContextListener
import javax.servlet.annotation.WebListener
import vdr.jonglisto.svdrp.server.VdrDiscoveryServer
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.servlet")
@WebListener
class VdrDiscoveryListener implements ServletContextListener {

    // private VdrDiscoveryServer discoveryServer
    private VdrDiscoveryServer discoveryServer

    override void contextInitialized(ServletContextEvent servletContextEvent) {
        log.info("Start discovery server")
        discoveryServer = new VdrDiscoveryServer(2)
        new Thread(discoveryServer).start
    }

    override void contextDestroyed(ServletContextEvent servletContextEvent) {
        log.info("Stop discovery server...")

        if (discoveryServer !== null) {
            discoveryServer.stop()
        }
    }
}
