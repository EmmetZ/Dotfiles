pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool hovered: false
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height

    hoverEnabled: true

    onClicked: {
        Weather.getData();
        Quickshell.execDetached(["notify-send", 
            "Weather", 
            "Refreshing (manually triggered)"
            , "-a", "Shell"
        ])
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        StyledText {
            text: WeatherIcons.codeToName[Weather.data.wCode] ?? "󰖐"
            font.pixelSize: Appearance.font.pixelSize.large
            font.bold: true
            color: Appearance.mocha.yellow
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.mocha.yellow
            text: Weather.data?.temp ?? "--°"
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    WeatherPopup {
        id: weatherPopup
        hoverTarget: root
    }
}
