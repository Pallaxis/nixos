import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
  spacing: 8

  FileView {
    id: batteryStatus
    path: "/sys/class/power_supply/BAT0/status"
    blockLoading: true
    property string status: ""
    property bool isCharging: false
    onTextChanged: {
      status = text().trim()
      isCharging = (status === "Charging" || status === "Full")
      // console.log("charging: " + isCharging)
    }
  }
  FileView {
    id: batteryPercent
    path: "/sys/class/power_supply/BAT0/capacity"
    blockLoading: true
    property int percentage: text ? parseInt(String(text()).trim()) : 0
  }
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: {
      batteryStatus.reload()
      batteryPercent.reload()
    }
  }

  Text {
      font.pixelSize: 14
      color: batteryStatus.isCharging ? "#2ecc71" : "#ffffff"
      text: {
          if (batteryStatus.status === "Charging") return "󰂄"
          if (batteryPercent.percentage > 90) return "󰂂"
          if (batteryPercent.percentage > 80) return "󰂁"
          if (batteryPercent.percentage > 70) return "󰂀"
          if (batteryPercent.percentage > 60) return "󰁿"
          if (batteryPercent.percentage > 50) return "󰁾"
          if (batteryPercent.percentage > 40) return "󰁽"
          if (batteryPercent.percentage > 30) return "󰁼"
          if (batteryPercent.percentage > 20) return "󰁻"
          if (batteryPercent.percentage > 10) return "󱃍"
          return "⚠️"
      }
  }
  Text {
      color: "#ffffff"
      text: batteryPercent.percentage + "%"
  }
}
