package vdr.jonglisto.svdrp.client

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.IOException
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.InetSocketAddress
import java.net.Socket
import java.util.List
import java.util.regex.Pattern
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.svdrp.client")
class Connection {
    static Pattern greetingPattern = Pattern.compile(".*?(\\d+\\.\\d+\\.\\d+);.*?;(.*?)$")

    Socket socket

    String host
    int port
    String version

    int readTimeout
    int connectTimeout

    BufferedWriter output
    BufferedReader input

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
        log.debug("connect to {}:{}", host, port)

        try {
            // connect to VDR
            socket = new Socket();
            val sa = new InetSocketAddress(host, port);

            socket.connect(sa, connectTimeout);
            socket.setSoTimeout(readTimeout);

            output = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"), 8192);
            input = new BufferedReader(new InputStreamReader(socket.getInputStream(), "UTF-8"), 8192);

            // read greeting
            var response = readResponse

            if (response.code != 220) {
                throw new RuntimeException("Code != 220")
            }

            val greet = response.lines.get(0)
            val matcher = greetingPattern.matcher(greet);
            if (!matcher.matches) {
                throw new RuntimeException("Greeting error? " + greet)
            }

            // check encoding
            val encoding = matcher.group(2).trim
            if ("UTF-8" != encoding) {
                // re-init input/output
                output = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), encoding), 8192);
                input = new BufferedReader(new InputStreamReader(socket.getInputStream(), encoding), 8192);
            }

            version = matcher.group(1)

            return matcher.group(1)
        } catch (Exception e) {
            throw new RuntimeException("connection failed: " + host + ":" + port)
        }
    }

    def String getVersion() {
        return version;
    }

    def Response close() {
        val response = send("QUIT")

        if (input !== null) {
            try {
                input.close
            } catch (IOException exc) {
                // ignore
            }
        }

        if (output !== null) {
            try {
                output.close
            } catch (IOException exc) {
                // ignore
            }
        }

        if (socket !== null) {
            try {
                socket.close
            } catch (IOException exc) {
                // ignore
            }
        }

        return response
    }

    def Response send(String command) {
        try {
            output.write(command.replaceAll("\n", "|"))
            output.newLine
            output.flush

            val rsp = readResponse
            rsp.clientSocket = socket

            return rsp
        } catch (IOException e) {
            // connection is broken -> invalidate
            SvdrpClient.getInstance().invalidateConnection(this)
            throw new ConnectionException(e.getMessage)
        }
    }

    def Response sendBatch(List<String> command) {
        try {
            for (var i = 0; i < command.size; i++) {
                val s = command.get(i)
                output.write(s.replaceAll("\n", "|"))
                output.newLine
            }
            output.flush

            return readResponse
        } catch (IOException e) {
            // connection is broken -> invalidate
            SvdrpClient.getInstance().invalidateConnection(this)
            throw new ConnectionException(e.getMessage)
        }
    }

    def Response sendBatchRawEpg(List<String> command) {
        try {
            for (var i = 0; i < command.size; i++) {
                output.write(command.get(i))
                output.newLine

                if (i % 2000 == 0) {
                    output.flush
                }
            }

            output.write(".")
            output.newLine

            output.flush

            return readResponse
        } catch (IOException e) {
            // connection is broken -> invalidate
            SvdrpClient.getInstance().invalidateConnection(this)
            throw new ConnectionException(e.getMessage)
        }
    }

    def getSocket() {
        socket
    }

    private def Response readResponse() throws IOException {
        var reading = true
        var String line
        val response = new Response

        while (reading && (line = input.readLine()) !== null) {
            // more lines?
            reading = line.charAt(3) == '-'.charAt(0)

            if (response.code == 0) {
                response.code = Integer.valueOf(line.substring(0, 3))
            }

            // extract data
            response.lines += line.substring(4)
        }

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

        val other = obj as Connection;
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
