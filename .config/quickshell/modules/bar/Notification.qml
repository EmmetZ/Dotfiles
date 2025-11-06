import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    readonly property int tracked: Notifications.list.length

    Layout.fillHeight: true
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height

    RowLayout {
        id: rowLayout

        anchors.centerIn: parent
        spacing: 4

        StyledText {
            id: icon

            font.pixelSize: Appearance.font.pixelSize.normal
            color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.lavender
            font.bold: true
            text: {
                if (Notifications.silent)
                    return "󰪑";

                if (root.tracked > 0)
                    return "󱅫";

                return "󰂜";
            }
        }

        StyledText {
            id: count

            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.mocha.lavender
            font.bold: true
            visible: root.tracked > 0
            text: root.tracked
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: event => {
            if (event.button === Qt.RightButton)
                Notifications.silent = !Notifications.silent;
        }
    }
}
