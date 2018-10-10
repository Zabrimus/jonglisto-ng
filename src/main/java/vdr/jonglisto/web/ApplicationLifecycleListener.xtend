package vdr.jonglisto.web

import javax.enterprise.event.Event
import javax.enterprise.inject.Any
import javax.inject.Inject
import javax.servlet.ServletContext
import javax.servlet.ServletContextEvent
import javax.servlet.ServletContextListener
import javax.servlet.annotation.WebListener
import javax.enterprise.util.AnnotationLiteral

@WebListener
class ApplicationLifecycleListener implements ServletContextListener {

    @Inject @Any
    Event<ServletContext> servletContextEvent;

    override contextInitialized(ServletContextEvent sce) {
        servletContextEvent.select(new AnnotationLiteral<AppStartEvent>() {}).fire(sce.getServletContext());
    }

    override contextDestroyed(ServletContextEvent sce) {
        servletContextEvent.select(new AnnotationLiteral<AppStopEvent>() {}).fire(sce.getServletContext());
    }
}
