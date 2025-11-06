//@ pragma Internal
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.modules.common

ColumnLayout {
    property Item animatingItem: null
    property bool animating: animatingItem != null

    id: root

    property alias menu: menuView.menu

    signal close
    signal submenuExpanded(var item)

    spacing: 0

    QsMenuOpener {
        id: menuView
    }

    Repeater {
        model: menuView.children

        Loader {
            required property var modelData
            property var item
            property var separator

            sourceComponent: modelData.isSeparator ? separator : item
            Layout.fillWidth: true

            item: Component {
                BoundComponent {
                    id: itemComponent
                    function onAnimatingChanged() {
                        if (item.animating) {
                            root.animatingItem = this;
                        } else if (root.animatingItem == this) {
                            root.animatingItem = null;
                        }
                    }

                    property var entry: modelData

                    function onClose() {
                        root.close();
                    }

                    function onExpandedChanged() {
                        if (item.expanded)
                            root.submenuExpanded(item);
                    }

                    source: "MenuItem.qml"

                    Connections {
                        function onSubmenuExpanded(expandedItem) {
                            if (item != expandedItem)
                                item.expanded = false;
                        }

                        target: root
                    }
                }
            }

            separator: Component {
                Item {
                    implicitHeight: seprect.height + 6

                    Rectangle {
                        id: seprect

                        color: Appearance.colors.colOutlineVariant
                        height: 1

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            right: parent.right
                        }
                    }
                }
            }
        }
    }
}
