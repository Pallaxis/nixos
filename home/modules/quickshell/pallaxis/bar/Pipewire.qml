import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Item {
  property PwNode defaultSink: Pipewire.defaultAudioSink
  implicitWidth: text.implicitWidth
  implicitHeight: text.implicitHeight

  PwObjectTracker {
    objects: [defaultSink]
  }
  // Component.onCompleted: {
  //   console.log("sink: ", defaultSink?.name)
  //   console.log("pwnode: ", defaultSink.description)
  // }

  Text {
    id: text
    color: globalTheme.textColour
    font.family: globalTheme.fontName
    text: defaultSink?.audio ? " " + Math.round(defaultSink.audio.volume * 100) + "%" : " 0%"
  }
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.MiddleButton
    onClicked: mouse => {
      if (mouse.button === Qt.MiddleButton) {
        defaultSink.audio.muted = !defaultSink.audio.muted;
      }
    }
  }
}
