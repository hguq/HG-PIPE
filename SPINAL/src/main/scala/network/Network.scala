package network

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite.{AxiLite4, AxiLite4SpecRenamer}
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
import spinal.lib.bus.amba4.axis._


import block._

class Network extends Component {
  val residual_seq = new BlockSequence(BlockCfg.FIRST_ID, BlockCfg.LAST_ID)

  val io = new Bundle {
    val i_stream: Axi4Stream = slave(Axi4Stream(residual_seq.io.i_stream.config))
    val o_stream: Axi4Stream = master(Axi4Stream(residual_seq.io.o_stream.config))

    val residuals_axilite: AxiLite4 = slave(AxiLite4(residual_seq.io.axilite.config))
  }

  // rename it
  noIoPrefix()
  AxiLite4SpecRenamer(io.residuals_axilite)
  Axi4StreamSpecRenamer(io.i_stream)
  Axi4StreamSpecRenamer(io.o_stream)

  // set top name
  setDefinitionName("Network")

  // connect axi lite
  io.residuals_axilite <> residual_seq.io.axilite

  // connect axi stream
  io.i_stream <> residual_seq.io.i_stream
  io.o_stream <> residual_seq.io.o_stream
}

object gen_network_verilog extends App {
  val spinalConfig: SpinalConfig = SpinalConfig(
    mode = Verilog,
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = ASYNC,
      resetActiveLevel = LOW
    )
  )
  spinalConfig.generate(new Network).mergeRTLSource()
}
