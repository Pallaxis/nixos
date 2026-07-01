import QtQuick

Text {
  Theme {
    id: globalTheme
  }
  color: globalTheme.textColour
  font.family: globalTheme.fontName
  text: " " + Network.rxKbps + "KB/s " + " " + Network.txKbps + "KB/s"
}
