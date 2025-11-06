import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.modules.common.functions

Scope {
    id: root
    property string protectionMessage: ""
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
    property bool firstLoad: true

    function triggerOsd() {
        GlobalStates.osdVolumeOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Config.options.osd.timeout
        repeat: false
        running: false
        onTriggered: {
            GlobalStates.osdVolumeOpen = false;
            root.protectionMessage = "";
        }
    }

    // Connections {
    //     // Listen to volume changes
    //     target: Audio.sink?.audio ?? null
    //     function onVolumeChanged() {
    //         if (root.firstLoad) {
    //             root.firstLoad = false;
    //             return;
    //         }
    //         if (!Audio.ready || GlobalStates.controlCenterOpen)
    //             return;
    //         root.triggerOsd();
    //     }
    //     function onMutedChanged() {
    //         if (root.firstLoad) {
    //             root.firstLoad = false;
    //             return;
    //         }
    //         if (!Audio.ready || GlobalStates.controlCenterOpen)
    //             return;
    //         root.triggerOsd();
    //     }
    // }

    Connections {
        // Listen to volume changes
        target: Audio
        function onSinkVolChanged() {
            if (root.firstLoad) {
                root.firstLoad = false;
                return;
            }
            if (!Audio.ready)
                return;
            root.triggerOsd();
        }
        function onSinkMutedChanged() {
            if (root.firstLoad) {
                root.firstLoad = false;
                return;
            }
            if (!Audio.ready)
                return;
            root.triggerOsd();
        }
    }
    Connections {
        // Listen to protection triggers
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.protectionMessage = reason;
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: GlobalStates.osdVolumeOpen

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"

            Connections {
                target: root
                function onFocusedScreenChanged() {
                    osdRoot.screen = root.focusedScreen;
                }
            }

            WlrLayershell.namespace: "quickshell:osdv"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                left: false
                right: true
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
                    implicitHeight: contentColumnLayout.implicitHeight + Appearance.sizes.elevationMargin * 2
                    implicitWidth: contentColumnLayout.implicitWidth
                    clip: true

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: GlobalStates.osdVolumeOpen = false
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
                            value: Audio.sinkMuted ? 0 : Audio.sinkVol ?? 0
                            icon: Icons.getVolumeIcon(Audio.sinkVol ?? 0, Audio.sinkMuted ?? false)
                        }
                    }
                }
            }
        }
    }

    // IpcHandler {
    //     target: "osdVolume"
    //
    //     function trigger() {
    //         root.triggerOsd();
    //     }
    //
    //     function hide() {
    //         GlobalStates.osdVolumeOpen = false;
    //     }
    //
    //     function toggle() {
    //         GlobalStates.osdVolumeOpen = !GlobalStates.osdVolumeOpen;
    //     }
    // }
    // GlobalShortcut {
    //     name: "osdVolumeTrigger"
    //     description: "Triggers volume OSD on press"
    //
    //     onPressed: {
    //         root.triggerOsd();
    //     }
    // }
    // GlobalShortcut {
    //     name: "osdVolumeHide"
    //     description: "Hides volume OSD on press"
    //
    //     onPressed: {
    //         GlobalStates.osdVolumeOpen = false;
    //     }
    // }
}
