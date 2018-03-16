package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.ui.CssLayout
import javax.annotation.PostConstruct
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.VdrStatus
import vdr.jonglisto.xtend.annotation.Log
import com.vaadin.ui.Label
import vdr.jonglisto.web.util.JonglistoVersion
import javax.inject.Inject

@Log
@CDIView(MainUI.MAIN_VIEW)
class MainView extends BaseView {

    @Inject
    private JonglistoVersion jv

    @PostConstruct
    def void init() {
        super.init(BUTTON.HOME)
    }

    override enter(ViewChangeEvent event) {
    }

    protected override createMainComponents() {
        val currentUser = SecurityUtils.subject

        val css = new CssLayout => [
            config.getVdrNames(currentUser).forEach[s |
                addComponent(new VdrStatus().setVdr(config.getVdr(s)).panel)
            ]
        ]

        addComponentsAndExpand(css)
        addComponent(new Label("Version: " + jv.version))
    }

    override protected def void changeVdr(VDR vdr) {
       // not used in this view
    }
}
