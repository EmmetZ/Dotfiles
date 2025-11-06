import qs.modules.common
import qs.modules.common.widgets
import QtQuick

GroupButton {
    id: button
    property string buttonIcon
    baseWidth: 35
    baseHeight: 35
    clickedWidth: baseWidth + 20
    toggled: false
    buttonRadius: (altAction && toggled) ? Appearance?.rounding.normal : Math.min(baseHeight, baseWidth) / 2
    buttonRadiusPressed: Appearance?.rounding?.small
    property color colText: (button.down || button.keyboardDown || toggled) ? Appearance.m3colors.m3onPrimary : Appearance.colors.colOnLayer0

    contentItem: StyledText {
        anchors.centerIn: parent
        font.pixelSize: Appearance.font.pixelSize.huge
        font.bold: true
        color: button.colText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: buttonIcon

        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }
    }
}
