package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.ui.themes.ValoTheme
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.JobComponent
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import vdr.jonglisto.web.ui.component.ExtFavouriteComponent
import vdr.jonglisto.web.ui.component.ToolsComponent

@Log
@CDIView(MainUI.CONFIG_VIEW)
class ConfigView extends BaseView {

    @Inject
    private ExtFavouriteComponent favourites

    @Inject
    private JobComponent jobs

    @Inject
    private ToolsComponent tools

    @PostConstruct
    def void init() {
        super.init(BUTTON.CONFIG)
        favourites.changeVdr(selectedVdr)
    }

    protected override createMainComponents() {
        val currentUser = SecurityUtils.subject

        val tabsheet = tabsheet [
            if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":favourite:all")) {
                addTab(favourites.showAll(), messages.configFavouriteChannel)
            } else if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":favourite:user")) {
                addTab(favourites.showUser(), messages.configFavouriteChannel)
            }

            if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:all")) {
                addTab(jobs.showAll(), messages.configJobs)
            } else if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:user")) {
                addTab(jobs.showUser(), messages.configJobs)
            }

            if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":tools:all")) {
                addTab(tools.showAll(), messages.configTools)
            }

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);
        ]

        addComponentsAndExpand(tabsheet)
    }

    override protected def void changeVdr(VDR vdr) {
        if (favourites !== null) {
            favourites.changeVdr(vdr);
        }
    }
}
