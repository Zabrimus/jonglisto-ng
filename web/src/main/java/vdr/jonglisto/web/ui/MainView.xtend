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
import com.vaadin.ui.UI

// @Log("jonglisto.web")
@CDIView(MainUI.MAIN_VIEW)
@SuppressWarnings("serial")
class MainView extends BaseView {

    @Inject
    JonglistoVersion jv

    @Inject
    UI currentViewUI

    val CssLayout css = new CssLayout

    val currentUser = SecurityUtils.subject

    val vdrInfoUpdater = new Runnable() {

        boolean firstRun = true;

        override run() {
            while(true) {
                Thread.sleep(20000)

                try {
                    css.removeAllComponents

                    currentViewUI.access(new Runnable() {
                        override run() {
                            config.getVdrNames(currentUser).forEach [ s |
                                val vdrStatus = new VdrStatus()
                                vdrStatus.setVdr(config.getVdr(s))

                                if (!firstRun) {
                                    vdrStatus.refreshStatus
                                }

                                css.addComponent(vdrStatus.panel)
                            ]

                        }
                    })

                    firstRun = false
                    Thread.sleep(5000)
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @PostConstruct
    def void init() {
        super.init(BUTTON.HOME)
    }

    override enter(ViewChangeEvent event) {
    }

    protected override createMainComponents() {
        addComponentsAndExpand(css)
        addComponent(new Label("Version: " + jv.version))

        new Thread(vdrInfoUpdater).start()
    }

    override protected void changeVdr(VDR vdr) {
        // not used in this view
    }
}
