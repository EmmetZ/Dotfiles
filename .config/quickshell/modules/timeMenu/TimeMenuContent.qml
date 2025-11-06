import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    property int menuWidth: Appearance.sizes.controlCenterWidth
    property int menuPadding: 12
    // property string settingsQmlPath: Quickshell.shellPath("settings.qml")
    property bool showWifiDialog: false
    property bool showBluetoothDialog: false

    implicitHeight: contentColumn.implicitHeight + menuPadding * 2 + Appearance.sizes.hyprlandGapsOut * 2
    implicitWidth: menuBackground.implicitWidth

    StyledRectangularShadow {
        target: menuBackground
    }

    Rectangle {
        id: menuBackground

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        // implicitHeight: root.implicitHeight - Appearance.sizes.hyprlandGapsOut * 2
        implicitHeight: contentColumn.implicitHeight + menuPadding * 2
        implicitWidth: menuWidth - Appearance.sizes.hyprlandGapsOut * 2
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border
        radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: menuPadding
            spacing: menuPadding

            WidgetGroup {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight
            }
        }
    }
}
