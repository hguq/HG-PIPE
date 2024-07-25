package block

import spinal.core._
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
import spinal.lib.bus.amba4.axis.{Axi4Stream, Axi4StreamConfig}
import spinal.lib.{StreamFifo, master, slave}

import scala.language.postfixOps

// Residual fifo, with stream interface
class Fifo(streamConfig: Axi4StreamConfig, depth: Int = 128) extends Component {

  val io = new Bundle {
    val i_stream: Axi4Stream = slave(Axi4Stream(streamConfig))
    val o_stream: Axi4Stream = master(Axi4Stream(streamConfig))
  }

  // create a local fifo
  val fifo: StreamFifo[Bits] = StreamFifo(Bits(8 * streamConfig.dataWidth bits), depth)
  // connect the fifo
  io.i_stream.ready <> fifo.io.push.ready
  io.i_stream.valid <> fifo.io.push.valid
  io.i_stream.payload.data <> fifo.io.push.payload

  io.o_stream.ready <> fifo.io.pop.ready
  io.o_stream.valid <> fifo.io.pop.valid
  io.o_stream.payload.data <> fifo.io.pop.payload
}
