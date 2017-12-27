package vdr.jonglisto.web;

import com.vaadin.annotations.PreserveOnRefresh
import com.vaadin.annotations.Theme
import com.vaadin.annotations.Title
import com.vaadin.cdi.CDINavigator
import com.vaadin.cdi.CDIUI
import com.vaadin.navigator.ViewChangeListener
import com.vaadin.server.Page
import com.vaadin.server.VaadinRequest
import com.vaadin.ui.UI
import javax.inject.Inject
import org.apache.shiro.SecurityUtils
import vdr.jonglisto.web.ui.ErrorView
import vdr.jonglisto.xtend.annotation.Log

@Theme("jonglisto")
@Title("VDR Jonglisto")
@PreserveOnRefresh
@Log
@CDIUI("")
class MainUI extends UI implements ViewChangeListener {

    public static val MAIN_VIEW = "main"
    public static val EPG_VIEW = "epg"
    public static val CHANNEL_CONFIG_VIEW = "channelconfig"
    public static val OSD_VIEW = "osd"
    public static val RECORDING_VIEW = "recordings"
    public static val TIMER_VIEW = "timer"
    public static val SEARCHTIMER_EPGD_VIEW = "searchtimer:epgd"
    public static val SEARCHTIMER_EPGSEARCH_VIEW = "searchtimer:epgsearch"

    @Inject
    private CDINavigator navigator;

    new() {
    }

    override protected init(VaadinRequest request) {
        navigator.init(this, this)

        navigator.addViewChangeListener(this)
        navigator.errorView = ErrorView
    }

    override beforeViewChange(ViewChangeEvent event) {
        val currentUser = SecurityUtils.subject

        if (currentUser.authenticated && event.viewName == "") {
            event.navigator.navigateTo(MainUI.MAIN_VIEW)
            return false
        }

        if (!currentUser.authenticated && !(event.viewName == "")) {
            event.navigator.navigateTo("")
            return false;
        }

        // check view permission. Login and Main are always allowed for authenticated users
        if (!(event.viewName == "") && !(event.viewName == MainUI.MAIN_VIEW) && !currentUser.isPermitted("view:" + event.viewName)) {
            event.navigator.navigateTo("")
            return false;
        }

        return true;
    }

    override afterViewChange(ViewChangeEvent event) {
    }

    override protected void refresh(VaadinRequest request) {
        super.refresh(request);
    }

    def doLogout() {
        val currentUser = SecurityUtils.subject
        currentUser?.logout

        Page.getCurrent().setUriFragment("");
        UI.navigator.navigateTo("")
    }
}
