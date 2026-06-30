import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
  id: workspaceLayout
  required property var screen

  Item {
    width: 5
  }

  Repeater {
    model: Hyprland.workspaces

    delegate: Rectangle {
      // Component.onCompleted: {
      //   console.log("name", modelData.name);
      // }
      visible: modelData.monitor && modelData.monitor.name === screen.name
      width: workspaceName.implicitWidth + 8
      height: 25
      color: modelData.active ? "#cba6f7" : "transparent"

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace=" + modelData.id + "})")
      }

      Text {
        id: workspaceName
        anchors.centerIn: parent
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
          return mapping[modelData.id] || " any";
        }
      }
    }
  }
}
