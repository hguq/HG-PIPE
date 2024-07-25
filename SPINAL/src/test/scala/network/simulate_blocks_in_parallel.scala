package network

import java.io.{BufferedWriter, File, FileWriter}
import java.util.concurrent.{Callable, Executors}

object simulate_blocks_in_parallel extends App {

  val numThreads = 32 // Define the number of threads to use
  val threadPool = Executors.newFixedThreadPool(numThreads)

  // select some blocks
  // cannot parallel simulate all blocks, the reason is unknown
  val selected_ids = -1 to 24

  // get start time
  val start_time = System.nanoTime()

  val futures = for (id <- selected_ids) yield {
    threadPool.submit(
      new Callable[BigInt] {
        // use try catch to avoid exception
        // since there might be deadlock
        def call(): BigInt = {
          try {
            simulate_block_sequence(10, id, id, until_stable = true)
          } catch {
            case _: Exception =>
              println(Console.RED + s"*** Residual $id failed ***" + Console.RESET)
              BigInt(1000000000)
          }
        }
      }
    )

  }

  // Wait for all the futures to complete and collect the results
  val results = selected_ids.zip(futures.map(future => future.get())).toMap
  threadPool.shutdown()
  for (id <- selected_ids) {
    val latency = results(id)
    val outputFile = new File(s"latency/$id.txt")
    val bw = new BufferedWriter(new FileWriter(outputFile))
    bw.write(latency.toString)
    bw.close()
  }

  val end_time = System.nanoTime()

  // save max latency
  val max_latency = results.values.max
  val outputFile = new File(s"latency/max.txt")
  val bw = new BufferedWriter(new FileWriter(outputFile))
  bw.write(max_latency.toString)
  bw.close()

  // print in seconds, and BLUE
  println(Console.BLUE + s"*** Total time is ${(end_time - start_time) / 1e9} seconds ***" + Console.RESET)
  println(Console.BLUE + s"*** Max latency is $max_latency ***" + Console.RESET)
}
