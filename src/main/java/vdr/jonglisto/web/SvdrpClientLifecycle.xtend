package vdr.jonglisto.web

import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.lifecycle")
class SvdrpClientLifecycle {

    def onStartup() {
        System.out.println("Initialized web application: SvdrpClientLifecycle");
        SvdrpClient.getInstance
    }

    def onStop() {
        System.out.println("Stopped web application: SvdrpClientLifecycle");
        SvdrpClient.getInstance.doShutdown
    }
}
