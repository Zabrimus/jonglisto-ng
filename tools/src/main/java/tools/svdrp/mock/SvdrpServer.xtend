package tools.svdrp.mock

import java.io.IOException
import java.net.ServerSocket
import java.net.SocketTimeoutException
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class SvdrpServer implements Runnable {
	
	private int port
	private int executorCount
	private boolean running

	var ServerSocket serverSocket

	new(int port, int executorCount) {
		this.port = port
		this.executorCount = executorCount
		running = true	
	}	
	
	override run() {
        var ExecutorService executor
		
		try {
			serverSocket = new ServerSocket(port)
			serverSocket.soTimeout = 1000
			executor = Executors.newFixedThreadPool(executorCount);
			
			while (running) {
				try {
					val clientSocket = serverSocket.accept
					val worker = new SvdrpHandler(clientSocket)
					executor.execute(worker)					
				} catch (SocketTimeoutException e) {
					// do nothing. desired accept timeout
				}
			}
		} catch (IOException e) {
			System.out.println("Fail to start server")
			e.printStackTrace
		} finally {
			if (executor !== null) {
				executor.shutdown()
			}
			
			if (serverSocket !== null) {
				serverSocket.close
			}
		}
	}
	
	def void stopServer() {
		running = false
	}
}
