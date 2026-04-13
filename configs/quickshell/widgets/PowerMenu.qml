import QtQuick
import Quickshell

PanelWindow {
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    Rectangle {
        anchors.centerIn: parent
        width: 300
        height: 120
        color: "#0e1110"
        border.color: "#d97b3a"
        border.width: 2
        Text {
            anchors.centerIn: parent
            text: "PowerMenu stub"
            color: "#d2d2d2"
            font.pixelSize: 20
        }
    }
}
