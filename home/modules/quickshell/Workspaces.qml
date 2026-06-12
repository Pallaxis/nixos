import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    required property var screen

    color: "transparent"
    height: 25
    width: 220

    RowLayout {
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                Component.onCompleted: {
                    console.log("name", modelData.name);
                }
                visible: modelData.monitor.name === screen.name
                width: 40
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

}
