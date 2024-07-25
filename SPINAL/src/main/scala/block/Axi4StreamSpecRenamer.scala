package block

import spinal.core.Component
import spinal.lib.bus.amba4.axis.Axi4Stream.Axi4Stream

object Axi4StreamSpecRenamer {
  // do not use "payload_" substring
  def apply(that: Axi4Stream): Unit = {
    def doIt(): Unit = {
      that.flatten.foreach(bt => {
        // remove payload
        bt.setName(bt.getName().replace("payload", ""))
        // add T
        bt.setName(bt.getName().replace("data", "TDATA"))
        bt.setName(bt.getName().replace("valid", "TVALID"))
        bt.setName(bt.getName().replace("ready", "TREADY"))
        bt.setName(bt.getName().replace("last", "TLAST"))
        bt.setName(bt.getName().replace("keep", "TKEEP"))
        bt.setName(bt.getName().replace("strb", "TSTRB"))
        bt.setName(bt.getName().replace("id", "TID"))
        bt.setName(bt.getName().replace("dest", "TDEST"))
      })
    }

    if (Component.current == that.component)
      that.component.addPrePopTask(() => {
        doIt()
      })
    else
      doIt()
  }
}
