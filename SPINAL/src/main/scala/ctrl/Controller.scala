package ctrl

import block.BlockCfg
import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axilite._
import spinal.lib.bus.amba4.axis.Axi4Stream._
import spinal.lib.bus.amba4.axis._
import spinal.lib.fsm._

import scala.language.postfixOps
import scala.util.Random

object ctrl_cfg {
  val axilite_addr_width = 16
  val axilite_data_width = 32

  val N_bits = 20 // 20bit, 2^20 = 1M images

  // register space for controller
  val N_addr = 0x0000 // Number of images
  val T_addr = 0x0010 // 1: trigger
  val ap_rst_n_addr = 0x0020 // 0: reset
}

class Controller(EndID: Int) extends Component {
  // responsible for generate N and trigger, and reset
  // also wrap the last signal

  val iStreamConfig: Axi4StreamConfig = BlockCfg.oStreamConfig(EndID, useLast = false) // unwrapped
  val oStreamConfig: Axi4StreamConfig = BlockCfg.oStreamConfig(EndID, useLast = true) // wrapped

  val io = new Bundle {
    val axilite: AxiLite4 = slave(AxiLite4(addressWidth = ctrl_cfg.axilite_addr_width, dataWidth = ctrl_cfg.axilite_data_width))
    val i_stream: Axi4Stream = slave(Axi4Stream(iStreamConfig))
    val o_stream: Axi4Stream = master(Axi4Stream(oStreamConfig))

    // direct ports
    val signals: ManagerSignals = out(ManagerSignals())
    val ap_rst_n: Bool = out Bool()
  }

  noIoPrefix()
  AxiLite4SpecRenamer(io.axilite)

  val busCtrl = new AxiLite4SlaveFactory(io.axilite)
  // data registers
  io.signals.T := False // on write requires default value
  busCtrl.drive(io.signals.N, ctrl_cfg.N_addr, 0, "Number of images")
  busCtrl.drive(io.ap_rst_n, ctrl_cfg.ap_rst_n_addr, 0, "Reset")
  busCtrl.write(io.signals.T, ctrl_cfg.T_addr, 0, "Trigger")
  // create trip register
  private val trips: Int = BlockCfg.O_TRIPs(EndID)

  // default values
  io.i_stream.ready := False
  io.o_stream.valid := False
  io.o_stream.payload.last := False
  io.o_stream.payload.data := 0

  val fsm: StateMachine = new StateMachine {
    val s_idle = new State with EntryPoint
    val s_work = new State

    val n_counter: UInt = Reg(UInt(ctrl_cfg.N_bits bits))

    val trip_counter: UInt = Reg(UInt(log2Up(trips) bits))

    s_idle.whenIsActive {
      when(io.signals.T) {
        // triggered
        n_counter := 0
        trip_counter := 0
        goto(s_work)
      }
    }

    s_work.whenIsActive {
      val n_last: Bool = n_counter === io.signals.N - 1
      val trip_last: Bool = trip_counter === trips - 1

      // through
      io.i_stream.ready := io.o_stream.ready
      io.o_stream.valid := io.i_stream.valid
      io.o_stream.payload.data := io.i_stream.payload.data
      io.o_stream.payload.last := trip_last && n_last

      when(io.i_stream.fire) {
        when(trip_last) {
          trip_counter := 0
          when(n_last)(goto(s_idle)) otherwise (n_counter := n_counter + 1)
        } otherwise {
          trip_counter := trip_counter + 1
        }
      }

    } // end of s_work
  } // end of fsm

}

case class AddressSeparableAxiLite4Driver(axi: AxiLite4, clockDomain: ClockDomain) {

  def reset(): Unit = {
    axi.aw.valid #= false
    axi.w.valid #= false
    axi.ar.valid #= false
    axi.r.ready #= true
    axi.b.ready #= true
  }

  def read(address: BigInt): BigInt = {
    axi.ar.payload.prot.assignBigInt(6)
    axi.ar.valid #= true
    axi.ar.payload.addr #= address
    axi.r.ready #= true
    clockDomain.waitSamplingWhere(axi.ar.ready.toBoolean)

    axi.ar.valid #= false
    clockDomain.waitSamplingWhere(axi.r.valid.toBoolean)

    axi.r.ready #= false
    axi.r.payload.data.toBigInt
  }

  def write(address: BigInt, data: BigInt): Unit = {
    axi.aw.payload.prot.assignBigInt(6)
    axi.w.payload.strb.assignBigInt((1 << axi.w.payload.strb.getWidth) - 1)
    fork {
      axi.aw.valid #= true
      axi.aw.payload.addr #= address
      clockDomain.waitSamplingWhere(axi.aw.ready.toBoolean)
      axi.aw.valid #= false
    }
    fork {
      axi.w.valid #= true
      axi.w.payload.data #= data
      clockDomain.waitSamplingWhere(axi.w.ready.toBoolean)
      axi.w.valid #= false
    }
  } // end of write

}

object simulate_controller extends App {

  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = ASYNC,
      resetActiveLevel = LOW
    )
  )

  val EndID = BlockCfg.LAST_ID

  SpinalVerilog(spinalConfig)(new Controller(EndID))

  SimConfig
    .withConfig(spinalConfig)
    .withWave(1)
    .compile(new Controller(EndID))
    .doSimUntilVoid { dut =>

      val drv = AddressSeparableAxiLite4Driver(dut.io.axilite, dut.clockDomain)
      drv.reset()

      // init
      dut.io.i_stream.valid #= false
      dut.io.o_stream.ready #= false

      // fork stimulus
      dut.clockDomain.forkStimulus(period = 10)
      dut.clockDomain.waitSampling(10)

      // ap reset
      drv.write(ctrl_cfg.ap_rst_n_addr, 0)
      dut.clockDomain.waitSampling(10)
      drv.write(ctrl_cfg.ap_rst_n_addr, 1)
      dut.clockDomain.waitSampling(10)
      drv.write(ctrl_cfg.ap_rst_n_addr, 0)
      dut.clockDomain.waitSampling(10)
      drv.write(ctrl_cfg.ap_rst_n_addr, 1)
      dut.clockDomain.waitSampling(10)

      // send data
      val trips = BlockCfg.O_TRIPs(EndID)

      def do_once(TEST_N: Int): Unit = {
        drv.write(ctrl_cfg.N_addr, TEST_N)
        dut.clockDomain.waitSampling(100)

        drv.write(ctrl_cfg.T_addr, 1)
        dut.clockDomain.waitSampling(10)

        val iArray = Array.fill(trips * TEST_N)(Random.nextInt(100))
        val oArray = Array.fill(trips * TEST_N)(BigInt(0))

        val thread1 = fork {
          for (n <- 0 until trips * TEST_N) {
            // random halt
            dut.io.i_stream.valid #= false
            dut.clockDomain.waitSampling(Random.nextInt(2))
            // assign
            dut.io.i_stream.valid #= true
            dut.io.i_stream.payload.data #= iArray(n)
            dut.clockDomain.waitSamplingWhere(dut.io.i_stream.ready.toBoolean)
          }
          dut.io.i_stream.valid #= false
        } // end of thread1

        val thread2 = fork {
          for (n <- 0 until trips * TEST_N) {
            // random halt
            dut.io.o_stream.ready #= false
            dut.clockDomain.waitSampling(Random.nextInt(2))
            dut.io.o_stream.ready #= true
            dut.clockDomain.waitSamplingWhere(dut.io.o_stream.valid.toBoolean)
            oArray(n) = dut.io.o_stream.payload.data.toBigInt
            if (n + 1 == trips * TEST_N) {
              assert(dut.io.o_stream.payload.last.toBoolean)
              println("The last check passed")
            }
          }
          dut.io.o_stream.ready #= false
        } // end of thread2

        thread1.join()
        thread2.join()

        // compare
        for (n <- 0 until trips * TEST_N) {
          assert(oArray(n) == iArray(n))
        }

      } // end of do_once

      do_once(1)
      dut.clockDomain.waitSampling(1000)
      println("4 done")

      do_once(2)
      dut.clockDomain.waitSampling(1000)
      println("2 done")

      do_once(10)
      dut.clockDomain.waitSampling(1000)
      println("100 done")

      simSuccess()
    }
}