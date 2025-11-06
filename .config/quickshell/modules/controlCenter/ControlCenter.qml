import qs
import qs.services
import qs.modules.common
import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root
    property int menuWidth: Appearance.sizes.controlCenterWidth

    PanelWindow {
        id: menuRoot
        visible: GlobalStates.controlCenterOpen

        function hide() {
            GlobalStates.controlCenterOpen = false;
        }

        exclusiveZone: 0
        implicitWidth: menuWidth
        WlrLayershell.namespace: "quickshell:controlCenter"
        // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
        // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        color: "transparent"

        anchors {
            top: true
            right: true
            bottom: true
        }


        HyprlandFocusGrab {
            id: grab
            windows: [menuRoot]
            active: GlobalStates.controlCenterOpen
            onCleared: () => {
                if (!active)
                    menuRoot.hide();
            }
        }

        Loader {
            id: menuLoader
            active: GlobalStates.controlCenterOpen || Config.options.controlCenter.keepControlCenterLoaded
            anchors {
                fill: parent
                margins: Appearance.sizes.hyprlandGapsOut
                leftMargin: Appearance.sizes.elevationMargin
            }
            width: menuWidth - Appearance.sizes.hyprlandGapsOut - Appearance.sizes.elevationMargin
            height: parent.height - Appearance.sizes.hyprlandGapsOut * 2
            // height: implicitHeight

            focus: GlobalStates.controlCenterOpen
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    menuRoot.hide();
                }
            }

            sourceComponent: ControlCenterContent {
                id: menuContent
            }
        }
    }

    IpcHandler {
        target: "controlCenter"

        function toggle(): void {
            GlobalStates.controlCenterOpen = !GlobalStates.controlCenterOpen;
            if (GlobalStates.controlCenterOpen)
                Notifications.timeoutAll();
        }

        function close(): void {
            GlobalStates.controlCenterOpen = false;
        }

        function open(): void {
            GlobalStates.controlCenterOpen = true;
            Notifications.timeoutAll();
        }
    }

    GlobalShortcut {
        name: "controlCenterToggle"
        description: "Toggles control center on press"

        onPressed: {
            GlobalStates.controlCenterOpen = !GlobalStates.controlCenterOpen;
            if (GlobalStates.controlCenterOpen)
                Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "controlCenterOpen"
        description: "Opens control center on press"

        onPressed: {
            GlobalStates.controlCenterOpen = true;
            Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "controlCenterClose"
        description: "Closes control center on press"

        onPressed: {
            GlobalStates.controlCenterOpen = false;
        }
    }
}
