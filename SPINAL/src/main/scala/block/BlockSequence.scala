package block

import ctrl.{Controller, Manager, ctrl_cfg}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite.{AxiLite4, AxiLite4SpecRenamer}
import spinal.lib.bus.amba4.axis.Axi4Stream._
import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

class BlockSequence(StartID: Int, EndID: Int) extends Component {

  val iStreamConfig: Axi4StreamConfig = BlockCfg.iStreamConfig(StartID)
  val oStreamConfig: Axi4StreamConfig = BlockCfg.oStreamConfig(EndID, useLast = true)

  val io = new Bundle {
    // axi lite interface
    val axilite: AxiLite4 = slave(AxiLite4(addressWidth = ctrl_cfg.axilite_addr_width, dataWidth = ctrl_cfg.axilite_data_width))
    // axi stream interface
    val i_stream: Axi4Stream = slave(Axi4Stream(iStreamConfig))
    val o_stream: Axi4Stream = master(Axi4Stream(oStreamConfig))
  }

  noIoPrefix()
  AxiLite4SpecRenamer(io.axilite)

  val controller: Controller = new Controller(EndID)
  controller.io.axilite <> io.axilite

  val blocks: Map[Int, Block] = (StartID to EndID).map(i => i -> new Block(i)).toMap
  val managers: Map[Int, Manager] = (StartID to EndID).map(i => i -> new Manager).toMap
  val fifos: Map[Int, Fifo] = (StartID until EndID).map(i => i -> new Fifo(blocks(i).io.o_stream.config)).toMap
  // chain
  controller.io.signals <> managers(StartID).io.signals.I
  (StartID until EndID).foreach(i => managers(i).io.signals.O <> managers(i + 1).io.signals.I)
  (StartID to EndID).foreach(i => managers(i).io.ap_chain <> blocks(i).io.ap_chain)

  // fifo chain
  io.i_stream <> blocks(StartID).io.i_stream
  (StartID until EndID).foreach(i => fifos(i).io.i_stream <> blocks(i).io.o_stream)
  (StartID until EndID).foreach(i => fifos(i).io.o_stream <> blocks(i + 1).io.i_stream)
  blocks(EndID).io.o_stream <> controller.io.i_stream
  controller.io.o_stream <> io.o_stream
}


object gen_block_sequence_verilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new BlockSequence(BlockCfg.FIRST_ID, BlockCfg.LAST_ID)).mergeRTLSource()
  }
}
