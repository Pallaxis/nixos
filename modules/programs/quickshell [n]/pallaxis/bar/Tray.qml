import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
  id: trayLayout

  Item {
    // Need to have this here so the middle bar doesn't collapse
    // when the tray is empty
    id: placeholder
    visible: trayRepeater.count === 0
  }

  Repeater {
    id: trayRepeater
    model: SystemTray.items

    delegate: IconImage {
      id: icon
      required property var modelData
      source: modelData.icon
      implicitSize: 18

      MouseArea {
        id: mouseArea
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: event => {
          if (event.button == Qt.LeftButton) {
            icon.modelData.activate();
          } else if (event.button == Qt.MiddleButton) {
            icon.modelData.secondaryActivate();
          } else if (event.button == Qt.RightButton) {
            menuAnchor.anchor.rect.x = event.x;
            menuAnchor.anchor.rect.y = event.y;
            menuAnchor.open();
          }
        }
        QsMenuAnchor {
          id: menuAnchor
          menu: icon.modelData.menu
          anchor.item: mouseArea
        }
      }
    }
  }
}
