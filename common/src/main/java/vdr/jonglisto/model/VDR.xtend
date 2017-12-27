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

    var String hostAddress

    new(String name, String host, Integer port, String instanceName) {
        this.name = name
        this.host = host
        this.port = port
        this.instance = instanceName
    }

    new(String name, String host, Integer port, int readTimeout, int connectTimeout, String instanceName) {
        this.name = name
        this.host = host
        this.port = port
        this.readTimeout = readTimeout
        this.connectTimeout = connectTimeout
        this.instance = instanceName
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

    override def int hashCode() {
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

    override def boolean equals(Object obj) {
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
