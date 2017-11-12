package vdr.jonglisto.web.util

import com.vaadin.server.Resource
import com.vaadin.server.StreamResource
import com.vaadin.server.StreamResource.StreamSource
import com.vaadin.ui.Image
import com.vaadin.util.FileTypeResolver
import java.util.Collections
import java.util.HashMap

import static extension org.apache.commons.lang3.StringUtils.*
import static vdr.jonglisto.util.Utils.*

class ChannelLogoSource implements StreamSource, Resource {

    val static filenames = Collections.synchronizedMap(new HashMap<String, String>());

    val String channelName
    var String filename

    new(String channelName) {
        this.channelName = channelName
    }

    def getImage() {
        using(getStream()) [
            if (it !== null) {
                val resource = new StreamResource(this, channelName + ".png");
                val image = new Image(null, resource)
                image.alternateText = channelName
                image.description = channelName
                return image
            } else {
                return null
            }
        ]
    }

    override getStream() {
        if (channelName.isNotEmpty) {
            // first check, if there already exists an entry in the cache
            if (filenames.containsKey(channelName)) {
                val fn = filenames.get(channelName);
                if (fn === null) {
                    return null;
                } else {
                    this.filename = fn
                    return this.getClass().getClassLoader().getResourceAsStream(fn);
                }
            }

            // create a new normalized filename and search the resource
            val filename = channelName.stripAccents //
                    .replaceAll("\\&", "and") //
                    .replaceAll("\\+", "plus") //
                    .replaceAll("\\*", "star");

            var filename2 = filename.replaceAll("[^A-Za-z0-9]", "").toLowerCase();

            var inputStream = this.getClass().getClassLoader().getResourceAsStream("/logo/" + filename2 + ".png");

            if (inputStream === null) {
                // try to find similar channel images
                filename2 = filename.replaceAll("\\w*\\(S\\)$", "").replaceAll("\\w*HD$", "").replaceAll("[^A-Za-z0-9]", "").toLowerCase();
                inputStream = this.getClass().getClassLoader().getResourceAsStream("/logo/" + filename2 + ".png");
            }

            // put data into cache
            if (inputStream !== null) {
                this.filename = "/logo/" + filename2 + ".png"
                filenames.put("channelName", filename);
            } else {
                filenames.put("channelName", null);
                this.filename = null
            }

            return inputStream;
        }

        return null
    }

    override getMIMEType() {
        return FileTypeResolver.getMIMEType(filename);
    }

}
