package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.ui.HorizontalLayout
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.OsdComponent
import vdr.jonglisto.web.ui.component.RemoteComponent

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

// @Log("jonglisto.web")
@CDIView(MainUI.OSD_VIEW)
@SuppressWarnings("serial")
class OsdView extends BaseView {

    @Inject
    RemoteComponent remote

    @Inject
    Config config

    OsdComponent osd
    var HorizontalLayout layout

    override enter(ViewChangeEvent event) {
    }

    @PostConstruct
    def void init() {
        super.init(BUTTON.OSD)
        remote.setParent(this).changeVdr(selectedVdr).changeRemote(config.remoteConfig).createGrid

        osd = new OsdComponent().changeVdr(selectedVdr).changeOsd(svdrp.getOsd(selectedVdr))
        osd.createGrid

        layout = horizontalLayout[
            setSizeFull
            addComponent(remote)
            addComponentsAndExpand(osd)
        ]

        addComponentsAndExpand(layout)
    }

    override refresh() {
        // do nothing
    }

    def updateOsd() {
        val oldOsd = osd
        osd = new OsdComponent().changeVdr(selectedVdr).changeOsd(svdrp.getOsd(selectedVdr))
        osd.createGrid
        layout.replaceComponent(oldOsd, osd)
    }

    protected override createMainComponents() {
    }

    override protected void changeVdr(VDR vdr) {
        remote.changeVdr(vdr)

        if (osd !== null) {
            osd.changeVdr(vdr)
        }
    }
}
