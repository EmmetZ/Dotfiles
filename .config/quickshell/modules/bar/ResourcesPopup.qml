import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services

StyledPopup {
    id: root
    enableDelay: true

    // Helper function to format KB to GB
    function formatKB(kb) {
        return (kb / (1024 * 1024)).toFixed(1) + "G";
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 12

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 8

            ResourceItem {
                icon: "󰾆"
                label: "Memory"
                value: `${formatKB(ResourceUsage.memoryUsed)}`
                percentage: ResourceUsage.memoryUsedPercentage
                color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.blue
            }

            ResourceItem {
                icon: "󰍛"
                label: "CPU"
                value: `${Math.round(ResourceUsage.cpuUsage * 100)}%`
                percentage: ResourceUsage.cpuUsage
                color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.sky
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                StyledText {
                    text: "󰈸"
                    font.weight: Font.DemiBold
                    color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.red
                    font.pixelSize: 40
                }

                ResourceLabel {
                    label: "Temperature"
                    value: `${ResourceUsage.cpuTemp}°C`
                }
            }

            ResourceItem {
                icon: "󰋊"
                label: "Disk"
                value: `${formatKB(ResourceUsage.diskUsed)}`
                percentage: ResourceUsage.diskUsedPercentage
                color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.lavender
            }
        }
    }

    component ResourceItem: RowLayout {
        id: root

        required property string icon
        required property string label
        required property string value
        required property color color
        required property string percentage

        Layout.fillWidth: true

        CircularProgress {
            id: resourceCircProg

            Layout.alignment: Qt.AlignVCenter
            lineWidth: 4
            value: percentage
            implicitSize: 45
            colPrimary: root.color
            enableAnimation: true

            StyledText {
                anchors.centerIn: parent
                font.weight: Font.DemiBold
                text: icon
                color: root.color
                font.pixelSize: Appearance.font.pixelSize.larger
            }
        }

        ResourceLabel {
            label: root.label
            value: root.value
        }
    }

    component ResourceLabel: ColumnLayout {
        id: resourceLabel

        required property string label
        required property string value

        Layout.fillWidth: true
        spacing: 2

        StyledText {
            text: value
            Layout.fillWidth: true
            font.pixelSize: Appearance.font.pixelSize.medium
            color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        StyledText {
            Layout.fillWidth: true
            text: label
            font.pixelSize: Appearance.font.pixelSize.medium
            color: Config.options.bar.m3theme ? Appearance.colors.colSubtext : Appearance.mocha.subtext0
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
