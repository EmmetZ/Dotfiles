import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.modules.common.widgets
import qs.modules.common
import qs.services
import Quickshell.Io

Item {
    id: root
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    property list<int> workspaceOccupied: HyprlandData.workspaceOccupied
    Layout.fillHeight: true
    readonly property list<string> workspaceNames: ["󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰", "󰿬"]

    implicitWidth: workspaceContainer.implicitWidth

    function isOccupied(index) {
        if (workspaceOccupied.indexOf(index + 1) !== -1) {
            return true;
        }
        return false;
    }

    function isActive(index) {
        if (Hyprland?.focusedWorkspace?.id === (index + 1)) {
            return true;
        }
        return false;
    }

    RowLayout {
        id: workspaceContainer
        spacing: 6
        anchors.fill: parent
        implicitHeight: Appearance.bar.height

        Repeater {
            model: Config.options.bar.workspaces.shown

            Item {
                required property int index
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: text.implicitWidth

                visible: index < Config.options.bar.workspaces.defaultNum || isOccupied(index) || isActive(index)

                MouseArea {
                    anchors.fill: text
                    onClicked: {
                        Hyprland.dispatch(`workspace ${index + 1}`);
                    }
                    cursorShape: Qt.PointingHandCursor

                    WheelHandler {
                        onWheel: event => {
                            if (event.angleDelta.y < 0)
                                Hyprland.dispatch(`workspace r+1`);
                            else if (event.angleDelta.y > 0)
                                Hyprland.dispatch(`workspace r-1`);
                        }
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    }
                }

                StyledText {
                    id: text
                    anchors.centerIn: parent
                    text: {
                        if (isActive(index)) {
                            if (index < workspaceNames.length) {
                                return workspaceNames[index];
                            }
                            return "󰐗";
                        }
                        if (isOccupied(index)) {
                            return "󰻃";
                        }
                        return "󰄰";
                    }
                    font.pixelSize: Appearance.font.pixelSize.larger
                    color: {
                        if (isActive(index)) {
                            return Appearance.mocha.maroon;
                        } else {
                            return Appearance.mocha.text;
                        }
                    }
                }
            }
        }
    }
}
