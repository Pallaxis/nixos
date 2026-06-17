import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

RowLayout {
  spacing: 8
  property PwNode defaultSink: Pipewire.defaultAudioSink
  PwObjectTracker {
    objects: [defaultSink]
  }
  // Component.onCompleted: {
  //   console.log("sink: ", defaultSink?.name)
  //   console.log("pwnode: ", defaultSink.description)
  // }

  Text {
    color: globalTheme.textColour
    font.family: globalTheme.fontName
    text: defaultSink?.audio 
      ? Math.round(defaultSink.audio.volume * 100) + "%" 
      : "0%"
  }
  MouseArea {
    acceptedButtons: Qt.MiddleButton
    onClicked: (mouse) => {
      if (mouse.button === Qt.MiddleButton) {
        defaultSink.audio.muted = ! defaultSink.audio.muted
      }
    }
  }
}
