import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root
    implicitWidth: gridLayout.implicitWidth
    implicitHeight: gridLayout.implicitHeight
    property bool vertical: false
    property bool invertSide: false
    property bool trayOverflowOpen: false

    property list<var> itemsInUserList: SystemTray.items.values.filter(i => (Config.options.bar.tray.pinnedItems.includes(i.id) && i.status !== Status.Passive))
    property list<var> itemsNotInUserList: SystemTray.items.values.filter(i => (!Config.options.bar.tray.pinnedItems.includes(i.id) && i.status !== Status.Passive))
    property bool invertPins: Config.options.bar.tray.invertPinnedItems
    property list<var> pinnedItems: invertPins ? itemsNotInUserList : itemsInUserList
    property list<var> unpinnedItems: invertPins ? itemsInUserList : itemsNotInUserList
    onUnpinnedItemsChanged: if (unpinnedItems.length == 0)
        root.trayOverflowOpen = false

    GridLayout {
        id: gridLayout
        columns: root.vertical ? 1 : -1
        anchors.fill: parent
        rowSpacing: 6
        columnSpacing: 3

        Repeater {
            model: ScriptModel {
                values: SystemTray.items.values
            }

            delegate: SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData
                Layout.fillHeight: !root.vertical
                Layout.fillWidth: root.vertical
            }
        }
    }
}
