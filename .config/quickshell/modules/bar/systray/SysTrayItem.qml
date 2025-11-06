import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import qs.modules.bar

MouseArea {
    id: root
    required property SystemTrayItem item
    property bool targetMenuOpen: false
    property int index

    signal menuOpened(qsWindow: var)
    signal menuClosed()

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 16
    implicitHeight: 16
    onPressed: (event) => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) menu.open();
            break;
        }
        event.accepted = true;
    }
    onEntered: {
        tooltip.text = item.tooltipTitle.length > 0 ? item.tooltipTitle
                : (item.title.length > 0 ? item.title : item.id);
        if (item.tooltipDescription.length > 0) tooltip.text += " • " + item.tooltipDescription;
        if (Config.options.bar.tray.showItemId) tooltip.text += "\n[" + item.id + "]";
    }

    Loader {
        id: menu
        function open() {
            menu.active = true;
        }
        active: false
        sourceComponent: SysTrayMenu {
            Component.onCompleted: this.open();
            trayItemMenuHandle: root.item.menu
            anchor {
                window: root.QsWindow.window
                // rect.x: root.x + (Config.options.bar.vertical ? 0 : QsWindow.window?.width)
                rect.x: {
                    if (!Config.options.bar.vertical) {
                        let margin = menu.QsWindow?.mapFromItem(root, (-root.width - this.implicitWidth) / 2 - (root.width + 3) * root.index, 0).x;

                        // // Get the window's position on the screen
                        let windowX = menu.QsWindow?.screenX ?? 0;
                        let screenWidth = this.screen?.width ?? menu.QsWindow.width;

                        if (margin < 0) {
                            console.warn("Popup position adjusted to prevent left overflow");
                            return 0;
                        }
                        // Check if popup would go beyond right edge of screen
                        if (windowX + margin + this.implicitWidth + 10 > screenWidth) {
                            console.warn("Popup position adjusted to prevent right overflow");
                            return Math.max(0, screenWidth - this.implicitWidth - windowX - 10);
                        }
                        return margin + root.x;
                    }
                    return QsWindow.window?.width;
                }
                rect.y: root.y + (Config.options.bar.vertical ? QsWindow.window?.height : 0)
                rect.height: root.height
                rect.width: root.width
                edges: Config.options.bar.bottom ? (Edges.Top | Edges.Left) : (Edges.Bottom | Edges.Right)
                gravity: Config.options.bar.bottom ? (Edges.Top | Edges.Left) : (Edges.Bottom | Edges.Right)
            }
            onMenuOpened: (window) => root.menuOpened(window);
            onMenuClosed: {
                root.menuClosed();
                menu.active = false;
            }
        }
    }

    IconImage {
        id: trayIcon
        visible: !Config.options.bar.tray.monochromeIcons
        source: {
            let icon = root.item.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
        // asynchronous: true
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

    // PopupToolTip {
    //     id: tooltip
    //     extraVisibleCondition: root.containsMouse
    //     alternativeVisibleCondition: extraVisibleCondition
    //     anchorEdges: (!Config.options.bar.bottom && !Config.options.bar.vertical) ? Edges.Bottom : Edges.Top
    // }

    StyledPopup {
        id: tooltip
        hoverTarget: root
        enableDelay: true
        altCondition: !root.targetMenuOpen
        margin: 8
        property string text: ""

        RowLayout {
            anchors.centerIn: parent

            StyledText {
                text: tooltip.text
                font.pixelSize: Appearance.font.pixelSize.small
                font.bold: true
                color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
            }
        }
    }

}
