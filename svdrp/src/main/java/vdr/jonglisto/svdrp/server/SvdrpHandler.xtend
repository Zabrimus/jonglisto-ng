package vdr.jonglisto.svdrp.server

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.Socket
import vdr.jonglisto.xtend.annotation.Log

@Log
class SvdrpHandler implements Runnable {

    var Socket client

    new(Socket client) {
        this.client = client
    }

    override run() {
        var BufferedReader input
        var BufferedWriter output

        log.fine("> New connection: " + client + ", " + client.inetAddress.hostAddress)

        try {
            input = new BufferedReader(new InputStreamReader(client.getInputStream()))
            output = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()))

            // send greeting
            output.write("220 jonglisto SVDRP VideoDiskRecorder 2.4.0; Mon Jan 01 10:00:00 2018; UTF-8\n");
            output.flush();

            // read command
            var String commandLine
            while ((commandLine = input.readLine()) !== null) {
                log.fine("> Received command: " + commandLine)

                if (commandLine.toUpperCase().startsWith("FAVC")) {

                } else if (commandLine.toUpperCase().startsWith("QUIT")) {
                    output.write("221 jonglisto closing connection\n")
                    output.flush
                    output.close
                    input.close
                    client.close

                    return;
                } else {
                    // unkown command
                    output.write("221 unkown command\n")
                    output.flush
                    output.close
                    input.close
                    client.close

                    return;
                }
            }
        } finally {
            if (input !== null) {
                input.close
            }

            if (output !== null) {
                output.close
            }
        }
    }
}
