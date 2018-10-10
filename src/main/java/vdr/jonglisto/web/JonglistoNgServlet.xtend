package vdr.jonglisto.web

import com.vaadin.cdi.server.VaadinCDIServlet
import javax.servlet.annotation.WebInitParam
import javax.servlet.annotation.WebServlet
import vdr.jonglisto.xtend.annotation.Log

@WebServlet(urlPatterns = #["/*", "/VAADIN/"],
            name = "VaadinServlet",
            asyncSupported = true,
            initParams = #[@WebInitParam(name = "closeIdleSessions", value = "false") ]
            )
@Log("jonglisto.servlet")
@SuppressWarnings("serial")
class JonglistoNgServlet extends VaadinCDIServlet {
}
