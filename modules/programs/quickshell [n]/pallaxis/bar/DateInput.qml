pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string date: {
    text: Qt.formatDateTime(clock.date, "dd-MM");
  }

  SystemClock {
    id: clock
    precision: SystemClock.Hours
  }
}
