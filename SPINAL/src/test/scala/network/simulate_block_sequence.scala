package network

import ctrl.{AddressSeparableAxiLite4Driver, Controller, ctrl_cfg}
import block.BlockCfg
import block.BlockSequence
import spinal.core.sim._
import spinal.core._
import spinal.sim.SimThread

import java.io.{DataInputStream, FileInputStream}
import java.nio.{ByteBuffer, ByteOrder}

// return latency of residual sequence
object simulate_block_sequence {

  // spinal config
  val spinalConfig: SpinalConfig = SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = SYNC, resetActiveLevel = LOW
    )
  )

  def apply(TEST_N: Int, begin_id: Int, close_id: Int, until_stable: Boolean = false, display: Boolean = false): BigInt = {
    // shapes
    val TI = BlockCfg.TIs(begin_id)
    val CI = BlockCfg.CIs(begin_id)
    val TIP = BlockCfg.TIPs(begin_id)
    val CIP = BlockCfg.CIPs(begin_id)

    val TIT = BlockCfg.TITs(begin_id)
    val CIT = BlockCfg.CITs(begin_id)

    val TO = BlockCfg.TOs(close_id)
    val CO = BlockCfg.COs(close_id)
    val TOP = BlockCfg.TOPs(close_id)
    val COP = BlockCfg.COPs(close_id)

    val TOT = BlockCfg.TOTs(close_id)
    val COT = BlockCfg.COTs(close_id)

    // read data
    def read_file(file: String, n: Int): Array[Long] = {
      val file_stream = new DataInputStream(new FileInputStream(file))
      val byte_buffer = ByteBuffer.allocate(8 * n) // 8 bytes per int64
      file_stream.read(byte_buffer.array())
      file_stream.close()
      val int_buffer = byte_buffer.order(ByteOrder.LITTLE_ENDIAN).asLongBuffer() // little endian
      val int64_array = new Array[Long](n)
      int_buffer.get(int64_array)
      int64_array
    }

    val data_path = "C:/projects/AAAProjects/PROJ06_PyHLS_ViT/binaries/batchsize1/refs/"

    def get_block_name(block_id: Int): String = {
      if (block_id == BlockCfg.FIRST_ID) {
        "patch_embed"
      } else if (block_id == BlockCfg.LAST_ID) {
        "head"
      } else {
        val block_type = if (block_id % 2 == 0) "attn" else "mlp"
        val block_index = block_id / 2
        s"${block_type}_${block_index}"
      }
    }

    val i_array = Array.fill(TEST_N)(read_file(data_path + s"${get_block_name(begin_id)}_input.bin", TI * CI)).flatten
    val o_array = Array.fill(TEST_N)(read_file(data_path + s"${get_block_name(close_id)}_output.bin", TO * CO)).flatten

    val result_array = new Array[Int](TEST_N * TO * CO)

    // allocate arrive time array
    val i_begin_times: Array[BigInt] = new Array[BigInt](TEST_N)
    val i_close_times: Array[BigInt] = new Array[BigInt](TEST_N)
    val o_begin_times: Array[BigInt] = new Array[BigInt](TEST_N)
    val o_close_times: Array[BigInt] = new Array[BigInt](TEST_N)

    // latency result
    var latency: BigInt = -1
    var early_stop_latency: BigInt = -1

    // choose optimization level & with wave
    SimConfig
      .withConfig(spinalConfig)
      //      .withWave(1)
      .allOptimisation
      //      .normalOptimisation
      //      .fewOptimisation
      //      .noOptimisation
      .compile(new BlockSequence(begin_id, close_id))
      .doSimUntilVoid { dut =>
        val drv = AddressSeparableAxiLite4Driver(dut.io.axilite, dut.clockDomain)
        drv.reset()
        // init axi stream interface
        dut.io.i_stream.valid #= false
        dut.io.i_stream.data #= 0
        dut.io.o_stream.ready #= true
        // fork stimulus, period is 10ns
        val period = 10
        dut.clockDomain.forkStimulus(period = period)
        dut.clockDomain.deassertReset()
        dut.clockDomain.waitSampling(10)

        // timeout
        SimTimeout(period * 1000000 * TEST_N) // 10 images, each image 100000 cycles

        // the first thread
        def get_input_thread: SimThread = {
          val input_thread = fork {
            drv.write(ctrl_cfg.N_addr, TEST_N)
            dut.clockDomain.waitSampling(10)
            drv.write(ctrl_cfg.T_addr, 1) // trigger
            dut.clockDomain.waitSampling(10)

            // send image data
            for (n <- 0 until TEST_N) {
              for (tit <- 0 until TIT) {
                for (cit <- 0 until CIT) {
                  // input tile
                  val input_vec: Array[Long] = new Array[Long](TIP * CIP)
                  for (tip <- 0 until TIP) {
                    for (cip <- 0 until CIP) {
                      val local_index = tip * CIP + cip
                      val global_index = n * TI * CI + (tit * TIP + tip) * CI + (cit * CIP + cip)
                      input_vec(local_index) = i_array(global_index)
                    }
                  }
                  // concat tile bits
                  val i_bits = BlockCfg.INTERFACE_WIDTH_Is(begin_id)
                  val input_bigint = input_vec
                    .map { num =>
                      if (num < 0) {
                        // if is negative, use 2's complement
                        BigInt("1" * i_bits, 2) + BigInt(num) + 1
                      } else {
                        // if is positive, use original
                        BigInt(num)
                      }
                    }
                    .reverse
                    .reduce(_ << i_bits | _ & BigInt("1" * i_bits, 2))

                  // assign ports
                  dut.io.i_stream.data #= input_bigint
                  dut.io.i_stream.valid #= true
                  dut.clockDomain.waitSamplingWhere(dut.io.i_stream.ready.toBoolean && dut.io.i_stream.valid.toBoolean)
                  if (tit == 0 && cit == 0) i_begin_times(n) = simTime() / 10
                  if (tit == TIT - 1 && cit == CIT - 1) i_close_times(n) = simTime() / 10
                }
              }
            }

            dut.io.i_stream.valid #= false

          }
          input_thread
        }

        // the second thread
        def get_output_thread: SimThread = {

          val output_thread = fork {
            for (n <- 0 until TEST_N) {
              for (tot <- 0 until TOT) {
                for (cot <- 0 until COT) {

                  // assign ready
                  dut.io.o_stream.ready #= true
                  // get result
                  dut.clockDomain.waitSamplingWhere(dut.io.o_stream.valid.toBoolean)
                  val resBigInt = dut.io.o_stream.data.toBigInt
                  for (top <- 0 until TOP) {
                    for (cop <- 0 until COP) {
                      val local_index = top * COP + cop
                      val global_index = n * CO * TO + (tot * TOP + top) * CO + (cot * COP + cop)
                      val o_bits = BlockCfg.INTERFACE_WIDTH_Os(close_id) // after alignment, all become 16 bits
                      val part_val = (resBigInt >> (o_bits * local_index)) & BigInt("1" * o_bits, 2)
                      val sign_bit = (part_val >> BlockCfg.DATAWIDTH_Os(close_id) - 1) & 1 // sign bit
                      val result_val = part_val - (if (sign_bit == 1) 1 << BlockCfg.DATAWIDTH_Os(close_id) else 0)
                      if (result_val != o_array(global_index)) {
                        print(Console.RED)
                        print(s"Different at $global_index, the result is $result_val, expected ${o_array(global_index)}, part_val is $part_val\n")
                        print(Console.RESET)
                      }
                      result_array(global_index) = result_val.toInt
                    }
                  }

                  // end time
                  if (tot == 0 && cot == 0) o_begin_times(n) = simTime() / 10
                  if (tot == TOT - 1 && cot == COT - 1) {
                    o_close_times(n) = simTime() / 10
                    if (n == TEST_N - 1) assert(dut.io.o_stream.payload.last.toBoolean) // check last
                  }

                } // end of ct loop
              } // end of tt loop

              if (display) println(s"Got $n")

              // when o_begin_time_diff == o_close_time_diff, that means stable, stop simulation and return latency
              if (until_stable && n > 1) { // can get diff
                val o_begin_time_diff = o_begin_times(n) - o_begin_times(n - 1)
                val o_close_time_diff = o_close_times(n) - o_close_times(n - 1)
                if (o_begin_time_diff == o_close_time_diff) {
                  early_stop_latency = o_begin_time_diff
                  simSuccess()
                }
              }

            } // end of n loop

            // repeat 1000 times, check output valid, should be low.
            for (_ <- 0 until 1000) {
              dut.clockDomain.waitSampling()
              assert(!dut.io.o_stream.valid.toBoolean)
            }

          }
          output_thread
        }

        // do another test, without resetting
        Array(get_input_thread, get_output_thread).foreach(_.join())

        if (display) {
          println("*** Simulation finished ***")
          for (n <- 0 until TEST_N) {
            println("***************************************************")
            println(s"This is $n image.")
            println(s"First in to Last in:           ${i_close_times(n) - i_begin_times(n)}")
            println(s"First out to Last out:         ${o_close_times(n) - o_begin_times(n)}")
            println(s"First in to first out:         ${o_begin_times(n) - i_begin_times(n)}")
            println(s"Last in to last out:           ${o_close_times(n) - i_close_times(n)}")
            println(s"First in to Last out:          ${o_close_times(n) - i_begin_times(n)}")
            if (n != 0) {
              println(s"Latency of i begin:            ${i_begin_times(n) - i_begin_times(n - 1)}")
              println(s"Latency of i close:            ${i_close_times(n) - i_close_times(n - 1)}")
              println(s"Latency of o begin:            ${o_begin_times(n) - o_begin_times(n - 1)}")
              println(s"Latency of o close:            ${o_close_times(n) - o_close_times(n - 1)}")
            }
            println("***************************************************")
          }
        }

        // calculate accuracy and latency
        latency = i_close_times.last - i_begin_times.last
        dut.clockDomain.waitSampling(1000)
        simSuccess()

      } // end of simulation
    if (until_stable) early_stop_latency else latency
  }
}




