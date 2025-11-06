import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.services
import qs.modules.common.widgets
import qs.modules.common
import qs

Item {
    id: root
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height
    Layout.fillHeight: true

    property real percentage: Battery.percentage

    readonly property list<string> icons: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    function getIcon() {
        // console.info(Battery.isPluggedIn, Battery.isCharging, Battery.isFullyCharged);
        const icon = icons[Math.floor(Math.round(percentage * 100) / 10)];
        if (Battery.isCharging) {
            return "󰂄";
        }
        if (Battery.isPluggedIn) {
            return `󱘖${icon}`;
        }
        return icon;
    }

    function formatTime(seconds) {
        if (seconds <= 0 || seconds === Infinity)
            return "N/A";
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const secs = Math.floor(seconds % 60);
        if (hours === 0) {
            return (minutes > 0 ? minutes + "m " : "") + (secs > 0 ? secs + "s" : "");
        }
        return hours + "h " + (minutes > 0 ? minutes + "m" : "");
    }

    function getTooltip() {
        if (Battery.isCharging) {
            return `Charging: ${formatTime(Battery.timeToFull)} (${Battery.energyRate.toFixed(2)}W)`;
        }
        if (Battery.isFullyCharged) {
            return `Full, ${Battery.energyRate}W`;
        }
        if (Battery.isPluggedIn) {
            return `Plugged in, ${Battery.energyRate}W`;
        }
        if (!Battery.isCharging) {
            return `Time to empty: ${formatTime(Battery.timeToEmpty)} (${Battery.energyRate.toFixed(2)}W)`;
        }
        return "Battery status unknown";
    }

    RowLayout {
        id: rowLayout

        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        spacing: 2

        StyledText {
            text: getIcon()
            font.bold: true
            color: Appearance.mocha.yellow
            font.pixelSize: Appearance.font.pixelSize.normal
        }

        StyledText {
            text: Math.round(root.percentage * 100)
            font.bold: true
            color: Appearance.mocha.yellow
            font.pixelSize: Appearance.font.pixelSize.small
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                GlobalStates.sessionOpen = true;
            }
        }

        StyledPopup {
            hoverTarget: mouseArea
            enableDelay: true
            margin: 8

            RowLayout {
                anchors.centerIn: parent

                StyledText {
                    text: getTooltip()
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.bold: true
                    color: Appearance.mocha.text
                }
            }
        }
    }
}
