import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs

LazyLoader {
    id: root

    property Item hoverTarget
    property bool hoverEnabled: false
    property bool altCondition: true
    default property Item contentItem
    property real popupBackgroundMargin: 0
    property bool enableDelay: false
    property real margin: 10
    property bool popupContainsMouse: false
    active: (hoverTarget && hoverTarget.containsMouse && (!enableDelay || GlobalStates.barTooltipOpen)) && altCondition || (hoverEnabled && popupContainsMouse)

    component: PanelWindow {
        id: popupWindow
        color: "transparent"

        anchors.left: !Config.options.bar.vertical || (Config.options.bar.vertical && !Config.options.bar.bottom)
        anchors.right: Config.options.bar.vertical && Config.options.bar.bottom
        anchors.top: Config.options.bar.vertical || (!Config.options.bar.vertical && !Config.options.bar.bottom)
        anchors.bottom: !Config.options.bar.vertical && Config.options.bar.bottom

        implicitWidth: popupBackground.implicitWidth + Appearance.sizes.hyprlandGapsOut * 2 + root.popupBackgroundMargin
        implicitHeight: popupBackground.implicitHeight + Appearance.sizes.hyprlandGapsOut * 2 + root.popupBackgroundMargin

        mask: Region {
            item: popupBackground
        }

        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        margins {
            left: {
                if (!Config.options.bar.vertical) {
                    let margin = root.QsWindow?.mapFromItem(root.hoverTarget, (root.hoverTarget.width - popupBackground.implicitWidth) / 2, 0).x;

                    // Get the window's position on the screen
                    let windowX = root.QsWindow?.screenX ?? 0;
                    let screenWidth = popupWindow.screen?.width ?? root.QsWindow.width;

                    if (margin < 0) {
                        // console.warn("Popup position adjusted to prevent left overflow");
                        return 0;
                    }
                    // Check if popup would go beyond right edge of screen
                    if (windowX + margin + popupBackground.implicitWidth + 10 > screenWidth) {
                        // console.warn("Popup position adjusted to prevent right overflow");
                        return Math.max(0, screenWidth - popupBackground.implicitWidth - windowX - 10);
                    }
                    return margin;
                }
                return Appearance.bar.verticalBarWidth;
            }
            top: {
                if (!Config.options.bar.vertical)
                    return Appearance.bar.height;
                let margin = root.QsWindow?.mapFromItem(root.hoverTarget, (root.hoverTarget.height - popupBackground.implicitHeight) / 2, 0).y;

                // Get the window's position on the screen
                let windowY = root.QsWindow?.screenY ?? 0;
                let screenHeight = popupWindow.screen?.height ?? root.QsWindow.height;

                if (margin < 0) {
                    // console.warn("Popup position adjusted to prevent top overflow");
                    return 0;
                }
                // Check if popup would go beyond bottom edge of screen
                if (windowY + margin + popupBackground.implicitHeight > screenHeight) {
                    // console.warn("Popup position adjusted to prevent bottom overflow");
                    return Math.max(0, screenHeight - popupBackground.implicitHeight - windowY);
                }
                return margin;
            }
            right: Appearance.bar.verticalBarWidth
            bottom: Appearance.bar.height
        }
        WlrLayershell.namespace: "quickshell:popup"
        WlrLayershell.layer: WlrLayer.Overlay

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: popupWindow.visible
            onEntered: root.popupContainsMouse = true
            onExited: root.popupContainsMouse = false
        }

        StyledRectangularShadow {
            target: popupBackground
        }

        Rectangle {
            id: popupBackground
            // readonly property real margin: 10
            anchors {
                fill: parent
                leftMargin: Appearance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.left)
                rightMargin: Appearance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.right)
                topMargin: Appearance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.top)
                bottomMargin: Appearance.sizes.hyprlandGapsOut + root.popupBackgroundMargin * (!popupWindow.anchors.bottom)
            }
            implicitWidth: root.contentItem.implicitWidth + root.margin * 2
            implicitHeight: root.contentItem.implicitHeight + root.margin * 2
            color: {
                if (Config.options.bar.m3theme) {
                    return ColorUtils.applyAlpha(Appearance.colors.colSurfaceContainer, 1 - Appearance.backgroundTransparency);
                } else {
                    Appearance.colors.bar.popupBackground;
                }
            }
            radius: Appearance.rounding.small
            children: [root.contentItem]

            border.width: 1
            border.color: {
                if (Config.options.bar.m3theme) {
                    return Appearance.colors.colLayer0Border;
                } else {
                    return Appearance.colors.bar.border;
                }
            }
        }
    }
}
