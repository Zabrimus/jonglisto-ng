package vdr.jonglisto.web.ui.component

import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Component
import com.vaadin.ui.Composite
import com.vaadin.ui.GridLayout
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.Label
import com.vaadin.ui.Panel
import com.vaadin.ui.VerticalLayout
import vdr.jonglisto.model.VDR
import vdr.jonglisto.model.VDROsd
import vdr.jonglisto.web.util.HtmlSanitizer

class OsdComponent extends Composite {
    var VDR currentVdr
    var VDROsd osd

    new(VDR vdr, VDROsd osd) {
        this.currentVdr = vdr
        this.osd = osd
        createGrid
    }

    public def void changeVdr(VDR vdr) {
        this.currentVdr = vdr
    }

    private def createGrid() {
        if (osd === null) {
            compositionRoot = new Label("No OSD open")
            return;
        }

        val height = 30
        val width = osd.layout.size

        val panel = new Panel(osd.title);

        var Component innerComponent
        if (osd.menuItems.size > 0) {
            innerComponent = gridOsd(width, height)
        } else {
            innerComponent = textOsd()
        }

        val mainLayout = new VerticalLayout

        val buttonLayout = new HorizontalLayout

        val redLabel = new Label(osd.red ?: " ")
        redLabel.styleName = "red"

        val greenLabel = new Label(osd.green ?: " ")
        greenLabel.styleName = "green"

        val yellowLabel = new Label(osd.yellow ?: " ")
        yellowLabel.styleName = "yellow"

        val blueLabel = new Label(osd.blue ?: " ")
        blueLabel.styleName = "blue"

        buttonLayout.addComponents(redLabel, greenLabel, yellowLabel, blueLabel)
        mainLayout.addComponent(buttonLayout)
        mainLayout.addComponentsAndExpand(innerComponent)

        panel.setContent = mainLayout

        panel.setSizeFull

        compositionRoot = panel
    }

    private def textOsd() {
        val cleanText = HtmlSanitizer.clean(osd.textBlock)
        val text = cleanText.replace("|", "<br/>")

        val label = new Label(text, ContentMode.HTML)

        return label
    }

    private def gridOsd(int width, int height) {
        val layout = new GridLayout(width + 1, height)

        var int currentRow = 0
        for (var i = 0; i <= Math.min(osd.menuItems.size-1, height-1); i++) {
            var int currentColumn = 0

            var style = "osditem"
            if (osd.menuItems.get(i).isSelected) {
                style = "selectedosditem"
            }

            for (g : osd.menuItems.get(i).items) {
                val label = new Label(g)
                label.styleName = style

                if (osd.menuItems.get(i).items.size > 1) {
                    layout.addComponent(label, currentColumn, currentRow)
                } else {
                    layout.addComponent(label, currentColumn, currentRow, width, currentRow)
                }

                currentColumn++
            }

            currentRow++
        }

        return layout
    }
}
