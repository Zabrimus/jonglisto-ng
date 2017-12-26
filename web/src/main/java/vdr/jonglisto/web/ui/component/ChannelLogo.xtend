package vdr.jonglisto.web.ui.component

import com.vaadin.server.ThemeResource
import com.vaadin.server.VaadinServlet
import com.vaadin.shared.ui.ContentMode
import com.vaadin.ui.Image
import java.nio.file.Files
import java.nio.file.Paths
import java.util.HashMap
import java.util.Map
import java.util.Set
import java.util.stream.Collectors
import javax.enterprise.context.ApplicationScoped
import vdr.jonglisto.web.util.HtmlSanitizer

import static extension org.apache.commons.lang3.StringUtils.*

@ApplicationScoped
class ChannelLogo {

    var static Set<String> logoFiles
    var static Map<String, String> logoFileMapping = new HashMap<String, String>

    new() {
        // read all existing channel logos
        val webInfPath = VaadinServlet.getCurrent().getServletContext().getRealPath("/VAADIN/themes/jonglisto/channellogo");
        logoFiles = Files.list(Paths.get(webInfPath)).map(s | s.getFileName.toString).collect(Collectors.toSet())
    }

    def getImage(String channelName) {
        // check if mapping already exists
        var fn = logoFileMapping.get(channelName)
        if (fn !== null) {
            return getImageResource(fn, channelName)
        }

        // if the key exists, then return null
        if (logoFileMapping.containsKey(channelName)) {
            return null;
        }

        // try to find the image
        var filename = channelName.stripAccents //
                .replaceAll("\\&", "and") //
                .replaceAll("\\+", "plus") //
                .replaceAll("\\*", "star");

        var filename2 = filename.replaceAll("[^A-Za-z0-9]", "").toLowerCase();
        if (logoFiles.contains(filename2 + ".png")) {
            // insert mapping and return image
            logoFileMapping.put(channelName, filename2)
            return getImageResource(filename2, channelName)
        }

        // try to find similar channel images
        filename2 = filename.replaceAll("\\w*\\(S\\)$", "").replaceAll("\\w*HD$", "").replaceAll("[^A-Za-z0-9]", "").toLowerCase();
        if (logoFiles.contains(filename2 + ".png")) {
            // insert mapping and return image
            logoFileMapping.put(channelName, filename2)
            return getImageResource(filename2, channelName)
        }

        // not found -> return null
        logoFileMapping.put(channelName, null)
        return null;
    }

    private def getImageResource(String fileName, String channelName) {
        val resource = new ThemeResource("channellogo/" + fileName + ".png")
        val image = new Image(null, resource)
        image.alternateText = channelName

        image.setDescription("<h2>" + HtmlSanitizer.clean(channelName) + "</h2>", ContentMode.HTML)

        return image
    }
}
