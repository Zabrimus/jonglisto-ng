package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Composite
import com.vaadin.ui.Image
import com.vaadin.ui.Label

import static vdr.jonglisto.web.xtend.UIBuilder.*
import vdr.jonglisto.web.util.HtmlSanitizer
import com.vaadin.shared.ui.ContentMode

@SuppressWarnings("serial")
class ActorImage extends Composite {
    new(Image image, String role, String name) {

        val v = verticalLayout [
            addComponent(image)

            val roleLabel = new Label("<span>" + HtmlSanitizer.clean(role) + "</span>", ContentMode.HTML)
            addComponent(roleLabel)

            val nameLabel = new Label("<span style=\"font-style: italic;\">" + HtmlSanitizer.clean(name) + "</span>", ContentMode.HTML)
            addComponent(nameLabel)

            spacing = false
        ]

        compositionRoot = v
        styleName = "actorcomp"

        setSizeUndefined
    }
}
