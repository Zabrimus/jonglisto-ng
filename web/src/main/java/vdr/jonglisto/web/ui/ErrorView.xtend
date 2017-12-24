package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import javax.annotation.PostConstruct
import vdr.jonglisto.model.VDR

import static vdr.jonglisto.web.xtend.UIBuilder.*

@CDIView
class ErrorView extends BaseView {

    @PostConstruct
    def void init() {
        super.init(null)
    }

    override enter(ViewChangeEvent event) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    override protected createMainComponents() {
        label(this, "Oops. The view you tried to navigate to doesn't exist.")
    }

    override protected def void changeVdr(VDR vdr) {
       // not used in this view
    }
}
