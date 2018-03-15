package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.ui.HorizontalLayout
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.OsdComponent
import vdr.jonglisto.web.ui.component.RemoteComponent
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
@CDIView(MainUI.OSD_VIEW)
class OsdView extends BaseView {

    @Inject
    private RemoteComponent remote

    @Inject
    private Config config

    private OsdComponent osd
    var HorizontalLayout layout

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


    def updateOsd() {
        val oldOsd = osd
        osd = new OsdComponent().changeVdr(selectedVdr).changeOsd(svdrp.getOsd(selectedVdr))
        osd.createGrid
        layout.replaceComponent(oldOsd, osd)
    }

    protected override createMainComponents() {
    }

    override protected def void changeVdr(VDR vdr) {
        remote.changeVdr(vdr)

        if (osd !== null) {
            osd.changeVdr(vdr)
        }
    }
}
