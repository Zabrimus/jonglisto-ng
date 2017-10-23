package vdr.jonglisto.web.ui

import vdr.jonglisto.model.VDR
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class OsdView extends BaseView {

    new() {
        super(BUTTON.OSD)
    }

    protected override createMainComponents() {
        label("OsdSubView")
    }

    override protected def void changeVdr(VDR vdr) {
       // FIXME: Do something useful
    }
}
