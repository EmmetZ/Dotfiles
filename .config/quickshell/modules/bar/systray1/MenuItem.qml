//@ pragma Internal
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.DBusMenu
import Quickshell.Widgets
import qs
import qs.modules.common

MouseArea {
    id: root
    onAnimatingChanged: {}

    required property QsMenuEntry entry
    property alias expanded: childrenRevealer.expanded

    signal close

    // property bool animating: childrenRevealer.animating || (childMenuLoader?.item?.animating ?? false);
    property bool animating: childrenRevealer.animating
    // appears it won't actually create the handler when only used from MenuItemList.
    onExpandedChanged: {}
    implicitWidth: row.implicitWidth + 4
    implicitHeight: row.implicitHeight + 4
    hoverEnabled: true
    onClicked: {
        if (entry.hasChildren) {
            childrenRevealer.expanded = !childrenRevealer.expanded;
        } else {
            entry.triggered();
            close();
        }
    }

    ColumnLayout {
        id: row

        anchors.fill: parent
        anchors.margins: 2
        spacing: 0
        z: 1

        RowLayout {
            id: innerRow

            Item {
                implicitWidth: 16
                implicitHeight: 16

                MenuCheckBox {
                    anchors.centerIn: parent
                    visible: entry.buttonType == QsMenuButtonType.CheckBox
                    checkState: entry.checkState
                }

                MenuRadioButton {
                    anchors.centerIn: parent
                    visible: entry.buttonType == QsMenuButtonType.RadioButton
                    checkState: entry.checkState
                }

                MenuChildrenRevealer {
                    id: childrenRevealer

                    anchors.centerIn: parent
                    visible: entry.hasChildren
                    onOpenChanged: entry.showChildren = open
                }
            }

            Text {
                text: entry.text
                color: entry.enabled ? Appearance.colors.colOnSurfaceVariant : Appearance.colors.colSubtext
                font.pixelSize: Appearance.font.pixelSize.normal
            }

            Item {
                Layout.fillWidth: true
                implicitWidth: 16
                implicitHeight: 16

                IconImage {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: entry.icon
                    visible: source != ""
                    implicitSize: parent.height
                }
            }
        }

        Loader {
            id: childMenuLoader
            readonly property real widthDifference: {
                Math.max(0, (item?.implicitWidth ?? 0) - innerRow.implicitWidth);
            }
            Layout.preferredWidth: active ? innerRow.implicitWidth + (widthDifference * childrenRevealer.progress) : 0
            Layout.preferredHeight: active ? item.implicitHeight * childrenRevealer.progress : 0

            Layout.fillWidth: true
            active: root.expanded || root.animating
            clip: true

            sourceComponent: MenuView {
                id: childrenList

                menu: entry
                onClose: root.close()
                visible: root.expanded

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: root.containsMouse
        color: Appearance.m3colors.m3background
        radius: 5
        z: 0
    }
}
