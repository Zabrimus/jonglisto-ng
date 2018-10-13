package vdr.jonglisto.svdrp.server

import java.util.regex.Matcher
import java.util.regex.Pattern
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.VDR
import vdr.jonglisto.xtend.annotation.Log
import java.time.LocalDateTime
import vdr.jonglisto.svdrp.client.SvdrpClient

@Log("jonglisto.discovery")
class DiscoveryUtil {
    static Pattern p = Pattern.compile("(SVDRP:discover )?name:(.*?) port:(.*?) vdrversion:(.*?) apiversion:(.*?) timeout:(.*?)$");

    static def VDR findVdr(String ip, String request) {
        var VDR vdr;
        var int clientPort;
        var String clientName;
        var int timeout;

        // try to find VDR
        val Matcher m = p.matcher(request);
        if (m.matches) {
            clientPort = Integer.parseInt(m.group(3));
            clientName = m.group(2)
            timeout = Integer.parseInt(m.group(6))

            if (clientName.startsWith("jonglisto") || clientName.equals(Configuration.instance.discoveryServername)) {
                // ignoring loopback
                log.info("Ignore loopback UDP request for '{}'", clientName);
                return null;
            }

            var vdrOpt = Configuration.instance.findVdr(ip, clientPort);

            if (!vdrOpt.isPresent) {
                vdr = new VDR(clientName, ip, clientPort, timeout);

                Configuration.instance.addVdr(vdr)
                log.debug("Add discovered VDR {}", vdr)
            } else {
                vdr = vdrOpt.get
                vdr.timeout = timeout
            }

            vdr.discovered = true
            vdr.lastSeen = LocalDateTime.now

            // get list of plugins
            SvdrpClient.instance.fillPlugins(vdr)

            log.trace("Discovery of ip {}, clientPort {} results in {}", ip, clientPort, vdr)
        } else {
            log.debug("Received: '{}'", request)
        }

        return vdr;
    }

}
