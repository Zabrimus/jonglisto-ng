package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Button
import com.vaadin.ui.Composite
import com.vaadin.ui.GridLayout
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.Label
import java.util.HashSet
import javax.inject.Inject
import vdr.jonglisto.configuration.jaxb.remote.Remote
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.model.VDR
import vdr.jonglisto.web.ui.OsdView
import com.vaadin.ui.Notification
import vdr.jonglisto.web.i18n.Messages

@ViewScoped
class RemoteComponent extends Composite {

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    var Remote remote
    var VDR currentVdr
    var OsdView parent

    public def changeVdr(VDR vdr) {
        this.currentVdr = vdr
        return this
    }

    public def changeRemote(Remote remote) {
        this.remote = remote
        return this
    }

    public def setParent(OsdView parent) {
        this.parent = parent
        return this
    }

    public def void createGrid() {
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
                    hitk(key)
                })
            })

            layout.addComponent(button, s.column-1, s.row-1)

            rows.remove(Integer.valueOf(s.row))
        })

        // fill color row
        val redButton = new Button(" ") [
            hitk("Red")
        ]
        redButton.styleName = "red"
        redButton.width = "100%"

        val greenButton = new Button(" ") [
            hitk("Green")
        ]
        greenButton.styleName = "green"
        greenButton.width = "100%"

        val yellowButton = new Button(" ") [
            hitk("Yellow")
        ]
        yellowButton.styleName = "yellow"
        yellowButton.width = "100%"

        val blueButton = new Button(" ") [
            hitk("Blue")
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

    private def hitk(String key) {
        try {
            svdrp.hitk(currentVdr, key);
            Thread.sleep(250)
            parent.updateOsd
        } catch (Exception e) {
            Notification.show(messages.errorVdrNotRunning)
        }
    }
}
