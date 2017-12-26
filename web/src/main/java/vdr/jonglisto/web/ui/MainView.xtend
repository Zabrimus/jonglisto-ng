package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.ui.CssLayout
import javax.annotation.PostConstruct
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.VdrStatus
import vdr.jonglisto.xtend.annotation.Log

@Log
@CDIView(MainUI.MAIN_VIEW)
class MainView extends BaseView {

    @PostConstruct
    def void init() {
        super.init(BUTTON.HOME)
    }

    override enter(ViewChangeEvent event) {
    }

    protected override createMainComponents() {
        val css = new CssLayout => [
            config.vdrNames.forEach[s |
                addComponent(new VdrStatus().setVdr(config.getVdr(s)).panel)
            ]
        ]

        addComponentsAndExpand(css)
    }

    override protected def void changeVdr(VDR vdr) {
       // not used in this view
    }
}
