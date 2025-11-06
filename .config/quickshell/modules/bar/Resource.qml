import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    property string icon: ""
    property double percentage: ResourceUsage.memoryUsedPercentage
    property color theme: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.blue
    property string text: ` ${formatKB(ResourceUsage.memoryUsed)}`
    property int warningThreshold: 100
    property bool shown: true
    property bool warning: percentage * 100 >= warningThreshold

    clip: true
    visible: width > 0 && height > 0
    implicitWidth: resourceRowLayout.x < 0 ? 0 : resourceRowLayout.implicitWidth
    implicitHeight: Appearance.bar.height

    // Helper function to format KB to GB
    function formatKB(kb) {
        return (kb / (1024 * 1024)).toFixed(1) + "G";
    }

    RowLayout {
        id: resourceRowLayout

        spacing: 2
        x: shown ? 0 : -resourceRowLayout.width

        anchors {
            verticalCenter: parent.verticalCenter
        }

        CircularProgress {
            id: resourceCircProg

            Layout.alignment: Qt.AlignVCenter
            lineWidth: Appearance.rounding.unsharpen
            value: percentage
            implicitSize: 18
            colPrimary: root.theme
            enableAnimation: false

            StyledText {
                anchors.centerIn: parent
                font.weight: Font.DemiBold
                text: icon
                color: root.theme
                font.pixelSize: Appearance.font.pixelSize.smallest
            }
        }

        Item {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: fullPercentageTextMetrics.width
            implicitHeight: resourceRowLayout.implicitHeight

            TextMetrics {
                id: fullPercentageTextMetrics

                text: root.text
                font.pixelSize: Appearance.font.pixelSize.medium
                font.weight: Font.Bold
            }

            StyledText {
                id: percentageText1

                anchors.centerIn: parent
                color: root.theme
                font.pixelSize: Appearance.font.pixelSize.medium
                font.weight: Font.Bold
                text: root.text
            }
        }

        Behavior on x {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        enabled: resourceRowLayout.x >= 0 && root.width > 0 && root.visible
    }

    ResourcesPopup {
        hoverTarget: mouseArea
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
}
