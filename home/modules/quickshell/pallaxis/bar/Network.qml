pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
  property int rxKbps: 0
  property int txKbps: 0
  property int lastRxBytes: 0
  property int lastTxBytes: 0
  property string device: ""

  Process {
    id: currentAdapter
    command: ["sh", "-c", "nmcli -f DEVICE con show --active | awk 'NR==2 {print $1}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        const output = text.trim();
        if (!output) {
          return;
        }
        device = output;
      }
    }
    Component.onCompleted: {
      running = true;
    }
  }

  Process {
    id: rxProc
    command: ["sh", "-c", "cat /sys/class/net/" + device + "/statistics/rx_bytes"]

    stdout: SplitParser {
      onRead: data => {
        if (!data)
          return;
        if (lastRxBytes > 0) {
          let diff = data - lastRxBytes;
          rxKbps = diff / 1024;
        }
        lastRxBytes = data;
      }
    }
    Component.onCompleted: running = true
  }
  Process {
    id: txProc
    command: ["sh", "-c", "cat /sys/class/net/" + device + "/statistics/tx_bytes"]

    stdout: SplitParser {
      onRead: data => {
        if (!data)
          return;
        if (lastTxBytes > 0) {
          let diff = data - lastTxBytes;
          txKbps = diff / 1024;
        }
        lastTxBytes = data;
      }
    }
    Component.onCompleted: running = true
  }
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      rxProc.running = true;
      txProc.running = true;
      currentAdapter.running = true;
    }
  }
}
