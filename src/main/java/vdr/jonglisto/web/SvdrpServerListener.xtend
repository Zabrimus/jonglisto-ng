package vdr.jonglisto.web

import javax.servlet.ServletContextEvent
import javax.servlet.ServletContextListener
import javax.servlet.annotation.WebListener
import vdr.jonglisto.svdrp.server.SvdrpServer
import vdr.jonglisto.xtend.annotation.Log

@Log
@WebListener
class SvdrpServerListener implements ServletContextListener {

    // private SvdrpServer svdrpServer

    override void contextInitialized(ServletContextEvent servletContextEvent) {
        log.info("Start svdrp server...")

        log.info("Not yet implemented...")

        // start svdrp server
        // svdrpServer = new SvdrpServer(6420, 10);
        // new Thread(svdrpServer).start
    }

    override void contextDestroyed(ServletContextEvent servletContextEvent) {
        log.severe("Stop svdrp server...")
        // svdrpServer.stopServer
    }
}
