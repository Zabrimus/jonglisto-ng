package vdr.jonglisto.web.ui.component

import com.vaadin.cdi.ViewScoped
import com.vaadin.ui.Button
import com.vaadin.ui.Window
import javax.inject.Inject
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
@ViewScoped
class JobEditWindow extends Window {

    @Inject
    private Config config

    @Inject
    private Messages messages

    new() {
        super()
    }

    def showWindow(Jobs job) {
        center();

        closable = true
        modal = true
        width = "60%"

        setContent(
            verticalLayout [

                cssLayout(it) [
                    width = "100%"
                    button(it, "Save") [
                        it.addClickListener(s | {
                            // TODO: Save job
                            close
                        })
                    ]

                    button(it, "Cancel") [
                        it.addClickListener(s | {
                            close
                        })
                    ]
                ]
            ]
        )

        return this
    }

    def addCloseButtonClickListener(Button b) {
        b.addClickListener(s | {
            close
        })
    }
}
