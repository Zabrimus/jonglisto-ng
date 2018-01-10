package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Layout
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.db.Database
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.SearchTimerEpgdGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.SEARCHTIMER_EPGD_VIEW)
class SearchTimerEpgdView extends BaseView {

    @Inject
    private SearchTimerEpgdGrid epgdGrid

    @PostConstruct
    def void init() {
        super.init(BUTTON.EPGD)
    }

    protected override createMainComponents() {
        // sanity check
        if (!config.isDatabaseConfigured) {
            return
        }

        horizontalLayout[
            button(messages.searchtimerRefresh) [
                icon = VaadinIcons.REFRESH
                addClickListener(s | {
                    epgdGrid.refreshSearchTimer
                })
            ]

            button(messages.searchtimerNewTimer) [
                icon = VaadinIcons.PLUS
                addClickListener(s | {
                    epgdGrid.newTimer
                })
            ]
        ]

        if (Database.isConfigured) {
            val epgd = verticalLayout[
                setSizeFull
                prepareEpgdGrid(it)
            ]

            addComponentsAndExpand(epgd)
        }
    }

    override protected def void changeVdr(VDR vdr) {
       // not needed
    }

    private def prepareEpgdGrid(Layout layout) {
        layout.addComponent(epgdGrid.grid)
    }
}
