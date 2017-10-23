package vdr.jonglisto.web.ui

import vdr.jonglisto.model.VDR
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class SearchTimerEpgsearchView extends BaseView {

    new() {
        super(BUTTON.EPGSEARCH)
    }

    protected override createMainComponents() {
        label("Not yet implemented")
    }

    override protected def void changeVdr(VDR vdr) {
       // FIXME: Do something useful
    }
}
