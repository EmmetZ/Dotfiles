import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.services
import Quickshell.Hyprland
import qs.modules.common.widgets
import qs.modules.common

Item {
    id: root
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height
    Layout.fillHeight: true

    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)
    property real brightness: {
        return brightnessMonitor ? brightnessMonitor.brightness : 0;
    }
    property color theme: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.mauve

    RowLayout {
        id: rowLayout

        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        spacing: 2

        StyledText {
            // animateChange: true
            animationDistanceY: 0
            text: Icons.getBrightnessIcon(brightness)
            font.bold: true
            color: theme
            font.pixelSize: Appearance.font.pixelSize.normal
        }

        StyledText {
            text: Math.round(root.brightness * 100)
            font.bold: true
            color: theme
            font.pixelSize: Appearance.font.pixelSize.small
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        WheelHandler {
            onWheel: event => {
                let variable;
                if (event.angleDelta.y > 0) {
                    Brightness.increaseBrightness(0.01);
                } else if (event.angleDelta.y < 0) {
                    Brightness.decreaseBrightness(0.01);
                }
            }
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        }

        // StyledPopup {
        //     hoverTarget: mouseArea
        //     enableDelay: true
        //     margin: 8
        //
        //     RowLayout {
        //         anchors.centerIn: parent
        //
        //         StyledText {
        //             text: `${Math.round(root.brightness * 100)}%`
        //             font.pixelSize: Appearance.font.pixelSize.small
        //             font.bold: true
        //             color: Appearance.mocha.text
        //         }
        //     }
        // }
    }
}
