package ctrl

import spinal.core._
import spinal.lib._
import spinal.lib.fsm.{EntryPoint, State, StateMachine}

import scala.language.postfixOps

case class ApChain() extends Bundle with IMasterSlave {
  // Xilinx ap chain control signals

  val ap_start: Bool = Bool()
  val ap_continue: Bool = Bool()
  val ap_idle: Bool = Bool()
  val ap_ready: Bool = Bool()
  val ap_done: Bool = Bool()

  override def asMaster(): Unit = {
    out(ap_start)
    out(ap_continue)
    in(ap_idle)
    in(ap_ready)
    in(ap_done)
  }

  override def asSlave(): Unit = {
    in(ap_start)
    in(ap_continue)
    out(ap_idle)
    out(ap_ready)
    out(ap_done)
  }

}

case class DaisyChain[T <: Data](gen: T) extends Bundle {
  // daisy chain IO
  val I: T = in(cloneOf(gen))
  val O: T = out(cloneOf(gen))
}

case class ManagerSignals() extends Bundle {
  val N: UInt = UInt(ctrl_cfg.N_bits bits) // number of images
  val T: Bool = Bool() // Trigger
}

class Manager extends Component {
  val io = new Bundle {
    val signals: DaisyChain[ManagerSignals] = DaisyChain(ManagerSignals())
    val ap_chain: ApChain = master(ApChain())
  }

  noIoPrefix()

  io.signals.O.N := RegNext(io.signals.I.N) // pass N
  io.signals.O.T := RegNext(io.signals.I.T) // pass trigger

  io.ap_chain.ap_continue := True // always continue
  io.ap_chain.ap_start := False // default value

  val fsm: StateMachine = new StateMachine {
    val s_idle = new State with EntryPoint
    val s_work = new State

    val n_counter: UInt = Reg(UInt(ctrl_cfg.N_bits bits))

    s_idle.whenIsActive {
      when(io.signals.I.T) {
        n_counter := 0
        goto(s_work)
      }
    } // end of s_idle

    s_work.whenIsActive {
      io.ap_chain.ap_start := True

      when(io.ap_chain.ap_ready) { // handshake with ap_ready
        when(n_counter === io.signals.I.N - 1) { // the last one, go back to idle
          goto(s_idle)
        } otherwise {
          n_counter := n_counter + 1 // next one
        }
      } // else, wait for ap_ready

    } // end of s_work

  } // end of fsm

}

object genManager extends App {
  SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = ASYNC,
      resetActiveLevel = LOW
    ),
    mode = Verilog
  ).generate(new Manager)
}