package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.ui.CssLayout
import com.vaadin.ui.Label
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.VdrStatus
import vdr.jonglisto.web.util.JonglistoVersion

// @Log("jonglisto.web")
@CDIView(MainUI.MAIN_VIEW)
@SuppressWarnings("serial")
class MainView extends BaseView {

    @Inject
    JonglistoVersion jv

    val mainLayout = new CssLayout

    @PostConstruct
    def void init() {
        super.init(BUTTON.HOME)
    }

    override refresh() {
        mainLayout.removeAllComponents
        fillMainLayout
    }

    override enter(ViewChangeEvent event) {
    }

    protected override createMainComponents() {
        fillMainLayout

        addComponentsAndExpand(mainLayout)
        addComponent(new Label("Version: " + jv.version))
    }

    override protected void changeVdr(VDR vdr) {
       // not used in this view
    }

    private def void fillMainLayout() {
        val currentUser = SecurityUtils.subject

        config.getVdrNames(currentUser).forEach[s |
            mainLayout.addComponent(new VdrStatus().setVdr(config.getVdr(s)).panel)
        ]

    }
}
