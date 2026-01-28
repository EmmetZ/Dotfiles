import QtQuick
import QtQuick.Layouts
import qs
import qs.modules.common
import qs.modules.common.widgets

Item {
    implicitWidth: logoContainer.implicitWidth

    RowLayout {
        id: logoContainer

        implicitHeight: Appearance.bar.height

        anchors {
            verticalCenter: parent.verticalCenter
        }

        StyledText {
            id: logo

            text: ""
            color: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.blue
            font.pixelSize: Appearance.font.pixelSize.normal
            font.bold: true

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onPressed: event => {
                    if (event.button === Qt.LeftButton)
                        GlobalStates.overviewOpen = true;
                }
            }
        }
    }
}
