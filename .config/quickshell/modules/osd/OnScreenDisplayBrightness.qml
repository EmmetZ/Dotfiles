import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.modules.common.functions

Scope {
    id: root
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
    property var brightnessMonitor: Brightness.getMonitorForScreen(focusedScreen)

    function triggerOsd() {
        GlobalStates.osdBrightnessOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Config.options.osd.timeout
        repeat: false
        running: false
        onTriggered: {
            GlobalStates.osdBrightnessOpen = false;
        }
    }

    Connections {
        target: Brightness
        function onBrightnessChanged() {
            if (!root.brightnessMonitor.ready)
                return;
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: GlobalStates.osdBrightnessOpen

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"

            Connections {
                target: root
                function onFocusedScreenChanged() {
                    osdRoot.screen = root.focusedScreen;
                }
            }

            WlrLayershell.namespace: "quickshell:osdb"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                right: false
                left: left
            }
            mask: Region {
                item: osdValuesWrapper
            }

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0

            implicitWidth: columnLayout.implicitWidth
            implicitHeight: columnLayout.implicitHeight
            visible: osdLoader.active

            ColumnLayout {
                id: columnLayout
                anchors.horizontalCenter: parent.horizontalCenter
                Item {
                    id: osdValuesWrapper
                    // Extra space for shadow
                    implicitHeight: contentColumnLayout.implicitHeight + 2 * Appearance.sizes.elevationMargin
                    implicitWidth: contentColumnLayout.implicitWidth
                    clip: true

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: GlobalStates.osdBrightnessOpen = false
                    }

                    ColumnLayout {
                        id: contentColumnLayout
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                            leftMargin: Appearance.sizes.elevationMargin
                            rightMargin: Appearance.sizes.elevationMargin
                        }
                        spacing: 0

                        OsdValueIndicator {
                            id: osdValues
                            Layout.fillWidth: true
                            value: root.brightnessMonitor?.brightness ?? 0.5
                            icon: Icons.getBrightnessIcon(root.brightnessMonitor?.brightness ?? 0.5)
                        }
                    }
                }
            }
        }
    }

    // IpcHandler {
    //     target: "osdBrightness"
    //
    //     function trigger() {
    //         root.triggerOsd();
    //     }
    //
    //     function hide() {
    //         GlobalStates.osdBrightnessOpen = false;
    //     }
    //
    //     function toggle() {
    //         GlobalStates.osdBrightnessOpen = !GlobalStates.osdBrightnessOpen;
    //     }
    // }
    //
    // GlobalShortcut {
    //     name: "osdBrightnessTrigger"
    //     description: "Triggers brightness OSD on press"
    //
    //     onPressed: {
    //         root.triggerOsd();
    //     }
    // }
    // GlobalShortcut {
    //     name: "osdBrightnessHide"
    //     description: "Hides brightness OSD on press"
    //
    //     onPressed: {
    //         GlobalStates.osdBrightnessOpen = false;
    //     }
    // }
}
