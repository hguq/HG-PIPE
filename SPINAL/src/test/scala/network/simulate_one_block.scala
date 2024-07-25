package network

object simulate_one_block extends App {
  val begin_id = -1
  val close_id = 24
  val start_time = System.nanoTime()
  val latency = simulate_block_sequence(10, begin_id, close_id, until_stable = false, display = true)
  val end_time = System.nanoTime()
  println(Console.BLUE + s"*** Total time is ${(end_time - start_time) / 1e9} seconds ***" + Console.RESET)
  println(Console.BLUE + s"*** Latency is $latency ***" + Console.RESET)
}
