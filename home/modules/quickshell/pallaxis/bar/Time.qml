pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    text: Qt.formatDateTime(clock.date, "hh:mm");
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
