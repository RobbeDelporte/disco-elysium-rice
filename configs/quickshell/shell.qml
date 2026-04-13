import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    IpcHandler {
        target: "shell"

        function toggle(name: string): void {
            switch (name) {
                case "powermenu": powermenuLoader.active = !powermenuLoader.active; return
                default: console.warn("shell.toggle: unknown widget", name)
            }
        }
    }

    LazyLoader {
        id: powermenuLoader
        active: false
        source: "widgets/PowerMenu.qml"
    }
}
