package block

import spinal.core.log2Up
import spinal.lib.bus.amba4.axis.Axi4StreamConfig

object BlockCfg {

  // block ids
  // total 24 blocks, attn - mlp - attn - mlp ...
  val FIRST_ID = -1
  val LAST_ID = 24

  // but there exist -1 and 24. PatchEmbed and Head
  private val BLOCK_IDS: Array[Int] = (FIRST_ID to LAST_ID).toArray


  val DATAWIDTH_Is_ARRAY: Array[Int] = Array(
    8,
    13, 15,
    13, 14,
    13, 14,
    13, 13,
    13, 13,
    13, 13,
    13, 13,
    13, 13,
    13, 14,
    13, 13,
    13, 13,
    13, 13,
    13
  )

  val DATAWIDTH_Is: Map[Int, Int] = BLOCK_IDS.zip(DATAWIDTH_Is_ARRAY).toMap
  val DATAWIDTH_Os: Map[Int, Int] = BLOCK_IDS.zip(DATAWIDTH_Is_ARRAY.tail :+ 19).toMap

  val BLOCK_TYPES: Map[Int, String] = BLOCK_IDS.zip(Array(
    "PATCH_EMBED",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "ATTN", "MLP",
    "HEAD"
  )).toMap

  // ceil to complete byte
  def toNextByte(_bitWidth: Int): Int = _bitWidth + (8 - _bitWidth % 8) % 8

  def toNextPowerOfTwo(_bitWidth: Int): Int = 1 << log2Up(toNextByte(_bitWidth))

  val INTERFACE_WIDTH_Is: Map[Int, Int] = DATAWIDTH_Is.map { case (k, v) => (k, toNextPowerOfTwo(v)) }
  val INTERFACE_WIDTH_Os: Map[Int, Int] = DATAWIDTH_Os.map { case (k, v) => (k, toNextPowerOfTwo(v)) }

  // shape of input and output
  val SEQ_LEN = 196
  val PATCH_DIM = 768
  val EMBED_DIM = 192
  val CLASSES = 1000

  val TIs: Map[Int, Int] = BLOCK_IDS.map(i => i -> SEQ_LEN).toMap
  val TOs: Map[Int, Int] = BLOCK_IDS.map(i => i -> (if (i == LAST_ID) 1 else SEQ_LEN)).toMap
  val CIs: Map[Int, Int] = BLOCK_IDS.map(i => i -> (if (i == FIRST_ID) PATCH_DIM else EMBED_DIM)).toMap
  val COs: Map[Int, Int] = BLOCK_IDS.map(i => i -> (if (i == LAST_ID) CLASSES else EMBED_DIM)).toMap
  val TIPs: Map[Int, Int] = BLOCK_IDS.map(i => i -> 2).toMap
  val TOPs: Map[Int, Int] = BLOCK_IDS.map(i => i -> (if (i == LAST_ID) 1 else 2)).toMap
  val CIPs: Map[Int, Int] = BLOCK_IDS.map(i => i -> (if (i == FIRST_ID) 2 else 1)).toMap
  val COPs: Map[Int, Int] = BLOCK_IDS.map(i => i -> 1).toMap

  // create stream configs for all residuals
  val CI_BITs: Map[Int, Int] = BLOCK_IDS.map(i => i -> INTERFACE_WIDTH_Is(i) * TIPs(i) * CIPs(i)).toMap
  val CO_BITs: Map[Int, Int] = BLOCK_IDS.map(i => i -> INTERFACE_WIDTH_Os(i) * TOPs(i) * COPs(i)).toMap

  // calculate the trips
  val TITs: Map[Int, Int] = BLOCK_IDS.map(i => i -> TIs(i) / TIPs(i)).toMap
  val TOTs: Map[Int, Int] = BLOCK_IDS.map(i => i -> TOs(i) / TOPs(i)).toMap
  val CITs: Map[Int, Int] = BLOCK_IDS.map(i => i -> CIs(i) / CIPs(i)).toMap
  val COTs: Map[Int, Int] = BLOCK_IDS.map(i => i -> COs(i) / COPs(i)).toMap
  val I_TRIPs: Map[Int, Int] = BLOCK_IDS.map(i => i -> TIs(i) / TIPs(i) * CIs(i) / CIPs(i)).toMap
  val O_TRIPs: Map[Int, Int] = BLOCK_IDS.map(i => i -> TOs(i) / TOPs(i) * COs(i) / COPs(i)).toMap

  // wrap input and output stream config, with optional last signal
  def iStreamConfig(ID: Int): Axi4StreamConfig = {
    Axi4StreamConfig(
      dataWidth = CI_BITs(ID) / 8,
      useLast = false,
      useStrb = false,
      useKeep = false
    )
  }

  def oStreamConfig(ID: Int, useLast: Boolean = false): Axi4StreamConfig = {
    Axi4StreamConfig(
      dataWidth = CO_BITs(ID) / 8,
      useLast = useLast,
      useStrb = false,
      useKeep = false
    )
  }

}
