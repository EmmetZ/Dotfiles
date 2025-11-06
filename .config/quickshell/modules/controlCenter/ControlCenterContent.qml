import qs.modules.controlCenter.wifiNetworks
import qs.modules.controlCenter.quickToggles
import qs.modules.controlCenter.bluetoothDevices
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services

Item {
    id: root

    property int menuWidth: Appearance.sizes.controlCenterWidth
    property int menuPadding: 12
    // property string settingsQmlPath: Quickshell.shellPath("settings.qml")
    property bool showWifiDialog: false
    property bool showBluetoothDialog: false

    implicitHeight: menuBackground.implicitHeight
    implicitWidth: menuBackground.implicitWidth
    onShowWifiDialogChanged: {
        if (showWifiDialog)
            wifiDialogLoader.active = true;
    }
    onShowBluetoothDialogChanged: {
        if (showBluetoothDialog)
            bluetoothDialogLoader.active = true;
        else
            Bluetooth.defaultAdapter.discovering = false;
    }

    Connections {
        function onControlCenterOpenChanged() {
            if (!GlobalStates.controlCenterOpen) {
                root.showWifiDialog = false;
                root.showBluetoothDialog = false;
            }
        }

        target: GlobalStates
    }

    StyledRectangularShadow {
        target: menuBackground
    }

    Rectangle {
        id: menuBackground

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        implicitHeight: parent.height - Appearance.sizes.hyprlandGapsOut * 2
        implicitWidth: menuWidth - Appearance.sizes.hyprlandGapsOut * 2
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border
        radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: menuPadding
            spacing: menuPadding

            RowLayout {
                Layout.fillHeight: false
                spacing: 10
                Layout.leftMargin: 5
                Layout.rightMargin: 5

                StyledText {
                    id: distroIcon

                    font.pixelSize: Appearance.font.pixelSize.hugeass
                    font.bold: true
                    text: SystemInfo.distroIcon
                    color: Appearance.colors.colOnLayer0
                }

                StyledText {
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colOnLayer0
                    text: "Up %1".arg(DateTime.uptime)
                    font.bold: true
                    textFormat: Text.MarkdownText
                }

                Item {
                    Layout.fillWidth: true
                }

                ButtonGroup {
                    spacing: 3
                    QuickToggleButton {
                        toggled: false
                        buttonIcon: "󰜉"
                        onClicked: {
                            Quickshell.execDetached(["hyprctl", "reload"]);
                            Quickshell.reload(true);
                        }

                        StyledToolTip {
                            text: "Reload Hyprland & Quickshell"
                        }
                    }

                    QuickToggleButton {
                        buttonIcon: "󱠓"

                        toggled: false 
                        onClicked: {
                            Appearance.reloadTheme();
                        }

                        StyledToolTip {
                            text: "Refresh color scheme"
                        }
                    }

                    ThemeToggle {}
                    
                    QuickToggleButton {
                        toggled: false
                        buttonIcon: "󰐥"
                        onClicked: {
                            GlobalStates.sessionOpen = true;
                        }

                        StyledToolTip {
                            text: "Session"
                        }
                    }
                }
            }

            RowLayout {
                id: middleRow
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.topMargin: 0
                Layout.bottomMargin: 0

                ButtonGroup {
                    Layout.alignment: Qt.AlignLeft
                    spacing: 3
                    padding: 5
                    color: Appearance.colors.colLayer1

                    NetworkToggle {
                        altAction: () => {
                            Network.enableWifi();
                            Network.rescanWifi();
                            root.showWifiDialog = true;
                        }
                    }

                    BluetoothToggle {
                        altAction: () => {
                            Bluetooth.defaultAdapter.enabled = true;
                            Bluetooth.defaultAdapter.discovering = true;
                            root.showBluetoothDialog = true;
                        }
                    }

                    GameMode {}
                    IdleInhibitor {}
                    NightLight {}
                    // ThemeToggle {}
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    implicitHeight: middleRow.height

                    Rectangle {
                        id: separator
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                        width: 2
                        implicitHeight: middleRow.height * 0.4
                        implicitWidth: parent.width
                        radius: Appearance.rounding.full
                        color: ColorUtils.applyAlpha(Appearance.colors.colOutline, 0.4)
                    }
                }

                PowerProfileToggle {}
            }

            SliderGroup {
                Layout.fillWidth: true
            }

            BottomWidgetGroup {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            // BottomWidgetGroup {
            //     Layout.alignment: Qt.AlignHCenter
            //     Layout.fillHeight: false
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: implicitHeight
            // }
        }
    }

    Loader {
        id: wifiDialogLoader

        anchors.fill: parent
        active: root.showWifiDialog || item.visible
        onActiveChanged: {
            if (active) {
                item.show = true;
                item.forceActiveFocus();
            }
        }

        sourceComponent: WifiDialog {
            onDismiss: {
                show = false;
                root.showWifiDialog = false;
            }
            onVisibleChanged: {
                if (!visible && !root.showWifiDialog)
                    wifiDialogLoader.active = false;
            }
        }
    }

    Loader {
        id: bluetoothDialogLoader

        anchors.fill: parent
        active: root.showBluetoothDialog || item.visible
        onActiveChanged: {
            if (active) {
                item.show = true;
                item.forceActiveFocus();
            }
        }

        sourceComponent: BluetoothDialog {
            onDismiss: {
                show = false;
                root.showBluetoothDialog = false;
            }
            onVisibleChanged: {
                if (!visible && !root.showBluetoothDialog)
                    bluetoothDialogLoader.active = false;
            }
        }
    }
}
