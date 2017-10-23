package tools.svdrp.mock

class Main {
	
	def static void main(String[] args) {
		// start server
		println("< start server...")
		val svdrpServer = new SvdrpServer(6000, 1)
		new Thread(svdrpServer).start
		
		Thread.sleep(30 * 1000)
		
		svdrpServer.stopServer 		
	}	
}
