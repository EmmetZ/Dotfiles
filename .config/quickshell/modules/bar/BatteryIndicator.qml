import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import qs

MouseArea {
    id: root
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

    implicitWidth: batteryProgress.implicitWidth
    implicitHeight: Appearance.bar.height

    hoverEnabled: true

    function getIcon() {
        // console.info(Battery.isPluggedIn, Battery.isCharging, Battery.isFullyCharged);
        if (isCharging && percentage < 1) {
            return "󱐋";
        }
        if (isPluggedIn) {
            return `󰚥`;
        }
        return "";
    }

    ClippedProgressBar {
        id: batteryProgress
        anchors.centerIn: parent
        value: percentage
        highlightColor: {
            if (Config.options.bar.m3theme) {
                return (isLow && !isCharging) ? Appearance.m3colors.m3error : Appearance.m3colors.m3primary;
            }
            return (isLow && !isCharging) ? Appearance.mocha.red : Appearance.mocha.yellow;
        }
        valueBarHeight: 16

        property bool smallFontSize: updateFontSize()
        function updateFontSize() {
            const icon = getIcon();
            const text = batteryProgress.text;
            if (icon && text.length === 3) {
                return true;
            } else {
                return false;
            }
        }

        Item {
            anchors.centerIn: parent
            width: batteryProgress.valueBarWidth
            height: batteryProgress.valueBarHeight

            RowLayout {
                anchors.centerIn: parent
                spacing: 0

                StyledText {
                    id: boltIcon
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: -2
                    Layout.rightMargin: -2
                    text: getIcon()
                    font.pixelSize: batteryProgress.smallFontSize ? Appearance.font.pixelSize.small : Appearance.font.pixelSize.normal
                    font.bold: true
                    visible: isCharging && percentage < 1 || isPluggedIn // TODO: animation
                    color: Appearance.mocha.surface0
                }
                StyledText {
                    Layout.alignment: Qt.AlignVCenter
                    text: batteryProgress.text
                    font.pixelSize: batteryProgress.smallFontSize ? Appearance.font.pixelSize.smaller : Appearance.font.pixelSize.small
                    font.bold: true
                    color: Appearance.mocha.surface0
                }
            }
        }
    }

    BatteryPopup {
        id: batteryPopup
        hoverTarget: root
    }

    acceptedButtons: Qt.LeftButton

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            GlobalStates.sessionOpen = true;
        }
    }
}
