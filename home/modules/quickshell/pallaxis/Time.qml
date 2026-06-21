pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    clock.hours + ":" + clock.minutes;
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
