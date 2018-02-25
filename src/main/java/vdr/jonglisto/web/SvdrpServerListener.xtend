package vdr.jonglisto.web

import javax.servlet.ServletContextEvent
import javax.servlet.ServletContextListener
import javax.servlet.annotation.WebListener
import vdr.jonglisto.svdrp.server.SvdrpServer
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.configuration.Configuration

@Log
@WebListener
class SvdrpServerListener implements ServletContextListener {

    private SvdrpServer svdrpServer

    override void contextInitialized(ServletContextEvent servletContextEvent) {
        // start svdrp server, if port is configured
        if (Configuration.instance.getSvdrpServerPort() > 0) {
            log.info("Start svdrp server using port " + Configuration.instance.getSvdrpServerPort());
            svdrpServer = new SvdrpServer(Configuration.instance.getSvdrpServerPort(), 10);
            new Thread(svdrpServer).start
        }
    }

    override void contextDestroyed(ServletContextEvent servletContextEvent) {
        log.severe("Stop svdrp server...")

        if (svdrpServer !== null) {
            svdrpServer.stopServer
        }
    }
}
