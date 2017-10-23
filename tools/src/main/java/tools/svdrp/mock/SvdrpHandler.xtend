package tools.svdrp.mock

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStream
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.Socket
import java.util.ArrayList
import java.util.List

class SvdrpHandler implements Runnable {
	
	var Socket client
	
	new(Socket client) {
		this.client = client	
	}
	
	override run() {
		var BufferedReader input
		var BufferedWriter output
		
		println("> New connection: " + client + ", " + client.inetAddress.hostAddress)
		
		try {
			input  = new BufferedReader(new InputStreamReader(client.getInputStream()))
			output = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()))
			
			// send greeting
			output.write("220 jonglisto SVDRP VideoDiskRecorder 2.4.0; Sun Dec 31 10:00:00 2016; UTF-8\n");
            output.flush();
            
            // read command
            var String commandLine
            while ((commandLine = input.readLine()) !== null) {
				println("> Received command: " + commandLine)
				
				if ("QUIT" == commandLine) {
                    output.write("221 jonglisto closing connection\n")
                    output.flush
                    output.close
                    input.close                    
                    client.close

                    return;
				}	
				
				if ("LSTE" == commandLine) {
				    "/epg.txt".copy(output, "215")
				}
				
				if ("LSTC :ids :groups" == commandLine) {
				    "/channel.txt".copy(output, "250")
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

    private def copy(String filename, BufferedWriter output, String code) {
        SvdrpHandler.getResourceAsStream(filename).readFromInputStream.write(output, code)
    }

    private def write(List<String> lines, BufferedWriter output, String code) {
        lines.forEach[ line, index |
            output.write(code + (if (index == lines.size - 1) " " else "-") + line)            
        ]
        output.flush
    }
	
    private def List<String> readFromInputStream(InputStream inputStream) {
        val result = new ArrayList<String>()
        
        try {
            val br = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            var String line

            while ((line = br.readLine()) !== null) {
                result.add(line)                
            }
        } catch (Exception e) {
            e.printStackTrace
        }
        
        return result
    }
	
}
