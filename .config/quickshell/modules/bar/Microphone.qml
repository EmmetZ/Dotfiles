import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    property bool muted: Audio.getMicMuted()
    property int volume: Audio.getMicVolume()
    property color mcolor: Appearance.mocha.green
    property color theme: {
        let color = Appearance.mocha.green;
        if (Config.options.bar.m3theme) {
            color =  Appearance.colors.colPrimary;
        }
        return muted ? ColorUtils.applyAlpha(color, 0.7) : color;
    }

    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height
    Layout.fillHeight: true

    RowLayout {
        id: rowLayout

        anchors.verticalCenter: parent.verticalCenter
        Layout.fillHeight: true
        spacing: 2

        StyledText {
            text: muted ? "󰍭" : "󰍬"
            color: theme
            font.bold: true
            font.pixelSize: Appearance.font.pixelSize.normal
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onClicked: event => {
            if (event.button === Qt.LeftButton)
                Audio.setMicMuted(!muted);
        }

        StyledPopup {
            hoverTarget: mouseArea
            enableDelay: true
            margin: 8

            RowLayout {
                anchors.centerIn: parent

                StyledText {
                    text: Audio?.source?.description ?? "unknown"
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.bold: true
                    color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                }
            }
        }
    }
}
