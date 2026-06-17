import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Scope {
  // Time {
  //   id: timeSource
  // }

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

      RowLayout {
        id: allBlocks

        spacing: 0
        anchors.fill: parent

        // Left blocks
        RowLayout {
          id: leftBlocks

          Item {
            width: 5
          }

          Workspaces {
            screen: modelData
          }

        }


        // Center spacer
        Rectangle {
          id: centerSpacer
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "transparent"
          border.width: 1
          border.color: "red"
          opacity: 0.5
        }

        // Right blocks
        RowLayout {
          id: rightBlocks

          spacing: 10

          // Rectangle {
          //   color: "blue"
          //   Layout.fillHeight: true
          //   width: 50
          // }
          Tray {}
          NetworkModule {}
          Text {
            text: "  " + Performance.memUsage + "%"
          }
          Text {
            text: "󰻠 " + Performance.cpuUsage + "%"
          }
          Pipewire {}
          BatteryWidget {}
          Item {
            width: 5
          }
        }


      }
      RowLayout {
        id: clockContainer
        anchors.centerIn: parent  // This centers on the full monitor width!
        spacing: 10

        ClockWidget {
          verticalAlignment: Text.AlignVCenter
        }
        // Other true-center modules here
      }

    }

  }

}
