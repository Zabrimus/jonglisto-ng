package vdr.jonglisto.web.ui.component

import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Button
import com.vaadin.ui.Composite
import com.vaadin.ui.GridLayout
import com.vaadin.ui.Label
import java.util.HashSet
import vdr.jonglisto.configuration.jaxb.remote.Remote
import vdr.jonglisto.model.VDR
import com.vaadin.ui.HorizontalLayout
import vdr.jonglisto.svdrp.client.SvdrpClient

class RemoteComponent extends Composite {
    val Remote remote
    var VDR currentVdr

    new(VDR vdr, Remote remote) {
        this.remote = remote
        this.currentVdr = vdr

        createGrid
    }

    public def void changeVdr(VDR vdr) {
        this.currentVdr = vdr
    }

    private def createGrid() {
        val height = remote.button.map[s | s.row].max
        val width = remote.button.map[s | s.column].max

        // used to find empty rows
        val rows = new HashSet<Integer>
        for (var i = 1; i <= height; i++) {
            if (i != remote.colorRow) {
                rows.add(i)
            }
        }

        val layout = new GridLayout(width, height)

        remote.button.forEach(s | {
            val button = new Button(s.label)

            if (s.icon !== null) {
                button.icon = VaadinIcons.valueOf(s.icon)
            }
            button.width = "80px"
            button.height = "37px"

            button.addClickListener(event | {
                s.key.forEach(key | {
                    SvdrpClient.get.hitk(currentVdr, key);
                })
            })

            layout.addComponent(button, s.column-1, s.row-1)

            rows.remove(Integer.valueOf(s.row))
        })

        // rot, grün, gelb, blau

        // fill color row
        val redButton = new Button(" ") [
            SvdrpClient.get.hitk(currentVdr, "Red");
        ]
        redButton.styleName = "red"
        redButton.width = "100%"

        val greenButton = new Button(" ") [
            SvdrpClient.get.hitk(currentVdr, "Green");
        ]
        greenButton.styleName = "green"
        greenButton.width = "100%"

        val yellowButton = new Button(" ") [
            SvdrpClient.get.hitk(currentVdr, "Yellow");
        ]
        yellowButton.styleName = "yellow"
        yellowButton.width = "100%"

        val blueButton = new Button(" ") [
            SvdrpClient.get.hitk(currentVdr, "Blue");
        ]
        blueButton.styleName = "blue"
        blueButton.width = "100%"

        val cb = new HorizontalLayout
        cb.addComponent(redButton)
        cb.addComponent(greenButton)
        cb.addComponent(yellowButton)
        cb.addComponent(blueButton)

        cb.setExpandRatio(redButton, 2.0f)
        cb.setExpandRatio(greenButton, 2.0f)
        cb.setExpandRatio(yellowButton, 2.0f)
        cb.setExpandRatio(blueButton, 2.0f)

        cb.width = "100%"

        layout.addComponent(cb, 0, remote.colorRow-1, width-1, remote.colorRow-1)

        // fill empty rows
        rows.forEach[s |
            val l = new Label("")
            l.height = "10px"
            layout.addComponent(l, 0, s-1, width-1, s-1)
        ]

        compositionRoot = layout
    }
}
