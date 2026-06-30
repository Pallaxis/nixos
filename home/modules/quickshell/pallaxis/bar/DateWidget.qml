import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
  id: root
  width: parent.width
  height: parent.height

  Text {
    id: dateText
    color: globalTheme.textColour
    font.family: globalTheme.fontName
    text: Date.date + " "
    anchors.centerIn: parent
    MouseArea {
      anchors.fill: parent
      // cursorShape: QtPointingHandCursor
      onClicked: {
        popup.visible = !popup.visible;
      }
    }
  }

  PopupWindow {
    id: popup
    visible: false

    implicitWidth: 300
    implicitHeight: 250

    // color: "green"

    anchor {
      item: dateText
      rect.x: (dateText.width / 2) - (popup.width / 2)
      rect.y: dateText.height + 10
    }

    Rectangle {
      // anchors.centerIn: parent
      anchors.fill: parent
      ColumnLayout {
        anchors.fill: parent
        Text {
          text: Qt.locale("en_NZ").monthName(grid.month, Locale.LongFormat) + " " + grid.year
          font.pixelSize: 22
          font.bold: true
          Layout.alignment: Qt.AlignHCenter
        }
        GridLayout {
          columns: 2
          Item {
            Layout.fillWidth: true
          }

          DayOfWeekRow {
            locale: grid.locale

            Layout.column: 1
            Layout.fillWidth: true
          }

          WeekNumberColumn {
            month: grid.month
            year: grid.year
            locale: grid.locale

            Layout.fillHeight: true
          }

          MonthGrid {
            id: grid
            month: new Date().getMonth()
            year: new Date().getFullYear()
            locale: Qt.locale("en_NZ")

            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate: Text {
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              text: model.day
              opacity: model.month === grid.month ? 1 : 0.4
              font.bold: model.today
            }
          }
        }
      }
    }
  }
}
