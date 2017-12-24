package vdr.jonglisto.web

import com.vaadin.cdi.server.VaadinCDIServlet
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import javax.servlet.ServletException
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

@Log
class JonglistoNgServlet extends VaadinCDIServlet {

    private val scheduledExecutorService = Executors.newScheduledThreadPool(2);

    override protected def servletInitialized() throws ServletException {
        log.info("Found configured VDRs:")
        val names = Configuration.get.vdrNames
        names.forEach[log.info("   " + it)]

        // init scheduling

        // One minute event
        scheduledExecutorService.scheduleAtFixedRate(
            new Runnable() {
                override run() {
                    SvdrpClient.getInstance.doOneMinuteEvent()
                }
            }, 1, 1, TimeUnit.MINUTES);
    }

    override def destroy() {
        scheduledExecutorService.shutdown()

        SvdrpClient.getInstance.doShutdown

        super.destroy();
    }
}
