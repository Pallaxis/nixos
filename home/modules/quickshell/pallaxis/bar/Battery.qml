pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string status: ""
  property bool hasBattery: true
  property bool isCharging: false
  property int percentage: 0
  readonly property string statusPath: "/sys/class/power_supply/BAT0/status"
  readonly property string capacityPath: "/sys/class/power_supply/BAT0/capacity"

  FileView {
    id: batteryStatus
    path: root.statusPath
    blockLoading: true
    onTextChanged: {
      root.status = text().trim();
      root.isCharging = (root.status != "Discharging");
      // console.log("charging: " + isCharging);
    }
  }
  FileView {
    id: batteryPercent
    path: root.capacityPath
    blockLoading: true
    onTextChanged: {
      root.percentage = text() ? parseInt(String(text()).trim()) : 0;
    }
    onLoadFailed: error => {
      root.hasBattery = false;
    }
  }
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: {
      batteryStatus.reload();
      batteryPercent.reload();
    }
  }
}
