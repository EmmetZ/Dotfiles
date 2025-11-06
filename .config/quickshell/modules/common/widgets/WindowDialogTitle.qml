import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

StyledText {
    text: "Dialog Title"
    font {
        pixelSize: Appearance.font.pixelSize.title
        family: Appearance.font.family.sans
    }
    color: Appearance.m3colors.m3onSurface
}
