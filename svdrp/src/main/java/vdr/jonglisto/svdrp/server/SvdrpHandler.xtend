package vdr.jonglisto.svdrp.server

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.Socket

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
					output.write("215-C C-9999-321-32104 sixx HD\n")
					output.write("215-E 4976 1502766300 900 50 7\n")
					output.write("215-T Sixx Quickie\n")
					output.write("215-D Magazin. Sixx Quickie versorgt euch t�glich mit Neuigkeiten aus der Mode- und Beautywelt, Lifestyle und Stars, Essenskultur und Reisen, und Dating und Sex.\n")
					output.write("215-G AF\n")
					output.write("215-e\n")
					output.write("215-E 4980 1502767200 1200 50 7\n")
					output.write("215-T Full House\n")
					output.write("215-S Sitcom. Nach seiner Hochzeit zieht Jesse zu Rebecca. Der Abschied von den Tanners f�llt ihm sichtlich schwer. Da hat Rebecca eine Idee.\n")
					output.write("215-D Jesse und Rebecca sind aus den Flitterwochen zur�ck und verk�nden, dass sie nun gemeinsam in Beckys Wohnung leben m�chten. Michelle kann die Welt nicht mehr verstehen: Wie soll sie ohne ihren Lieblingsonkel je wieder gl�cklich sein? Als das gl�ckliche Paar noch eine letzte Nacht im Haus der Tanners verbringt, hat Rebecca eine Idee. IMDb rating: 8.1/10.|Role Player: Bob Saget|Role Player: Candace Cameron Bure|Role Player: Jodie Sweetin\n")
					output.write("215-G 14\n")
					output.write("215-e\n")
					output.write("215 c\n")		
					output.flush			 
				}
				
				if ("LSTC :ids :groups" == commandLine) {
					output.write("250-0 :�R\n")
					output.write("250-1 C-41985-1051-11100 Das Erste HD;ARD:418000:C0M256:C:6900:6010=27:6020=deu@3,6021=mis@3;6022=deu@106:6030;6031=deu:0:11100:41985:1051:0\n")
					output.write("250-2 C-102-1079-11110 ZDF HD;ZDFvision:394000:C0M256:C:6900:6110=27:6120=deu@3,6121=mis@3,6123=mul@3;6122=deu@106:6130;6131=deu:0:11110:102:1079:0\n")
					output.write("250-0 :FreeTV\n")
					output.write("250 12 C-9999-161-12103 ProSieben;Unitymedia:442000:C0M256:C:6900:543=2:544=deu@3;546=deu@106:548:0:12103:9999:161:0\n")
					output.flush
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
