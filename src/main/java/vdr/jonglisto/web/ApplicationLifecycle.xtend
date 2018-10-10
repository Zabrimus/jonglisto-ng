package vdr.jonglisto.web

import javax.enterprise.context.ApplicationScoped
import javax.enterprise.event.Observes
import javax.inject.Inject

@ApplicationScoped
class ApplicationLifecycle {

    @Inject
    ConfigurationLifecycle config

    @Inject
    SvdrpClientLifecycle svdrpClient

    @Inject
    SvdrpServerLifecycle svdrpServer

    @Inject
    SvdrpDiscoveryLifecycle discovery

    def onStartup(@Observes @AppStartEvent String type) {
        config.onStartup
        svdrpClient.onStartup
        svdrpServer.onStartup
        discovery.onStartup
    }

    def onStop(@Observes @AppStopEvent String type) {
        discovery.onStop
        svdrpServer.onStop
        svdrpClient.onStop
        config.onStop()
    }
}
