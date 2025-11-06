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
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
    property string micOnIcon: "󰍬"
    property string micOffIcon: "󰍭"
    property bool firstLoad: true

    function triggerOsd() {
        GlobalStates.osdMicrophoneOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Config.options.osd.timeout
        repeat: false
        running: false
        onTriggered: {
            GlobalStates.osdMicrophoneOpen = false;
        }
    }

    Connections {
        // Listen to muted changes
        target: Audio.source?.audio ?? null
        function onMutedChanged() {
            if (root.firstLoad) {
                root.firstLoad = false;
                return;
            }
            if (!Audio.ready)
                return;
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: GlobalStates.osdMicrophoneOpen

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"
            // color: "black"

            Connections {
                target: root
                function onFocusedScreenChanged() {
                    osdRoot.screen = root.focusedScreen;
                }
            }

            WlrLayershell.namespace: "quickshell:osdm"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                left: false
                right: false
                bottom: true
            }
            mask: Region {
                item: osdValuesWrapper
            }

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            margins {
                bottom: 60
            }

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

                        Item {
                            Layout.margins: Appearance.sizes.elevationMargin
                            implicitWidth: rect.implicitWidth
                            implicitHeight: rect.implicitHeight
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            StyledRectangularShadow {
                                target: rect
                                blur: 0.8 * Appearance.sizes.elevationMargin
                            }

                            Rectangle {
                                id: rect
                                radius: Appearance.rounding.small
                                implicitWidth: 100
                                implicitHeight: 100
                                color: ColorUtils.applyAlpha(Appearance?.m3colors.m3secondaryContainer ?? "#F1D3F9", 0.9)

                                StyledText {
                                    font.pixelSize: 70
                                    font.bold: true
                                    anchors.centerIn: parent
                                    text: Audio.source?.audio?.muted ? root.micOffIcon : root.micOnIcon
                                    color: Appearance?.colors.colPrimary ?? "#685496"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // IpcHandler {
    //     target: "osdMicrophone"
    //
    //     function trigger() {
    //         root.triggerOsd();
    //     }
    //
    //     function hide() {
    //         GlobalStates.osdMicrophoneOpen = false;
    //     }
    //
    //     function toggle() {
    //         GlobalStates.osdMicrophoneOpen = !GlobalStates.osdMicrophoneOpen;
    //     }
    // }
    // GlobalShortcut {
    //     name: "osdMicrophoneTrigger"
    //     description: "Triggers microphone OSD on press"
    //
    //     onPressed: {
    //         root.triggerOsd();
    //     }
    // }
    // GlobalShortcut {
    //     name: "osdMicrophoneHide"
    //     description: "Hides microphone OSD on press"
    //
    //     onPressed: {
    //         GlobalStates.osdMicrophoneOpen = false;
    //     }
    // }
}
