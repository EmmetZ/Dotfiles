import Quickshell
import QtQuick
import qs.modules.common
import qs
import qs.modules.common.widgets
import qs.modules.common.functions
import Quickshell
import qs.services
import qs.modules.bar.mediaControls
import qs.modules.bar.systray
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property var screen: root.QsWindow.window?.screen
    property int spacing: 16
    property bool enableShadow: Appearance.bar.enableShadow
    property int margin: enableShadow ? 6 : 4
    // property var brightnessMonitor: Brightness.getMonitorForScreen(screen)

    // Background shadow
    Loader {
        active: root.enableShadow
        anchors.fill: barBackground
        sourceComponent: StyledRectangularShadow {
            anchors.fill: undefined
            target: barBackground
        }
    }

    Rectangle {
        id: barBackground

        anchors {
            fill: parent
            margins: root.enableShadow ? Appearance.sizes.hyprlandGapsOut : 0
        }

        color: Config.options.bar.m3theme ? Appearance.colors.colLayer0 : Appearance.colors.bar.background
        radius: Appearance.bar.radius
    }

    component VerticalBarSeparator: Rectangle {
        Layout.topMargin: Appearance.bar.height / 4
        Layout.bottomMargin: Appearance.bar.height / 4
        Layout.leftMargin: 4
        Layout.rightMargin: 4
        Layout.fillHeight: true
        implicitWidth: 1
        color: Appearance.mocha.overlay2
    }

    RowLayout {
        id: leftSection
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: middleSection.left
            leftMargin: root.margin
        }
        // BarGroup {
        //     columnSpacing: root.spacing
        //     Logo {}
        //     ActiveWindow {
        //         Layout.maximumWidth: 200
        //     }
        // }
        BarGroup {
            columnSpacing: root.spacing
            Logo {}
            Resource {}

            Workspacess {}

            Media {
                id: media
                Layout.maximumWidth: 180

                MediaControls {
                    anchorItem: media
                }
            }
        }
    }

    RowLayout {
        id: middleSection
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        // BarGroup {
        //     columnSpacing: root.spacing
        //     Resource {}
        //     Media {
        //         id: media
        //         Layout.maximumWidth: 180
        //
        //         MediaControls {
        //             anchorItem: media
        //         }
        //     }
        //
        //     Workspacess {}
        // }
        //
        // BarGroup {
        //     columnSpacing: root.spacing
        //
        //     TimeMenuButton {}
        // }
        //
        // BarGroup {
        //     columnSpacing: root.spacing
        //
        //     RowLayout {
        //         id: rowLayout
        //         Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        //
        //         PulseAudio {}
        //         BrightnessWidget {}
        //         Microphone {}
        //     }
        // }

        BarGroup {
            columnSpacing: root.spacing

            TimeMenuButton {}
        }
    }

    RowLayout {
        id: rightSection
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: middleSection.right
            right: parent.right
            rightMargin: root.margin
        }
        layoutDirection: Qt.RightToLeft

        // BarGroup {
        //     columnSpacing: root.spacing
        //
        //     SysTray {}
        //     UtilsButton {}
        //
        //     // BatteryWidget {}
        //     BatteryIndicator {}
        // }

        BarGroup {
            columnSpacing: root.spacing

            SysTray {}

            RowLayout {
                id: rowLayout
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                PulseAudio {}
                BrightnessWidget {}
                Microphone {}
                VerticalBarSeparator {}

                UtilsButton {}
            }

            // BatteryWidget {}
            BatteryIndicator {}
        }
    }
}
