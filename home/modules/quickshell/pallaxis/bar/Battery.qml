pragma Singleton

import QtQuick
import QtQuick.Layouts
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
    path: statusPath
    blockLoading: true
    onTextChanged: {
      status = text().trim();
      isCharging = (status != "Discharging");
      // console.log("charging: " + isCharging);
    }
  }
  FileView {
    id: batteryPercent
    path: capacityPath
    blockLoading: true
    onTextChanged: {
      percentage = text() ? parseInt(String(text()).trim()) : 0;
    }
    onLoadFailed: error => {
      hasBattery = false;
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
