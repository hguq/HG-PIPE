package fc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite.AxiLite4
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream
import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

class FCBlackBox extends BlackBox {
  setDefinitionName("FC_SAXILITE")
  val io = new Bundle {
    // axi lite interface
    val s_axi_ctrl_AWVALID: Bool = in Bool()
    val s_axi_ctrl_AWREADY: Bool = out Bool()
    val s_axi_ctrl_AWADDR: UInt = in UInt (fc_cfg.axilite_addr_width bits)
    val s_axi_ctrl_WVALID: Bool = in Bool()
    val s_axi_ctrl_WREADY: Bool = out Bool()
    val s_axi_ctrl_WDATA: Bits = in Bits (fc_cfg.axilite_data_width bits)
    val s_axi_ctrl_WSTRB: Bits = in Bits (fc_cfg.axilite_data_width / 8 bits)
    val s_axi_ctrl_ARVALID: Bool = in Bool()
    val s_axi_ctrl_ARREADY: Bool = out Bool()
    val s_axi_ctrl_ARADDR: UInt = in UInt (fc_cfg.axilite_addr_width bits)
    val s_axi_ctrl_RVALID: Bool = out Bool()
    val s_axi_ctrl_RREADY: Bool = in Bool()
    val s_axi_ctrl_RDATA: Bits = out Bits (fc_cfg.axilite_data_width bits)
    val s_axi_ctrl_RRESP: Bits = out Bits (2 bits)
    val s_axi_ctrl_BVALID: Bool = out Bool()
    val s_axi_ctrl_BREADY: Bool = in Bool()
    val s_axi_ctrl_BRESP: Bits = out Bits (2 bits)

    // axi stream interface
    val i_stream_TDATA: Bits = in Bits (fc_cfg.DATAWIDTH_I bits)
    val o_stream_TDATA: Bits = out Bits (fc_cfg.DATAWIDTH_O bits)
    val o_stream_TKEEP: Bits = out Bits (fc_cfg.DATAWIDTH_O / 8 bits)
    val o_stream_TSTRB: Bits = out Bits (fc_cfg.DATAWIDTH_O / 8 bits)
    val o_stream_TLAST: Bool = out Bool()
    val i_stream_TVALID: Bool = in Bool()
    val i_stream_TREADY: Bool = out Bool()
    val o_stream_TVALID: Bool = out Bool()
    val o_stream_TREADY: Bool = in Bool()

    // ap_hs interface
    // since the weight must be configured through axilite, don't use ap_hs
    //    val ap_start: Bool = in Bool()
    //    val ap_continue: Bool = in Bool()
    //    val ap_done: Bool = out Bool()
    //    val ap_ready: Bool = out Bool()
    //    val ap_idle: Bool = out Bool()

    // clock and reset
    val ap_clk: Bool = in Bool()
    val ap_rst_n: Bool = in Bool()
    val interrupt: Bool = out Bool()
  }

  // no io prefix, only with accurate name, can the module be mapped to blackbox
  noIoPrefix()
  // map clock domain, reset is active low
  mapClockDomain(clock = io.ap_clk, reset = io.ap_rst_n, resetActiveLevel = LOW)
  // add RTL code
  println(s"Working Directory = ${System.getProperty("user.dir")}")
  val rtlFilePath: String = s"src/main/verilog/FC_SAXILITE"
  addRTLPath(rtlFilePath + "/all.v")
}

class FC extends Component {

  val iStreamConfig: Axi4StreamConfig = fc_cfg.iStreamConfig()
  val oStreamConfig: Axi4StreamConfig = fc_cfg.oStreamConfig(useLast = true)

  val io = new Bundle {
    // axi lite interface
    val axilite: AxiLite4 = slave(AxiLite4(addressWidth = fc_cfg.axilite_addr_width, dataWidth = fc_cfg.axilite_data_width))
    // axi stream interface
    val i_stream: Axi4Stream = slave(Axi4Stream(iStreamConfig))
    val o_stream: Axi4Stream = master(Axi4Stream(oStreamConfig))
  }

  val linear = new FCBlackBox()

  // connect io
  // AW
  io.axilite.aw.valid <> linear.io.s_axi_ctrl_AWVALID
  io.axilite.aw.ready <> linear.io.s_axi_ctrl_AWREADY
  io.axilite.aw.addr <> linear.io.s_axi_ctrl_AWADDR
  // W
  io.axilite.w.valid <> linear.io.s_axi_ctrl_WVALID
  io.axilite.w.ready <> linear.io.s_axi_ctrl_WREADY
  io.axilite.w.data <> linear.io.s_axi_ctrl_WDATA
  io.axilite.w.strb <> linear.io.s_axi_ctrl_WSTRB
  // AR
  io.axilite.ar.valid <> linear.io.s_axi_ctrl_ARVALID
  io.axilite.ar.ready <> linear.io.s_axi_ctrl_ARREADY
  io.axilite.ar.addr <> linear.io.s_axi_ctrl_ARADDR
  // R
  io.axilite.r.valid <> linear.io.s_axi_ctrl_RVALID
  io.axilite.r.ready <> linear.io.s_axi_ctrl_RREADY
  io.axilite.r.data <> linear.io.s_axi_ctrl_RDATA
  io.axilite.r.resp <> linear.io.s_axi_ctrl_RRESP
  // B
  io.axilite.b.valid <> linear.io.s_axi_ctrl_BVALID
  io.axilite.b.ready <> linear.io.s_axi_ctrl_BREADY
  io.axilite.b.resp <> linear.io.s_axi_ctrl_BRESP

  // axi stream
  io.i_stream.valid <> linear.io.i_stream_TVALID
  io.i_stream.ready <> linear.io.i_stream_TREADY
  io.i_stream.payload.data <> linear.io.i_stream_TDATA

  io.o_stream.valid <> linear.io.o_stream_TVALID
  io.o_stream.ready <> linear.io.o_stream_TREADY
  io.o_stream.payload.data <> linear.io.o_stream_TDATA
  io.o_stream.payload.last <> linear.io.o_stream_TLAST
  //  io.o_stream.payload.keep <> linear.io.o_stream_TKEEP // not used
  //  io.o_stream.payload.strb <> linear.io.o_stream_TSTRB // not used
}
