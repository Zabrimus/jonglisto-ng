package vdr.jonglisto.model

import java.net.InetAddress
import java.net.UnknownHostException
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@EqualsHashCode
@ToString
class VDR extends BaseData {
    var String host
    var Integer port
    var int readTimeout = -1
    var int connectTimeout = -1
    var String name
    var String uuid

    var String hostAddress

    new(String name, String host, Integer port) {
        this.name = name
        this.host = host
        this.port = port
    }

    new(String name, String host, Integer port, int readTimeout, int connectTimeout) {
        this.name = name
        this.host = host
        this.port = port
        this.readTimeout = readTimeout
        this.connectTimeout = connectTimeout
    }

    def getIp() {
        if (hostAddress === null && host !== null) {
            try {
                hostAddress = InetAddress.getByName(host).hostAddress
            } catch (UnknownHostException e) {
                return null
            }
        }

        return hostAddress
    }
}
