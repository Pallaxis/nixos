import QtQuick

Text {
  color: Battery.isCharging ? "#2ecc71" : "#ffffff"
  text: {
    let icon = "⚠️"
    if (Battery.status === "Charging") icon = "󰂄"
    else if (Battery.percentage > 98) icon = "󰁹"
    else if (Battery.percentage > 90) icon = "󰂂"
    else if (Battery.percentage > 80) icon = "󰂁"
    else if (Battery.percentage > 70) icon = "󰂀"
    else if (Battery.percentage > 60) icon = "󰁿"
    else if (Battery.percentage > 50) icon = "󰁾"
    else if (Battery.percentage > 40) icon = "󰁽"
    else if (Battery.percentage > 30) icon = "󰁼"
    else if (Battery.percentage > 20) icon = "󰁻"
    else if (Battery.percentage > 10) icon = "󱃍"

    return icon + " " + Battery.percentage + "%"
  }
}
