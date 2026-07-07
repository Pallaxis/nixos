pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
  id: root
  required property var screen

  Item {
    Layout.leftMargin: 5
  }

  Repeater {
    model: Hyprland.workspaces

    delegate: Rectangle {
      id: button
      required property var modelData
      // Component.onCompleted: {
      //   console.log("name", modelData.name);
      // }
      visible: modelData.monitor && modelData.monitor.name === root.screen.name
      width: workspaceName.implicitWidth + 8
      height: 25
      color: modelData.active ? "#cba6f7" : "transparent"

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace=" + button.modelData.id + "})")
      }

      Text {
        id: workspaceName
        anchors.centerIn: parent
        Theme {
          id: globalTheme
        }
        color: globalTheme.textColour
        font.family: globalTheme.fontName
        font.pixelSize: 12
        font.bold: true
        text: {
          var mapping = {
            "1": " web",
            "2": " term",
            "5": " slack",
            "9": " pass",
            "10": " email",
            "-99": " special"
          };
          return mapping[button.modelData.id] || " any";
        }
      }
    }
  }
}
