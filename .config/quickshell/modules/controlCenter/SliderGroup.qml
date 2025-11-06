import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Rectangle {
    radius: Appearance.rounding.normal
    color: Appearance.colors.colLayer1
    implicitHeight: columnLayout.implicitHeight + 10

    property real volume: Audio.sinkMuted ? 0 : Audio.sinkVol ?? 0

    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)
    property real brightness: {
        return brightnessMonitor ? brightnessMonitor.brightness : 0;
    }

    ColumnLayout {
        id: columnLayout
        anchors.margins: 5
        anchors.fill: parent
        spacing: 0

        RowLayout {
            spacing: 10
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            StyledText {
                text: Icons.getVolumeIcon(volume)
                font.pixelSize: Appearance.font.pixelSize.larger
                font.bold: true
                horizontalAlignment: Text.AlignRight
                color: Appearance.colors.colOnLayer1

                // MouseArea {
                //     anchors.fill: parent
                //     cursorShape: Qt.PointingHandCursor
                //     acceptedButtons: Qt.LeftButton
                //     onClicked: event => {
                //         if (event.button === Qt.LeftButton) {
                //             Audio.setMuted(!Audio.sink.audio.muted);
                //         }
                //     }
                // }
            }

            StyledSlider {
                id: volumeSlider
                value: volume
                configuration: 15
                handleHeight: this.trackWidth + 4
                onValueChanged: {
                    if (Audio.sinkMuted && value === 0) {
                        return;
                    } else {
                        if (Audio.sinkMuted && value > 0) {
                            Audio.setMuted(false);
                        }
                        if (Audio.sink?.ready ?? false) {
                            Audio.sink.audio.volume = value;
                        }
                    }
                }
            }

            Connections {
                target: volumeSlider
                function onReleased() {
                    if (!Audio.sinkMuted || volumeSlider.value > 0) {
                        Quickshell.execDetached(["pw-play", Config.options.audio.notifySound]);
                    }
                }
            }
        }

        RowLayout {
            spacing: 10
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            StyledText {
                text: Icons.getBrightnessIcon(brightness)
                font.pixelSize: Appearance.font.pixelSize.larger
                font.bold: true
                horizontalAlignment: Text.AlignRight
                color: Appearance.colors.colOnLayer1
            }

            StyledSlider {
                value: brightness
                configuration: 15
                handleHeight: this.trackWidth + 4
                onValueChanged: {
                    if (brightnessMonitor)
                        brightnessMonitor.setBrightness(value);
                }
            }
        }
    }
}
