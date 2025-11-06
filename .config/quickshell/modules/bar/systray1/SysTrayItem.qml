import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import Quickshell.Hyprland
import QtQuick.Effects
import Quickshell.Wayland
import qs.modules.bar

MouseArea {
    id: root

    property var bar: root.QsWindow.window
    required property SystemTrayItem item
    property bool targetMenuOpen: false
    hoverEnabled: true

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 16
    implicitHeight: 16
    onClicked: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) {
                root.targetMenuOpen = !root.targetMenuOpen;
            }
            break;
        }
        event.accepted = true;
    }

    IconImage {
        id: trayIcon
        // visible: !Config.options.bar.tray.monochromeIcons
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    Loader {
        active: Config.options.bar.tray.monochromeIcons
        anchors.fill: trayIcon
        sourceComponent: Item {
            Desaturate {
                id: desaturatedIcon
                visible: false // There's already color overlay
                anchors.fill: parent
                source: trayIcon
                desaturation: Config.options.bar.m3theme ? 0.3 : 0 // 1.0 means fully grayscale
            }
            ColorOverlay {
                anchors.fill: desaturatedIcon
                source: desaturatedIcon
                color: ColorUtils.transparentize(Appearance.colors.colOnLayer0, 0.9)
            }
        }
    }

    StyledPopup {
        hoverTarget: root
        enableDelay: true
        altCondition: !root.targetMenuOpen
        margin: 8

        RowLayout {
            anchors.centerIn: parent

            StyledText {
                id: popupTextItem
                property string content: root.item.tooltipTitle.length > 0 ? root.item.tooltipTitle : root.item.title

                text: content
                font.pixelSize: Appearance.font.pixelSize.small
                font.bold: true
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
            }
        }
    }
    onEntered: {
        const content = root.item.tooltipTitle.length > 0 ? root.item.tooltipTitle : root.item.title;
        if (content !== content.displayText) {
            popupTextItem.content = content;
        }
    }

    Loader {
        id: menuLoader

        property Item target: root
        property real margin: 5
        active: root.targetMenuOpen

        sourceComponent: PanelWindow {
            id: popupWindow
            color: "transparent"

            anchors.left: !Config.options.bar.vertical || (Config.options.bar.vertical && !Config.options.bar.bottom)
            anchors.right: Config.options.bar.vertical && Config.options.bar.bottom
            // anchors.top: Config.options.bar.vertical || (!Config.options.bar.vertical && !Config.options.bar.bottom)
            // anchors.bottom: !Config.options.bar.vertical && Config.options.bar.bottom
            anchors.bottom: true
            anchors.top: true

            implicitWidth: popupBackground.implicitWidth
            // implicitHeight: popupBackground.implicitHeight

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0

            margins {
                left: {
                    if (!Config.options.bar.vertical) {
                        let margin = menuLoader.QsWindow?.mapFromItem(menuLoader.target, (menuLoader.target.width - popupBackground.implicitWidth) / 2, 0).x;

                        // Get the window's position on the screen
                        let windowX = menuLoader.QsWindow?.screenX ?? 0;
                        let screenWidth = popupWindow.screen?.width ?? menuLoader.QsWindow.width;

                        if (margin < 0) {
                            console.warn("Popup position adjusted to prevent left overflow");
                            return 0;
                        }
                        // Check if popup would go beyond right edge of screen
                        if (windowX + margin + popupBackground.implicitWidth + 10 > screenWidth) {
                            console.warn("Popup position adjusted to prevent right overflow");
                            return Math.max(0, screenWidth - popupBackground.implicitWidth - windowX - 10);
                        }
                        return margin;
                    }
                    return Appearance.bar.verticalBarWidth;
                }
                top: {
                    if (!Config.options.bar.vertical)
                        return Appearance.bar.height + Appearance.sizes.hyprlandGapsOut;
                    let margin = menuLoader.QsWindow?.mapFromItem(menuLoader.target, (menuLoader.target.height - popupBackground.implicitHeight) / 2, 0).y;

                    // Get the window's position on the screen
                    let windowY = menuLoader.QsWindow?.screenY ?? 0;
                    let screenHeight = popupWindow.screen?.height ?? menuLoader.QsWindow.height;

                    if (margin < 0) {
                        console.warn("Popup position adjusted to prevent top overflow");
                        return 0;
                    }
                    // Check if popup would go beyond bottom edge of screen
                    if (windowY + margin + popupBackground.implicitHeight > screenHeight) {
                        console.warn("Popup position adjusted to prevent bottom overflow");
                        return Math.max(0, screenHeight - popupBackground.implicitHeight - windowY);
                    }
                    return margin;
                }
                right: Appearance.bar.verticalBarWidth
                // bottom: Appearance.bar.height
            }

            WlrLayershell.namespace: "quickshell:trayMenu"
            WlrLayershell.layer: WlrLayer.Overlay

            MouseArea {
                id: mouseArea
                anchors.fill: parent
            }

            HyprlandFocusGrab {
                windows: [popupWindow]
                active: menuLoader.active
                onCleared: () => {
                    if (!active) {
                        root.targetMenuOpen = false;
                    }
                }
            }

            RectangularShadow {
                property var target: popupBackground
                anchors.fill: target
                radius: target.radius
                blur: 0.9 * Appearance.sizes.hyprlandGapsOut
                offset: Qt.vector2d(0.0, 1.0)
                spread: 0.7
                color: Appearance.colors.colShadow
                cached: true
            }

            Rectangle {
                id: popupBackground
                anchors {
                    // fill: parent
                    leftMargin: Appearance.sizes.hyprlandGapsOut
                    rightMargin: Appearance.sizes.hyprlandGapsOut
                    topMargin: Appearance.sizes.hyprlandGapsOut
                    bottomMargin: Appearance.sizes.hyprlandGapsOut
                }
                implicitWidth: row.implicitWidth + menuLoader.margin * 2
                implicitHeight: row.implicitHeight + menuLoader.margin * 2
                color: ColorUtils.applyAlpha(Appearance.colors.colSurfaceContainer, 1);
                radius: Appearance.rounding.verysmall

                RowLayout {
                    id: row
                    anchors.centerIn: parent

                    MenuView {
                        id: menuView
                        menu: root.item.menu
                        onClose: {
                            root.targetMenuOpen = false;
                        }
                    }
                }
            }
        }
    }
}
