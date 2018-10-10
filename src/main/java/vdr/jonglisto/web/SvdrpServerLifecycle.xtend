package vdr.jonglisto.web

import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.svdrp.server.SvdrpServer
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.lifecycle")
class SvdrpServerLifecycle {

    SvdrpServer svdrpServer

    def onStartup() {
        System.out.println("Initialized web application: SvdrpServerLifecycle");

        // start svdrp server, if port is configured
        if (Configuration.instance.getSvdrpServerPort() > 0) {
            log.info("Start svdrp server using port " + Configuration.instance.getSvdrpServerPort());
            svdrpServer = new SvdrpServer(Configuration.instance.getSvdrpServerPort(), 20);
            new Thread(svdrpServer).start
        }
    }

    def onStop() {
        System.out.println("Stopped web application: SvdrpServerLifecycle");

        if (svdrpServer !== null) {
            svdrpServer.stopServer
        }
    }
}
