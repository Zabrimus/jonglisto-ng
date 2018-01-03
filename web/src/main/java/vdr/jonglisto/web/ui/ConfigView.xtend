package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.ui.themes.ValoTheme
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.FavouriteComponent
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.CONFIG_VIEW)
class ConfigView extends BaseView {

    @Inject
	private FavouriteComponent favourites

    @PostConstruct
    def void init() {
        super.init(BUTTON.CONFIG)
    }

    protected override createMainComponents() {
        val currentUser = SecurityUtils.subject

        val channelFavouriteTab = favourites
        val jobTab = favourites // FIXME

        val tabsheet = tabsheet [
            if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":favourite:all")) {
            	addTab(channelFavouriteTab.showAll(), messages.configFavouriteChannel)
			} else if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":favourite:user")) {
                addTab(channelFavouriteTab.showUser(currentUser), messages.configFavouriteChannel)
                        }

            if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:all")) {
                addTab(jobTab.showAll(), "TODO: JOBS")
            } else if (currentUser.isPermitted("view:" + MainUI.CONFIG_VIEW + ":jobs:user")) {
            	addTab(jobTab.showUser(currentUser), "TODO: JOBS")
            }

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);
        ]

        addComponentsAndExpand(tabsheet)
    }

    override protected def void changeVdr(VDR vdr) {
        // not used
    }
}
