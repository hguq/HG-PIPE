package block

import spinal.core._
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
import spinal.lib.bus.amba4.axis._
import spinal.lib._

import scala.language.postfixOps

import ctrl.ApChain

class BlockBlackBox(ID: Int) extends BlackBox {
  // create config
  val iStreamConfig: Axi4StreamConfig = BlockCfg.iStreamConfig(ID)
  val oStreamConfig: Axi4StreamConfig = BlockCfg.oStreamConfig(ID)

  // rename this module, this renaming is essential, to match the name in verilog
  private val top_type: String = BlockCfg.BLOCK_TYPES(ID)
  private val top_number: String = if (ID == BlockCfg.FIRST_ID || ID == BlockCfg.LAST_ID) "" else (ID / 2).toString
  private val top_name: String = s"$top_type$top_number"
  setDefinitionName(top_name)

  val io = new Bundle {
    // ap_hs interface
    val ap_start: Bool = in Bool()
    val ap_continue: Bool = in Bool()
    val ap_done: Bool = out Bool()
    val ap_ready: Bool = out Bool()
    val ap_idle: Bool = out Bool()

    // axi stream interface
    val i_stream_TDATA: Bits = in Bits (8 * iStreamConfig.dataWidth bits)
    val i_stream_TREADY: Bool = out Bool()
    val i_stream_TVALID: Bool = in Bool()

    val o_stream_TDATA: Bits = out Bits (8 * oStreamConfig.dataWidth bits)
    val o_stream_TREADY: Bool = in Bool()
    val o_stream_TVALID: Bool = out Bool()

    // clock and reset
    val ap_clk: Bool = in Bool()
    val ap_rst_n: Bool = in Bool()
  }

  noIoPrefix()
  // map clock domain, reset is active low
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  // add RTL code
  val rtlFilePath: String = s"src/main/verilog/$top_name"
  addRTLPath(rtlFilePath + "/all.v")
}


class Block(ID: Int) extends Component {

  val iStreamConfig: Axi4StreamConfig = BlockCfg.iStreamConfig(ID)
  val oStreamConfig: Axi4StreamConfig = BlockCfg.oStreamConfig(ID)

  val io = new Bundle {
    // ap_hs interface
    val ap_chain: ApChain = slave(ApChain())
    // axi stream interface
    val i_stream: Axi4Stream = slave(Axi4Stream(iStreamConfig))
    val o_stream: Axi4Stream = master(Axi4Stream(oStreamConfig))
  }

  // instantiate the black box
  val black_box = new BlockBlackBox(ID)
  // connect ap_hs interface
  black_box.io.ap_start <> io.ap_chain.ap_start
  black_box.io.ap_continue <> io.ap_chain.ap_continue
  black_box.io.ap_done <> io.ap_chain.ap_done
  black_box.io.ap_ready <> io.ap_chain.ap_ready
  black_box.io.ap_idle <> io.ap_chain.ap_idle

  // connect axi stream interface
  black_box.io.i_stream_TDATA <> io.i_stream.data
  black_box.io.i_stream_TREADY <> io.i_stream.ready
  black_box.io.i_stream_TVALID <> io.i_stream.valid
  black_box.io.o_stream_TDATA <> io.o_stream.data
  black_box.io.o_stream_TREADY <> io.o_stream.ready
  black_box.io.o_stream_TVALID <> io.o_stream.valid
}
