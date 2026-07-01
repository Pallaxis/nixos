import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

Scope {
  id: root
  Theme {
    id: globalTheme
  }

  IdleInhibitor {
    id: idleInhibitor
    window: PanelWindow {
      // end-4's code :3
      // Inhibitor requires a "visible" surface
      // Actually not lol
      implicitWidth: 0
      implicitHeight: 0
      color: "transparent"
      // Just in case...
      anchors {
        right: true
        bottom: true
      }
      // Make it not interactable
      mask: Region {
        item: null
      }
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData
      color: "transparent"
      implicitHeight: 30

      anchors {
        top: true
        left: true
        right: true
      }

      Rectangle {
        id: panelBackground
        anchors.fill: parent
        height: 30
        color: "transparent"

        // LEFT - variable width, anchored to left
        Rectangle {
          id: leftSection
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: workspaces.implicitWidth
          color: "transparent"

          Workspaces {
            id: workspaces
            screen: modelData
            anchors.fill: parent
          }
        }

        // RIGHT - variable width, anchored to right
        Rectangle {
          id: rightSection
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: rightBlocks.implicitWidth
          color: "transparent"

          RowLayout {
            id: rightBlocks
            anchors.fill: parent

            Tray {}
            NetworkModule {}
            Text {
              color: globalTheme.textColour
              font.family: globalTheme.fontName
              text: "  " + Performance.memUsage + "%"
            }
            Text {
              color: globalTheme.textColour
              font.family: globalTheme.fontName
              text: "󰻠 " + Performance.cpuUsage + "%"
            }
            Pipewire {}
            BatteryWidget {}
            Item {
              width: 5
            }
          }
        }

        // LOGO - positioned at exact monitor center (absolutely positioned)
        Rectangle {
          id: logoRect
          width: nixLogo.implicitWidth
          height: nixLogo.implicitHeight
          color: "transparent"
          x: (panelBackground.width / 2) - (width / 2)
          y: (panelBackground.height / 2) - (height / 2)

          Text {
            id: nixLogo
            text: ""
            anchors.centerIn: parent
            font.pixelSize: 35
            color: idleInhibitor.enabled ? "#f38ba8" : globalTheme.textColour
            font.family: globalTheme.fontName
            MouseArea {
              id: mouseArea
              anchors.fill: parent

              acceptedButtons: Qt.AllButtons
              onClicked: event => {
                idleInhibitor.enabled = !idleInhibitor.enabled;
              // console.log(idleInhibitor.enabled);
              }
            }
          }

          // DEBUG: Show center point of logo
          // Rectangle {
          //   width: 2
          //   height: parent.height
          //   color: "red"
          //   anchors.horizontalCenter: parent.horizontalCenter
          // }
        }

        Rectangle {
          id: dateRect
          width: 90
          height: 50
          color: "transparent"
          x: logoRect.x - width - 10  // 10px gap to the left of logo
          y: (panelBackground.height / 2) - (height / 2)

          DateWidget {
            id: dateWidget
          }
        }

        Rectangle {
          id: clockRect
          width: 90
          height: 50
          color: "transparent"
          x: logoRect.x + logoRect.width + 10  // 10px gap to the right of logo
          y: (panelBackground.height / 2) - (height / 2)

          ClockWidget {
            id: clockWidget
          }
        }

        // DEBUG: Show exact monitor center
        // Rectangle {
        //   width: 2
        //   height: panelBackground.height
        //   color: "blue"
        //   x: panelBackground.width / 2
        //   opacity: 0.7
        // }
      }
    }
  }
}
