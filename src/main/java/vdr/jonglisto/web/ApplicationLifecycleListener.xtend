package vdr.jonglisto.web

import javax.enterprise.event.Event
import javax.enterprise.inject.Any
import javax.enterprise.util.AnnotationLiteral
import javax.inject.Inject
import javax.servlet.ServletContextEvent
import javax.servlet.ServletContextListener
import javax.servlet.annotation.WebListener

@WebListener
class ApplicationLifecycleListener implements ServletContextListener {

    @Inject @Any
    Event<String> servletContextEvent;

    override contextInitialized(ServletContextEvent sce) {
        servletContextEvent.select(new AnnotationLiteral<AppStartEvent>() {}).fire("start request");
    }

    override contextDestroyed(ServletContextEvent sce) {
        servletContextEvent.select(new AnnotationLiteral<AppStopEvent>() {}).fire("stop request");
    }
}
