package vdr.jonglisto.web

import com.vaadin.annotations.VaadinServletConfiguration
import com.vaadin.server.VaadinServlet
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import javax.servlet.ServletException
import javax.servlet.annotation.WebServlet
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

@Log
@WebServlet(value = "/*", loadOnStartup = 1, asyncSupported = true)
@VaadinServletConfiguration(productionMode = false, ui = MainUI)
class JonglistoNgServlet extends VaadinServlet {

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
                    SvdrpClient.get.doOneMinuteEvent()
                }
            }, 1, 1, TimeUnit.MINUTES);
    }

    override def destroy() {
        scheduledExecutorService.shutdown()

        SvdrpClient.get.doShutdown

        super.destroy();
    }
}
