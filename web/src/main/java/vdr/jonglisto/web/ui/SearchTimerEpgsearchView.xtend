package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Layout
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.db.Database
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.SearchTimerEpgsearchGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@CDIView(MainUI.SEARCHTIMER_EPGSEARCH_VIEW)
class SearchTimerEpgsearchView extends BaseView {

    @Inject
    private SearchTimerEpgsearchGrid epgsearchGrid

    @PostConstruct
    def void init() {
        super.init(BUTTON.EPGSEARCH)
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
                    epgsearchGrid.refreshSearchTimer
                })
            ]

            button(messages.searchtimerNewTimer) [
                icon = VaadinIcons.PLUS
                addClickListener(s | {
                    epgsearchGrid.newTimer
                })
            ]
        ]

        if (Database.isConfigured) {
            val epgsearch = verticalLayout[
                setSizeFull
                prepareEpgdGrid(it)
            ]

            addComponentsAndExpand(epgsearch)
        }
    }

    private def prepareEpgdGrid(Layout layout) {
        layout.addComponent(epgsearchGrid.init(selectedVdr))
    }

    override protected def void changeVdr(VDR vdr) {
        if (epgsearchGrid !== null) {
            epgsearchGrid.setVdr(vdr)
        }

        // FIXME: Do something useful. e.g. check if the newly selected VDR has epgsearch plugin
    }
}
