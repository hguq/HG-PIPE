package dfs_server

import java.net.{ServerSocket, Socket}
import java.io.{BufferedWriter, DataInputStream, DataOutputStream, File, FileWriter}
import java.util.concurrent.Executors

import network.simulate_block_sequence

object simulate_thread_func {
  def apply(residual_id: Int): Int = {
    val start_time = System.nanoTime()
    val latency = try {
      simulate_block_sequence(20, residual_id, residual_id, until_stable = true) // 20 might be enough for stable
    } catch {
      case e: spinal.sim.SimFailure =>
        println(Console.RED + s"*** SimFailure: ${e.getMessage} ***" + Console.RESET)
        BigInt(1000000)
    }
    val outputFile = new File(s"latency/$residual_id.txt")
    val bw = new BufferedWriter(new FileWriter(outputFile))
    bw.write(latency.toString)
    bw.close()
    val end_time = System.nanoTime()
    println(s"This is residual $residual_id")
    println(Console.BLUE + s"*** Total time is ${(end_time - start_time) / 1e9} seconds ***" + Console.RESET)
    latency.toInt
  }
}

object launch_spinal_server extends App {
  val serverSocket = new ServerSocket(9966)
  val pool = Executors.newFixedThreadPool(32) // create thread pool

  while (true) {
    val clientSocket = serverSocket.accept()
    pool.execute(new ClientHandler(clientSocket))
  }
}

class ClientHandler(socket: Socket) extends Runnable {
  override def run(): Unit = {
    try {
      val inputStream = new DataInputStream(socket.getInputStream)
      val outputStream = new DataOutputStream(socket.getOutputStream)

      val number = inputStream.readInt() // read number from client
      println(s"Received number: $number")

      val result = simulate_thread_func(number)

      println(s"Result: $result")
      outputStream.writeChars("") // send result back to client, by writing to file
      socket.close()
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }
}

