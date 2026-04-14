import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import ".."

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.exclusiveZone: -1
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"

    readonly property var rows: [
        { label: "Shut Down", action: ["systemctl", "poweroff"] },
        { label: "Restart",   action: ["systemctl", "reboot"] },
        { label: "Suspend",   action: ["systemctl", "suspend"] },
        { label: "Hibernate", action: ["systemctl", "hibernate"] },
        { label: "Lock",      action: ["loginctl", "lock-session"] },
        { label: "Log Out",   action: ["hyprctl", "dispatch", "exit"] }
    ]
    property int selected: 0

    function dismiss() {
        Quickshell.execDetached(["qs", "ipc", "call", "shell", "toggle", "powermenu"])
    }

    function activate(i) {
        const act = rows[i].action
        Quickshell.execDetached(act)
        dismiss()
    }

    Item {
        id: focusScope
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.dismiss()
        Keys.onUpPressed: root.selected = (root.selected - 1 + root.rows.length) % root.rows.length
        Keys.onDownPressed: root.selected = (root.selected + 1) % root.rows.length
        Keys.onReturnPressed: root.activate(root.selected)
        Keys.onEnterPressed: root.activate(root.selected)
        Keys.onPressed: (e) => {
            if (e.key === Qt.Key_K) { root.selected = (root.selected - 1 + root.rows.length) % root.rows.length; e.accepted = true }
            else if (e.key === Qt.Key_J) { root.selected = (root.selected + 1) % root.rows.length; e.accepted = true }
        }
        Component.onCompleted: forceActiveFocus()
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.backdrop
        MouseArea { anchors.fill: parent; onClicked: root.dismiss() }
    }

    Item {
        id: topFilmClip
        anchors { top: parent.top; left: parent.left;}
        height: 32
        clip: true
        Image {
            width: parent.width
            height: sourceSize.height
            y: parent.height - height
            source: "../assets/film-tape.png"
            fillMode: Image.TileHorizontally
            transform: Scale { origin.y: height / 2; yScale: -1 }
        }
    }

    Item {
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
        height: 64
        clip: true
        Image {
            width: parent.width
            height: sourceSize.height
            source: "../assets/film-tape.png"
            fillMode: Image.TileHorizontally
            ransform: Scale { origin.y: height / 2; yScale: -1 }

        }
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: 280
        implicitHeight: panelLayout.implicitHeight
            + Theme.spacing.panelPadTop
            + Theme.spacing.panelPadBottom
        height: implicitHeight
        color: Theme.colors.panelBg
        border.color: Theme.colors.panelBorder
        border.width: 1

        Item {
            id: banner
            x: -10
            y: -14
            width: bannerText.implicitWidth + 24
            height: 24

            Image {
                anchors.fill: parent
                source: "../assets/brush-strip-white.png"
                fillMode: Image.Stretch
            }
            Text {
                id: bannerText
                anchors.centerIn: parent
                text: "SESSION"
                font.family: Theme.fonts.condensed
                font.weight: Font.Normal
                font.pixelSize: 14
                font.letterSpacing: 4
                color: Theme.colors.bannerFg
            }
        }

        ColumnLayout {
            id: panelLayout
            anchors {
                top: parent.top; left: parent.left; right: parent.right
                topMargin: Theme.spacing.panelPadTop
                leftMargin: Theme.spacing.panelPadX
                rightMargin: Theme.spacing.panelPadX
            }
            spacing: Theme.spacing.rowGap

            Repeater {
                model: root.rows
                delegate: Rectangle {
                    required property int index
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: rowGrid.implicitHeight + 14
                    color: index === root.selected
                        ? Theme.colors.highlightTint
                        : "transparent"

                    Rectangle {
                        visible: index === root.selected
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: 2
                        color: Theme.colors.highlight
                    }

                    RowLayout {
                        id: rowGrid
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 6
                        anchors.bottomMargin: 6
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
                            radius: 7
                            color: "transparent"
                            border.color: Theme.colors.rowFg
                            border.width: 1
                        }
                        Text {
                            text: modelData.label
                            font.family: Theme.fonts.condensed
                            font.pixelSize: 14
                            color: Theme.colors.rowFg
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.selected = index
                        onClicked: root.activate(index)
                    }
                }
            }
        }
    }

}
