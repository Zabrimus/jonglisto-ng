package vdr.jonglisto.model

import java.net.InetAddress
import java.net.UnknownHostException
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.ToString

@Accessors
@ToString
class VDR extends BaseData {
    var String host
    var Integer port
    var int readTimeout = -1
    var int connectTimeout = -1
    var String name
    var String uuid
    var String instance
    var String mac

    var String hostAddress

    new(String name, String host, Integer port, String instanceName, String mac) {
        this.name = name
        this.host = host
        this.port = port
        this.instance = instanceName
        this.mac = mac
    }

    new(String name, String host, Integer port, int readTimeout) {
        this.name = name
        this.host = host
        this.port = port
        this.instance = name
        this.mac = mac
    }

    new(String name, String host, Integer port, int readTimeout, String mac, int connectTimeout, String instanceName) {
        this.name = name
        this.host = host
        this.port = port
        this.readTimeout = readTimeout
        this.connectTimeout = connectTimeout
        this.instance = instanceName
        this.mac = mac
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

    override int hashCode() {
        val prime = 31;
        var result = 1;

        if (host === null) {
            result = prime * result
        } else {
            result = prime * result + host.hashCode();
        }

        if (port === null) {
            result = prime * result
        } else {
            result = prime * result + port.hashCode();
        }

        return result;
    }

    override boolean equals(Object obj) {
        if (this === obj) {
            return true;
        }

        if (obj === null) {
            return false;
        }

        if (getClass() != obj.getClass()) {
            return false;
        }

        val other = obj as VDR;
        if (host === null) {
            if (other.host !== null) {
                return false;
            }
        } else if (!host.equals(other.host)) {
            return false;
        }

        if (port === null) {
            if (other.port !== null) {
                return false;
            }
        } else if (!port.equals(other.port)) {
            return false;
        }

        return true;
    }

}
