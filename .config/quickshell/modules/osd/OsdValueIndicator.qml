import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.common.functions

Item {
    id: root
    required property real value
    required property string icon
    property real iconSize: 20

    property real valueIndicatorWidth: Appearance.sizes.osdWidth
    property real valueIndicatorHeight: Appearance.sizes.osdHeight

    property real borderWidth: 2
    property real padding: 2
    property real iconPadding: 4
    property real radius: 6

    property real highlightHeight: valueIndicatorHeight - 2 * padding

    Layout.margins: Appearance.sizes.elevationMargin
    implicitWidth: valueIndicatorBackground.implicitWidth
    implicitHeight: valueIndicatorBackground.implicitHeight

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    StyledRectangularShadow {
        target: valueIndicatorBackground
        blur: 0.8 * Appearance.sizes.elevationMargin
    }

    Rectangle {
        id: valueIndicatorBackground
        implicitWidth: valueIndicatorWidth
        implicitHeight: valueIndicatorHeight
        radius: root.radius
        color: ColorUtils.applyAlpha(Appearance?.m3colors.m3secondaryContainer ?? "#F1D3F9", 0.9)
        border.width: borderWidth
        border.color: Appearance?.m3colors.m3secondaryContainer ?? "#F1D3F9"
    }

    Rectangle {
        id: valueIndicator
        // anchors.bottom: valueIndicatorBackground.bottom
        anchors {
            left: valueIndicatorBackground.left
            right: valueIndicatorBackground.right
            bottom: valueIndicatorBackground.bottom
            bottomMargin: padding
            leftMargin: padding
            rightMargin: padding
            topMargin: padding
        }

        implicitWidth: valueIndicatorWidth
        implicitHeight: highlightHeight * value
        color: Appearance?.colors.colPrimary ?? "#685496"
        radius: root.radius

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Appearance.animation.menuDecel.duration
                easing.type: Appearance.animation.menuDecel.type
            }
        }
    }

    StyledText {
        id: osdIcon
        text: icon
        font.pixelSize: iconSize
        font.bold: true
        color: value * highlightHeight > Math.round((iconPadding + percentageText.height) * 1.3) ? Appearance?.colors.colOnPrimary : Appearance.colors.colPrimary

        anchors {
            horizontalCenter: valueIndicatorBackground.horizontalCenter
            bottom: valueIndicatorBackground.bottom
            bottomMargin: Math.max(highlightHeight * value - iconSize - iconPadding, iconPadding + percentageText.height)
        }

        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: Appearance.animation.menuDecel.duration
                easing.type: Appearance.animation.menuDecel.type
            }
        }

        Behavior on color {
            animation: Appearance.animation.elementMove.colorAnimation.createObject(this)
        }
    }

    StyledText {
        id: percentageText
        text: Math.round(value * 100)
        font.pixelSize: Appearance.font.pixelSize.normal
        font.bold: true
        color: value * highlightHeight > Math.round(percentageText.height * 0.5) ? Appearance?.colors.colOnPrimary : Appearance.colors.colPrimary

        anchors {
            horizontalCenter: valueIndicatorBackground.horizontalCenter
            bottom: valueIndicatorBackground.bottom
            bottomMargin: iconPadding
        }

        Behavior on color {
            animation: Appearance.animation.elementMove.colorAnimation.createObject(this)
        }
    }
}
