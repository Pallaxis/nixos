import QtQuick
import Quickshell.Services.Pipewire

Item {
  id: root
  property PwNode defaultSink: Pipewire.defaultAudioSink
  implicitWidth: text.implicitWidth
  implicitHeight: text.implicitHeight

  PwObjectTracker {
    objects: [root.defaultSink]
  }
  // Component.onCompleted: {
  //   console.log("sink: ", defaultSink?.name)
  //   console.log("pwnode: ", defaultSink.description)
  // }

  Text {
    id: text
    Theme {
      id: globalTheme
    }
    color: globalTheme.textColour
    font.family: globalTheme.fontName
    text: root.defaultSink?.audio ? " " + Math.round(root.defaultSink.audio.volume * 100) + "%" : " 0%"
  }
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.MiddleButton
    onClicked: mouse => {
      if (mouse.button === Qt.MiddleButton) {
        root.defaultSink.audio.muted = !root.defaultSink.audio.muted;
      }
    }
  }
}
