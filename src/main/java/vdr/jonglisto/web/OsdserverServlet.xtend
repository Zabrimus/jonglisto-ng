package vdr.jonglisto.web

import javax.inject.Inject
import javax.servlet.annotation.WebInitParam
import javax.servlet.annotation.WebServlet
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.osdserver.OsdserverDispatch
import vdr.jonglisto.xtend.annotation.Log

@WebServlet(urlPatterns = #["/osdserver/*"], name = "OsdServer",
            initParams = #[@WebInitParam(name = "closeIdleSessions", value = "true") ]
            )
@Log
class OsdserverServlet extends HttpServlet {
    @Inject
    private Config config

    public override void doGet(HttpServletRequest req, HttpServletResponse resp) {
        log.info("Connect from " + req.remoteAddr + ":" + req.remotePort)

        var int osdServerPort
        try {
            osdServerPort = Integer.parseInt(req.getParameter("port") ?: "2010")
        } catch (Exception e) {
            osdServerPort = 2010
        }

        var int svdrpPort
        try {
            svdrpPort = Integer.parseInt(req.getParameter("svdrp") ?: "6419")
        } catch (Exception e) {
            svdrpPort = 6419
        }

        var String localeStr = req.getParameter("locale")
        if (localeStr === null || localeStr.length == 0) {
            localeStr = "en"
        }

        val user = req.getParameter("user")
        val command = req.getParameter("command")

        if ((command === null) || (command.length == 0)) {
            log.warning("parameter command is missing or not valid.")
            resp.closeConnection
            return
        }

        val vdr = config.findVdr(req.remoteAddr, svdrpPort)

        if (vdr.isPresent) {
            resp.closeConnection
            OsdserverDispatch.showOsd(vdr.get, osdServerPort, user, command, localeStr)
        } else {
            log.warning("Cannot identify VDR at " + req.remoteAddr + ":" + svdrpPort)
            resp.closeConnection
        }
    }

    private def void closeConnection(HttpServletResponse resp) {
        resp.outputStream.flush
        resp.outputStream.close
    }
}
