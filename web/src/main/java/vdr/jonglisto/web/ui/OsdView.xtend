package vdr.jonglisto.web.ui

import com.vaadin.ui.HorizontalLayout
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.ui.component.OsdComponent
import vdr.jonglisto.web.ui.component.RemoteComponent
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class OsdView extends BaseView {

    val RemoteComponent remote
    var OsdComponent osd
    val HorizontalLayout layout

    new() {
        super(BUTTON.OSD)
        remote = new RemoteComponent(this, selectedVdr, Configuration.get.remoteConfig)
        osd = new OsdComponent(selectedVdr, SvdrpClient.get.getOsd(selectedVdr))

        layout = horizontalLayout[
            setSizeFull
            addComponent(remote)
            addComponentsAndExpand(osd)
        ]

        addComponentsAndExpand(layout)
    }

    def updateOsd() {
        val oldOsd = osd
        osd = new OsdComponent(selectedVdr, SvdrpClient.get.getOsd(selectedVdr))
        layout.replaceComponent(oldOsd, osd)
    }

    protected override createMainComponents() {
    }

    override protected def void changeVdr(VDR vdr) {
        remote.changeVdr(vdr)
        osd.changeVdr(vdr)
    }
}
