import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
  id: trayLayout

  Repeater {
    id: trayRepeater
    model: SystemTray.items

    IconImage {
      id: icon
      source: modelData.icon
      implicitSize: 18
      MouseArea {
        anchors.fill: parent

        onClicked: event => {
          if (event.button == Qt.LeftButton) {
            modelData.activate();
          } else if (event.button == Qt.MiddleButton) {
            modelData.secondaryActivate();
          } else if (event.button == Qt.RightButton) {
            // menuAnchor.open();
          }
        }
      }
    }
  }
}
