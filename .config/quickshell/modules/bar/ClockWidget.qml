import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    property bool borderless: true
    property bool showDate: true
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height

    readonly property list<string> clockIcons: ["󱑖", "󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕"]
    property color theme: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.green

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4

        StyledText {
            font.pixelSize: Appearance.font.pixelSize.large
            color: theme
            font.bold: true
            text: clockIcons[DateTime.hour % 12]
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            // Layout.alignment: Qt.AlignVCenter
            implicitHeight: rowLayout.implicitHeight
            implicitWidth: timeText.implicitWidth
            StyledText {
                id: timeText
                anchors.centerIn: parent
                font.pixelSize: Appearance.font.pixelSize.medium
                color: theme
                font.bold: true
                text: `${DateTime.time} | ${DateTime.shortDate}`
            }
        }
    }

    // MouseArea {
    //     id: mouseArea
    //     anchors.fill: parent
    //     hoverEnabled: true
    //     acceptedButtons: Qt.NoButton
    //
    //     ClockWidgetTooltip {
    //         hoverTarget: mouseArea
    //         enableDelay: true
    //     }
    // }
}
