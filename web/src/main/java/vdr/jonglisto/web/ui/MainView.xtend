package vdr.jonglisto.web.ui

import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.ui.CssLayout
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.ui.component.VdrStatus
import vdr.jonglisto.xtend.annotation.Log

@Log
class MainView extends BaseView {

    new() {
        super(BUTTON.HOME)
    }

    override enter(ViewChangeEvent event) {
    }

    protected override createMainComponents() {
        val css = new CssLayout => [
            Configuration.get.vdrNames.forEach[s |
                addComponent(new VdrStatus(Configuration.get.getVdr(s)).panel)
            ]
        ]

        addComponentsAndExpand(css)
    }

    override protected def void changeVdr(VDR vdr) {
       // not used in this view
    }
}
