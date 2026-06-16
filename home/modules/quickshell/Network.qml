import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
  property int rxKbps: 0
  property int txKbps: 0
  property int lastRxBytes: 0
  property int lastTxBytes: 0

  Process {
    id: rxProc
    command: ["sh", "-c", "cat /sys/class/net/enp0s20f0u2u4/statistics/rx_bytes"]

    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        if (lastRxBytes > 0) {
          let diff = data - lastRxBytes
          rxKbps = diff / 1024
        }
        lastRxBytes = data
      }
    }
    Component.onCompleted: running = true
  }
  Process {
    id: txProc
    command: ["sh", "-c", "cat /sys/class/net/enp0s20f0u2u4/statistics/tx_bytes"]

    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        if (lastTxBytes > 0) {
          let diff = data - lastTxBytes
          txKbps = diff / 1024
        }
        lastTxBytes = data
      }
    }
    Component.onCompleted: running = true
  }
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      rxProc.running = true
      txProc.running = true
    }
  }
  Text {
    text: rxKbps + "KB/s " + txKbps + "KB/s"
  }
}
