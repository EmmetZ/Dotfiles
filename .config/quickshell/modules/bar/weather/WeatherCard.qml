import QtQuick
import QtQuick.Layouts

import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    radius: Appearance.rounding.small
    color: Appearance.mocha.surface1
    implicitWidth: columnLayout.implicitWidth + 14 * 2
    implicitHeight: columnLayout.implicitHeight + 14 * 2
    Layout.fillWidth: parent

    property alias title: title.text
    property alias value: value.text
    property alias symbol: symbol.text

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: -10
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            StyledText {
                id: symbol
                font.pixelSize: Appearance.font.pixelSize.normal
                font.bold: true
                color: Appearance.mocha.text
            }
            StyledText {
                id: title
                font.pixelSize: Appearance.font.pixelSize.smaller
                font.bold: true
                color: Appearance.mocha.text
            }
        }
        StyledText {
            id: value
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.small
            font.bold: true
            color: Appearance.mocha.text
        }
    }
}
