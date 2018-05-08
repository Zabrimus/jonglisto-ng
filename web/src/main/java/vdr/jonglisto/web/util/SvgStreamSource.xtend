package vdr.jonglisto.web.util

import com.vaadin.server.StreamResource
import com.vaadin.server.StreamResource.StreamSource
import java.io.BufferedInputStream
import java.io.ByteArrayInputStream
import java.io.InputStream
import java.nio.charset.StandardCharsets

@SuppressWarnings("serial")
class SvgStreamSource extends StreamResource {

    new(String svgText) {
        super(new StreamSource() {
            override InputStream getStream() {
                return new BufferedInputStream(new ByteArrayInputStream(svgText.getBytes(StandardCharsets.UTF_8)))
            }
        }, "timeline-" + System.currentTimeMillis + ".svg");
    }

    override String getMIMEType() {
        return "image/svg+xml";
    }

}

