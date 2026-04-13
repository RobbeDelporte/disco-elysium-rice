pragma Singleton

import QtQuick

QtObject {
    readonly property QtObject colors: QtObject {
        readonly property color backdrop: Qt.rgba(0, 0, 0, 0.72)
        readonly property color panelBg: "#0e1110"
        readonly property color panelBorder: Qt.rgba(54/255, 59/255, 58/255, 0.7)
        readonly property color bannerBg: "#d2d2d2"
        readonly property color bannerFg: "#171b1a"
        readonly property color rowFg: "#d2d2d2"
        readonly property color rowFgMuted: Qt.rgba(210/255, 210/255, 210/255, 0.6)
        readonly property color highlight: "#d97b3a"
        readonly property color highlightTint: Qt.rgba(217/255, 123/255, 58/255, 0.08)
    }

    readonly property QtObject fonts: QtObject {
        readonly property string serifDisplay: "Playfair Display"
        readonly property string condensed: "Archivo Narrow"
        readonly property string body: "Libre Baskerville"
    }

    readonly property QtObject easings: QtObject {
        readonly property int ceremonialEnter: 220
        readonly property int ceremonialExit: 160
    }

    readonly property QtObject spacing: QtObject {
        readonly property int panelPadTop: 28
        readonly property int panelPadX: 26
        readonly property int panelPadBottom: 22
        readonly property int rowGap: 8
    }
}
