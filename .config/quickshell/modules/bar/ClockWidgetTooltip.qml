import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root
    property string formattedDate: Qt.locale().toString(DateTime.clock.date, "dddd, MMMM dd, yyyy")
    property string formattedTime: DateTime.time
    property string formattedUptime: DateTime.uptime
    readonly property list<string> clockIcons: ["󱑖", "󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕"]

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        spacing: 4

        // Date + Time row
        RowLayout {
            spacing: 5

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.large
                color: Appearance.mocha.text
                font.bold: true
                text: "󰸗"
            }

            StyledText {
                font.pixelSize: Appearance.font.pixelSize.medium
                color: Appearance.mocha.text
                font.bold: true
                text: DateTime.detailedDate
            }
        }

        // Uptime row
        RowLayout {
            spacing: 5
            Layout.fillWidth: true
            StyledText {
                text: "󰔚"
                font.pixelSize: Appearance.font.pixelSize.large
                font.bold: true
                color: Appearance.mocha.text
            }
            StyledText {
                text: "System uptime:"
                color: Appearance.mocha.text
                font.pixelSize: Appearance.font.pixelSize.medium
                font.bold: true
            }
            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Appearance.mocha.text
                font.bold: true
                text: root.formattedUptime
                font.pixelSize: Appearance.font.pixelSize.medium
            }
        }
    }
}
