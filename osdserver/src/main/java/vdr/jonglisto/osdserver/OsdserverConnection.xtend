package vdr.jonglisto.osdserver

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.InetSocketAddress
import java.net.Socket
import java.net.SocketException
import java.util.regex.Pattern
import vdr.jonglisto.xtend.annotation.Log

@Log
class OsdserverConnection {

    private static Pattern greetingPattern = Pattern.compile("Welcome to OSDServer version (\\d.\\d.\\d), VDR version (\\d.\\d.\\d).")

    private Socket socket

    private String host
    private int port

    private int readTimeout
    private int connectTimeout

    private BufferedWriter output
    private BufferedReader input

    new(String host, int port) {
        this(host, port, 0, 500)
    }

    new(String host, int port, int readTimeout, int connectTimeout) {
        this.host = host
        this.port = port

        if (readTimeout == -1) {
            this.readTimeout = 0
        } else {
            this.readTimeout = readTimeout
        }

        if (connectTimeout == -1) {
            this.connectTimeout = 500
        } else {
            this.connectTimeout = connectTimeout
        }
    }

    def String connect() {
        // connect to VDR osdserver
        socket = new Socket();
        val sa = new InetSocketAddress(host, port);

        socket.connect(sa, connectTimeout);
        socket.setSoTimeout(readTimeout);

        output = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"), 8192);
        input = new BufferedReader(new InputStreamReader(socket.getInputStream(), "UTF-8"), 8192);

        // read greeting
        var response = readResponse

        if (response.code != 201) {
            throw new RuntimeException("Code != 201")
        }

        val matcher = greetingPattern.matcher(response.message);
        if (!matcher.matches) {
            throw new RuntimeException("Greeting error? " + response.message)
        }

        response = send("Version 0.1")
        if (response.code != 200) {
            throw new RuntimeException("Version error? " + response.message)
        }

        return response.message
    }

    def OsdserverResponse close() {
        val response = send("QUIT")

        if (input !== null) {
            input.close
        }

        if (output !== null) {
            output.close
        }

        if (socket !== null) {
            socket.close
        }

        return response
    }

    def OsdserverResponse send(String command, int desiredCode) {
        val resp = send(command)

        if (resp.code != desiredCode) {
            throw new RuntimeException("osdserver: DesiredCode="+ desiredCode + " but got " + resp)
        }

        return resp
    }

    def OsdserverResponse send(String command) {
        try {
            log.fine("> " + command)
            output.write(command)
            output.newLine
            output.flush
        } catch (SocketException e) {
            throw new RuntimeException(e.getMessage)
        }

        return readResponse
    }

    def OsdserverResponse readResponse() {
        var response = new OsdserverResponse
        var String line

        if((line = input.readLine()) !== null) {
            response.code = Integer.valueOf(line.substring(0, 3))
            response.message = line.substring(4)
        } else {
            response.code = 0
            response.message = "No Response"
        }

        log.fine("< " + line)

        return response
    }

    override int hashCode() {
        val prime = 31
        var result = 1
        result = prime * result + (if(host === null) 0 else host.hashCode())
        result = prime * result + port;

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

        val other = obj as OsdserverConnection;
        if (host === null) {
            if (other.host !== null) {
                return false;
            }
        } else if (!host.equals(other.host)) {
            return false;
        }

        if (port != other.port) {
            return false;
        }

        return true;
    }
}
