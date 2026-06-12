import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Scope {
    Time {
        id: timeSource
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

            RowLayout {
                id: allBlocks

                spacing: 0
                anchors.fill: parent

                // Left blocks
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: leftBlocks.implicitWidth
                    color: "transparent"
                    opacity: 0.5

                    RowLayout {
                        id: leftBlocks

                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Workspaces {
                            screen: modelData
                        }

                    }

                }

                // Center spacer
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    border.width: 1
                    opacity: 0.5

                    RowLayout {
                        id: centerBlocks

                        spacing: 10
                        anchors.centerIn: parent

                        ClockWidget {
                            time: timeSource.time
                            verticalAlignment: Text.AlignVCenter
                        }

                    }

                }

                // Right blocks
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: rightBlocks.implicitWidth
                    color: "blue"
                    opacity: 0.5

                    RowLayout {
                        id: rightBlocks

                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: "R1"
                            color: "white"
                        }

                        Text {
                            text: "R2"
                            color: "white"
                        }

                        Text {
                            text: "R3"
                            color: "white"
                        }

                    }

                }

            }

        }

    }

}
