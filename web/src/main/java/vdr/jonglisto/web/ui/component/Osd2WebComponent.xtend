package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.server.ExternalResource
import com.vaadin.ui.BrowserFrame
import com.vaadin.ui.VerticalLayout
import vdr.jonglisto.model.VDR
import com.vaadin.ui.Label

@ViewScoped
@SuppressWarnings("serial")
class Osd2WebComponent extends VerticalLayout {

    var VDR currentVdr

    def changeVdr(VDR vdr) {
        this.currentVdr = vdr
        return this
    }

    def createComponent() {
        if (currentVdr !== null && currentVdr.osd2webPort > 0) {
            val browser = new BrowserFrame("", new ExternalResource("http://" + currentVdr.host + ":" + currentVdr.osd2webPort));
            browser.setWidth("100%");
            browser.setHeight("100%");
            addComponent(browser);
        } else {
            addComponent(new Label("osd2web port is not configured"))
        }
    }
}
