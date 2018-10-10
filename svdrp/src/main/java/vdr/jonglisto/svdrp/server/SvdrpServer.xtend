package vdr.jonglisto.svdrp.server

import java.io.IOException
import java.net.ServerSocket
import java.net.SocketTimeoutException
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import vdr.jonglisto.xtend.annotation.Log
import java.util.concurrent.ThreadPoolExecutor

@Log("jonglisto.svdrp.server")
class SvdrpServer implements Runnable {

    int port
    int executorCount
    boolean running

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
                log.info("IN RUNNING")

                try {
                    val clientSocket = serverSocket.accept
                    val worker = new SvdrpHandler(clientSocket)
                    executor.execute(worker)

                    log.error("------ Print Queue start")
                    val ex = executor as ThreadPoolExecutor
                    ex.queue.forEach[q | {
                        log.error("Queue: " + q)
                    }]
                    log.error("------ Print Queue end")

                } catch (SocketTimeoutException e) {
                    // do nothing. accept timeout
                }
            }

            log.info("IN RUNNING END")
        } catch (IOException e) {
            log.error("Failed to start svdrp server", e)
        } finally {
            if (executor !== null) {
                executor.shutdown()
            }

            if (serverSocket !== null) {
                try {
                    serverSocket.close
                } catch (IOException exc) {
                    // ignore
                }
            }
        }
    }

    def void stopServer() {
        log.info("STOP CALLED")
        running = false
    }
}
