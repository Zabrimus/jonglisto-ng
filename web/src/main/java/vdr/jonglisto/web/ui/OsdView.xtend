package vdr.jonglisto.web.ui

import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.ui.component.RemoteComponent
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class OsdView extends BaseView {

    val RemoteComponent remote

    new() {
        super(BUTTON.OSD)
        remote = new RemoteComponent(null, Configuration.get.remoteConfig)

        val h = horizontalLayout[
            setSizeFull
            addComponent(remote)
        ]

        addComponentsAndExpand(h)
    }

    protected override createMainComponents() {
    }

    override protected def void changeVdr(VDR vdr) {
        remote.changeVdr(vdr)
    }
}
