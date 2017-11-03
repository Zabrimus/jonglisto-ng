package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Alignment
import com.vaadin.ui.Component
import com.vaadin.ui.Composite
import com.vaadin.ui.CssLayout
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.themes.ValoTheme

import static vdr.jonglisto.web.xtend.UIBuilder.*

class CPanel extends Composite {
    var HorizontalLayout header
    var CssLayout panel

    new(String caption) {
        panel = cssLayout[
            addStyleName(ValoTheme.LAYOUT_CARD)

            header = horizontalLayout(it) [
                addStyleName("v-panel-caption")
                spacing = false
                width = "100%"
                val label = label(it, caption) [
                ]

                setExpandRatio(label, 3.0f)
            ]

            setSizeUndefined
        ]


        compositionRoot = panel
        setSizeUndefined
    }

    def addHeaderComponent(Component c) {
        header.addComponent(c)
        header.setComponentAlignment(c, Alignment.TOP_RIGHT)

        return this
    }

    def addComponent(Component c) {
        panel.addComponent(c)

        return this
    }
}
