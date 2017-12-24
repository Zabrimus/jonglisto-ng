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

    public static val MAIN_VIEW = "MainView"
    public static val EPG_VIEW = "EpgView"
    public static val CHANNEL_CONFIG_VIEW = "ChannelConfigView"
    public static val OSD_VIEW = "OsdView"
    public static val RECORDING_VIEW = "RecordingView"
    public static val TIMER_VIEW = "TimerView"
    public static val SEARCHTIMER_EPGD_VIEW = "SearchTimerEpgd"
    public static val SEARCHTIMER_EPGSEARCH_VIEW = "SearchTimerEpgsearch"

    @Inject
    private CDINavigator navigator;

    new() {
    }

    override protected init(VaadinRequest request) {
        navigator.init(this, this)

        //navigator = new Navigator(this, this)
        navigator.addViewChangeListener(this)

        // navigator.addView("", new LoginView(request.locale));
        // navigator.addView("", LoginView);
        // navigator.addView(MainUI.MAIN_VIEW, MainView)
        // navigator.addView(MainUI.EPG_VIEW, EpgView)
        // navigator.addView(MainUI.CHANNEL_CONFIG_VIEW, ChannelConfigView)
        // navigator.addView(MainUI.OSD_VIEW, OsdView)
        // navigator.addView(MainUI.RECORDING_VIEW, RecordingView)
        // navigator.addView(MainUI.TIMER_VIEW, TimerView)
        // navigator.addView(MainUI.SEARCHTIMER_EPGD_VIEW, SearchTimerEpgdView)
        // navigator.addView(MainUI.SEARCHTIMER_EPGSEARCH_VIEW, SearchTimerEpgsearchView)

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

        return true;
    }

    override afterViewChange(ViewChangeEvent event) {
    }

    override protected void refresh(VaadinRequest request) {
        super.refresh(request);
    }

    def static MainUI getMainUI() {
        current as MainUI
    }

    def doLogout() {
        val currentUser = SecurityUtils.subject
        currentUser?.logout

        Page.getCurrent().setUriFragment("");
        UI.navigator.navigateTo("")
    }
}
