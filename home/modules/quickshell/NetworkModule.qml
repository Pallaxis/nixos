import QtQuick

Text {
  color: globalTheme.textColour
  font.family: globalTheme.fontName
  text: " " + Network.rxKbps + "KB/s " + " " + Network.txKbps + "KB/s"
}
