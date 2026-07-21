import QtQuick

Text {
  Theme {
    id: globalTheme
  }
  color: globalTheme.textColour
  font.family: globalTheme.fontName
  text: " " + Network.rxMbps + "Mbps " + " " + Network.txMbps + "Mbps"
}
