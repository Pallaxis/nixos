import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
  required property var screen
    id: workspaceLayout

    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {
            Component.onCompleted: {
                console.log("name", modelData.name);
            }
            visible: modelData.monitor.name === screen.name
            width: 50
            height: 15
            color: modelData.active ? "#cba6f7" : "#333333"

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("hl.dsp.focus({workspace=" + modelData.id + "})")
            }

            Text {
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 12
                font.bold: true
                text: {
                    var mapping = {
                        "1": " web",
                        "2": " term",
                        "5": " slack",
                        "9": " pass",
                        "10": " email"
                    };
                    return mapping[modelData.id] || " any";
                }
            }

        }

    }

}
