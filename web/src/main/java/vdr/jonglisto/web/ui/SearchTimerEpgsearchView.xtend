package vdr.jonglisto.web.ui

import com.vaadin.cdi.CDIView
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Layout
import javax.annotation.PostConstruct
import javax.inject.Inject
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.ui.component.SearchTimerEpgsearchGrid

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

// @Log("jonglisto.web")
@CDIView(MainUI.SEARCHTIMER_EPGSEARCH_VIEW)
@SuppressWarnings("serial")
class SearchTimerEpgsearchView extends BaseView {

    @Inject
    SearchTimerEpgsearchGrid epgsearchGrid

    @PostConstruct
    def void init() {
        super.init(BUTTON.EPGSEARCH)
    }

    override refresh() {
        // do nothing
    }

    protected override createMainComponents() {
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

        val epgsearch = verticalLayout[
            setSizeFull
            prepareEpgdGrid(it)
        ]

        addComponentsAndExpand(epgsearch)
    }

    private def prepareEpgdGrid(Layout layout) {
        layout.addComponent(epgsearchGrid.init(selectedVdr))
    }

    override protected void changeVdr(VDR vdr) {
        if (epgsearchGrid !== null) {
            epgsearchGrid.setVdr(vdr)
        }
    }
}
