import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height
    Layout.fillHeight: true

    RowLayout {
        id: rowLayout

        anchors.verticalCenter: parent.verticalCenter
        Layout.fillHeight: true
        spacing: 2

        StyledText {
            id: icon

            text: Network.materialSymbol
            color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.rosewater
            font.bold: true
            font.pixelSize: Appearance.font.pixelSize.normal
        }
    }
}
