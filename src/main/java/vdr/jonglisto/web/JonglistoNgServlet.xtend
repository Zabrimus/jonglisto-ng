package vdr.jonglisto.web

import com.vaadin.cdi.server.VaadinCDIServlet
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.servlet.ServletException
import javax.servlet.annotation.WebInitParam
import javax.servlet.annotation.WebServlet
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

@WebServlet(urlPatterns = #["/*", "/VAADIN/"],
            name = "VaadinServlet",
            asyncSupported = true,
            initParams = #[@WebInitParam(name = "closeIdleSessions", value = "true") ]
            )
@Log
class JonglistoNgServlet extends VaadinCDIServlet {

    @Inject
    private Config config

    private val scheduledExecutorService = Executors.newScheduledThreadPool(2);

    override protected def servletInitialized() throws ServletException {
        log.info("Found configured VDRs:")
        val names = config.getVdrNames
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
