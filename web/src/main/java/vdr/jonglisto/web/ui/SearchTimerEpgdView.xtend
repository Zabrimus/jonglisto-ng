package vdr.jonglisto.web.ui

import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Layout
import vdr.jonglisto.db.Database
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.ui.component.SearchTimerEpgdGrid
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class SearchTimerEpgdView extends BaseView {

    var SearchTimerEpgdGrid epgdGrid

    new() {
        super(BUTTON.EPGD)
    }

    protected override createMainComponents() {
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
       // FIXME: Do something useful
    }

    private def prepareEpgdGrid(Layout layout) {
        epgdGrid = new SearchTimerEpgdGrid(messages)
        layout.addComponent(epgdGrid.grid)
    }
}
