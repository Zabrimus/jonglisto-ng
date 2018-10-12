package vdr.jonglisto.web

import java.util.Set
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.logging.LogUtil
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.lifecycle")
class ConfigurationLifecycle {

    @Inject
    Config config

    val scheduledExecutorService = Executors.newScheduledThreadPool(2);

    def onStartup() {
        System.out.println("Initialized web application: ConfigurationLifecycle");

        // load logger configuration
        LogUtil.loadConfig

        log.info("Found configured VDRs:")
        val names = config.getVdrNames(null)
        names.forEach[log.info("   " + it)]

        // init scheduling
        // One minute event
        scheduledExecutorService.scheduleAtFixedRate(new Runnable() {
            override run() {
                SvdrpClient.getInstance.regularEvent()
            }
        }, 9, 15, TimeUnit.SECONDS);

    }

    def onStop() {
        System.out.println("Stopped web application: ConfigurationLifecycle");

        try {
            scheduledExecutorService.shutdown()
            scheduledExecutorService.awaitTermination(10, TimeUnit.SECONDS)
        } catch (Exception e) {
            System.err.println("Shutdown of scheduledExecutorService failed:" + e.message)
        }

        Configuration.instance.shutdown
    }
}
