import QtQuick

Row {
  visible: Battery.hasBattery
  Text {
    Theme {
      id: globalTheme
    }
    // color: Battery.isCharging ? "#2ecc71" : "#ffffff"
    color: globalTheme.textColour
    font.family: globalTheme.fontName
    text: {
      if (!Battery.hasBattery)
        return "";

      let icon = "⚠️";
      if (Battery.isCharging)
        icon = "󰂄";
      else if (Battery.percentage > 97)
        icon = "󰁹";
      else if (Battery.percentage > 90)
        icon = "󰂂";
      else if (Battery.percentage > 80)
        icon = "󰂁";
      else if (Battery.percentage > 70)
        icon = "󰂀";
      else if (Battery.percentage > 60)
        icon = "󰁿";
      else if (Battery.percentage > 50)
        icon = "󰁾";
      else if (Battery.percentage > 40)
        icon = "󰁽";
      else if (Battery.percentage > 30)
        icon = "󰁼";
      else if (Battery.percentage > 20)
        icon = "󰁻";
      else if (Battery.percentage > 10)
        icon = "󱃍";

      return icon + " " + Battery.percentage + "%";
    }
  }
}
