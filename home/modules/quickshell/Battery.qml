pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string status: ""
  property bool isCharging: false
  property int percentage: 0

  FileView {
    id: batteryStatus
    path: "/sys/class/power_supply/BAT0/status"
    blockLoading: true
    onTextChanged: {
      status = text().trim();
      isCharging = (status === "Charging" || status === "Full");
      // console.log("charging: " + isCharging)
    }
  }
  FileView {
    id: batteryPercent
    path: "/sys/class/power_supply/BAT0/capacity"
    blockLoading: true
    onTextChanged: {
      percentage = text() ? parseInt(String(text()).trim()) : 0;
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
