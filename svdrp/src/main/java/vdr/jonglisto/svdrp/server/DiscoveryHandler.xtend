package vdr.jonglisto.svdrp.server

import java.util.regex.Matcher
import java.util.regex.Pattern
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.xtend.annotation.Log
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient

@Log("discovery")
class DiscoveryHandler {

    Pattern p = Pattern.compile("SVDRP:discover name:(.*?) port:(.*?) vdrversion:(.*?) apiversion:(.*?) timeout:(.*?)$");

    def VDR process(String ip, String request) {
        var VDR vdr;
        var int clientPort;
        var String clientName;
        var int timeout;

        // try to find VDR
        val Matcher m = p.matcher(request);
        if (m.matches) {
            clientPort = Integer.parseInt(m.group(2));
            clientName = m.group(1)
            timeout = Integer.parseInt(m.group(5))

            if (clientName.startsWith("jonglisto") || clientName.equals(Configuration.instance.discoveryServername)) {
                // ignoring loopback
                log.info("Ignore loopback UDP request for '" + clientName + "'");
                return null;
            }

            var vdrOpt = Configuration.instance.findVdr(ip, clientPort);

            if (!vdrOpt.isPresent) {
                vdr = new VDR(clientName, ip, clientPort, timeout);
            } else {
                vdr = vdrOpt.get
            }

            try {
                SvdrpClient.instance.sendConn(vdr)
            } catch (Exception e) {
                log.info("Discovery request received, but connection to " + ip + ":" + clientPort + " (" + clientName + ") failed")
                vdr = null
            }
        }

        return vdr;
    }
}
