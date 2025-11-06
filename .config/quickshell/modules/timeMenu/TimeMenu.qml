import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs

Scope {
    id: root
    property int menuWidth: Appearance.sizes.timeMenuWidth

    PanelWindow {
        id: menuRoot
        visible: GlobalStates.timeMenuOpen

        function hide() {
            GlobalStates.timeMenuOpen = false;
        }

        exclusiveZone: 0
        implicitWidth: menuWidth
        implicitHeight: menuLoader.implicitHeight
        WlrLayershell.namespace: "quickshell:timeMenu"
        // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
        // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        color: "transparent"

        anchors {
            top: true
            right: false
            left: false
            bottom: true
        }


        HyprlandFocusGrab {
            id: grab
            windows: [menuRoot]
            active: GlobalStates.timeMenuOpen
            onCleared: () => {
                if (!active)
                    menuRoot.hide();
            }
        }

        Loader {
            id: menuLoader
            active: GlobalStates.timeMenuOpen || Config.options.timeMenu.keepControlCenterLoaded
            anchors {
                // fill: parent
                // margins: Appearance.sizes.hyprlandGapsOut
                // leftMargin: Appearance.sizes.elevationMargin
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                left: parent.left
                margins: Appearance.sizes.hyprlandGapsOut
                leftMargin: Appearance.sizes.elevationMargin
            }
            width: menuWidth - Appearance.sizes.hyprlandGapsOut - Appearance.sizes.elevationMargin
            // height: parent.height - Appearance.sizes.hyprlandGapsOut * 2
            // height: implicitHeight

            focus: GlobalStates.timeMenuOpen
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    menuRoot.hide();
                }
            }

            sourceComponent: TimeMenuContent {
                id: menuContent
            }
        }
    }

    IpcHandler {
        target: "timeMenu"

        function toggle(): void {
            GlobalStates.timeMenuOpen = !GlobalStates.timeMenuOpen;
            if (GlobalStates.timeMenuOpen)
                Notifications.timeoutAll();
        }

        function close(): void {
            GlobalStates.timeMenuOpen = false;
        }

        function open(): void {
            GlobalStates.timeMenuOpen = true;
            Notifications.timeoutAll();
        }
    }

    GlobalShortcut {
        name: "timeMenuToggle"
        description: "Toggles time menu on press"

        onPressed: {
            GlobalStates.timeMenuOpen = !GlobalStates.timeMenuOpen;
            if (GlobalStates.timeMenuOpen)
                Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "timeMenuOpen"
        description: "Opens time menu on press"

        onPressed: {
            GlobalStates.timeMenuOpen = true;
            Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "timeMenuClose"
        description: "Closes time menu on press"

        onPressed: {
            GlobalStates.timeMenuOpen = false;
        }
    }
}
