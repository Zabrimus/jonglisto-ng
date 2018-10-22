package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.ui.HorizontalLayout
import javax.annotation.PostConstruct
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.Osd2WebComponent

// @Log("jonglisto.web")
@CDIView(MainUI.OSD2WEB_VIEW)
@SuppressWarnings("serial")
class Osd2WebView extends BaseView {

    var Osd2WebComponent osd

    override enter(ViewChangeEvent event) {
    }

    @PostConstruct
    def void init() {
        super.init(BUTTON.OSD2WEB)

        osd = new Osd2WebComponent().changeVdr(selectedVdr)
        osd.createComponent

        addComponentsAndExpand(osd)
    }

    override refresh() {
        // do nothing
    }

    protected override createMainComponents() {
    }

    override protected void changeVdr(VDR vdr) {
        if (osd !== null) {
            osd.changeVdr(vdr)
        }
    }
}
