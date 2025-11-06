import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root
    margin: 6
    enableDelay: true

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        // spacing: 4

        // Header
        // RowLayout {
        //     id: header
        //     spacing: 5
        //
        //     StyledText {
        //         font.bold: true
        //         text: "󰁹"
        //         font.pixelSize: Appearance.font.pixelSize.normal
        //         color: Appearance.mocha.text
        //     }
        //
        //     StyledText {
        //         text: "Battery"
        //         font {
        //             bold: true
        //             pixelSize: Appearance.font.pixelSize.small
        //         }
        //         color: Appearance.mocha.text
        //     }
        // }

        // This row is hidden when the battery is full.
        Row {
            // spacing: 5
            Layout.fillWidth: true
            property bool rowVisible: {
                let timeValue = Battery.isCharging ? Battery.timeToFull : Battery.timeToEmpty;
                let power = Battery.energyRate;
                return !(Battery.chargeState == 4 || timeValue <= 0 || power <= 0.01);
            }
            visible: rowVisible
            opacity: rowVisible ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }

            StyledText {
                text: "󰥔"
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                font.pixelSize: Appearance.font.pixelSize.normal
                font.bold: true
            }
            StyledText {
                text: Battery.isCharging ? "Time to full:" : "Time to empty:"
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                font.pixelSize: Appearance.font.pixelSize.small
                font.bold: true
            }
            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                font.pixelSize: Appearance.font.pixelSize.small
                font.bold: true
                text: {
                    function formatTime(seconds) {
                        var h = Math.floor(seconds / 3600);
                        var m = Math.floor((seconds % 3600) / 60);
                        if (h > 0)
                            return `${h}h, ${m}m`;
                        else
                            return `${m}m`;
                    }
                    if (Battery.isCharging)
                        return formatTime(Battery.timeToFull);
                    else
                        return formatTime(Battery.timeToEmpty);
                }
            }
        }

        Row {
            // spacing: 5
            Layout.fillWidth: true

            property bool rowVisible: !(Battery.chargeState != 4 && Battery.energyRate == 0)
            visible: rowVisible
            opacity: rowVisible ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }

            StyledText {
                text: "󱐋"
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                font.bold: true
            }

            StyledText {
                text: {
                    if (Battery.chargeState == 4) {
                        return "Fully charged";
                    } else if (Battery.chargeState == 1) {
                        return "Charging:";
                    } else {
                        return "Discharging:";
                    }
                }
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                font.pixelSize: Appearance.font.pixelSize.small
                font.bold: true
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                text: {
                    if (Battery.chargeState == 4) {
                        return "";
                    } else {
                        return `${Battery.energyRate.toFixed(2)}W`;
                    }
                }
                font.pixelSize: Appearance.font.pixelSize.small
                font.bold: true
            }
        }
    }
}
