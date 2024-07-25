package fc

import spinal.lib.bus.amba4.axis._

import scala.language.postfixOps

object fc_cfg {

  val DATAWIDTH_I: Int = 8 // unsigned 8bit
  val DATAWIDTH_O: Int = 64 // system type

  // shape of input and output
  val CO = 1000
  val CI = 1280

  val COP = 10
  val CIP = 4 // 因为一直调不出完美的数据，只能先这样了。
  //  val CIP = 5 // 因为一直调不出完美的数据，只能先这样了。

  val CIT: Int = CI / CIP
  val COT: Int = CO / COP

  // wrap input and output stream config, with optional last signal
  def iStreamConfig(): Axi4StreamConfig = {
    Axi4StreamConfig(
      dataWidth = DATAWIDTH_I / 8,
      useLast = false,
      useStrb = false,
      useKeep = false
    )
  }

  def oStreamConfig(useLast: Boolean = false): Axi4StreamConfig = {
    Axi4StreamConfig(
      dataWidth = DATAWIDTH_O / 8,
      useLast = useLast,
      useStrb = false, // don't use strb
      useKeep = false
    )
  }

  // config of axilite port
  val axilite_addr_width = 24 // in fact 21
  val axilite_data_width = 32

  // axi lite addr
  val CTRL_ADDR = 0x00
  // CTRL is a 32bit register, containing bits
  // 0: AP_START
  // 1: AP_DONE
  // 2: AP_IDLE
  // 3: AP_READY
  // 7: AUTO_RESTART
  // 9: INTERRUPT
  val GIER_ADDR = 0x04
  val IP_IER_ADDR = 0x08
  val IP_ISR_ADDR = 0x0c
  val N_ADDR = 0x10

  val W_OFFSET = 0x100000

  val W_BITS = 5
}

