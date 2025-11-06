pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.modules.common

/**
 * Provides access to some Hyprland data not available in Quickshell.Hyprland.
 */
Singleton {
    id: root
    property var windowList: []
    property var addresses: []
    property var windowByAddress: ({})
    property var monitors: []
    property list<int> workspaceOccupied: []

    function updateWindowList() {
        getClients.running = true;
        getMonitors.running = true;
    }

    function biggestWindowForWorkspace(workspaceId) {
        const windowsInThisWorkspace = HyprlandData.windowList.filter(w => w.workspace.id == workspaceId);
        return windowsInThisWorkspace.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
            return winArea > maxArea ? win : maxWin;
        }, null);
    }

    Component.onCompleted: {
        updateWindowList();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            // Filter out redundant old v1 events for the same thing
            if (event.name in ["activewindow", "focusedmon", "monitoradded", "createworkspace", "destroyworkspace", "moveworkspace", "activespecial", "movewindow", "windowtitle"])
                return;
            updateWindowList();
        }
    }

    Process {
        id: getClients
        command: ["bash", "-c", "hyprctl clients -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.windowList = JSON.parse(data);
                let tempWinByAddress = {};
                let tempworkspaceOccupied = [];
                for (var i = 0; i < root.windowList.length; ++i) {
                    var win = root.windowList[i];
                    const id = parseInt(win.workspace.id);
                    if (id > 0 && id <= 10 && tempworkspaceOccupied.indexOf(id) === -1) {
                        tempworkspaceOccupied.push(id);
                    }
                    tempWinByAddress[win.address] = win;
                }
                root.workspaceOccupied = tempworkspaceOccupied.sort((a, b) => a - b);
                root.windowByAddress = tempWinByAddress;
                root.workspaceOccupied = workspaceOccupied;
                root.addresses = root.windowList.map(win => win.address);
            }
        }
    }
    Process {
        id: getMonitors
        command: ["bash", "-c", "hyprctl monitors -j | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                root.monitors = JSON.parse(data);
            }
        }
    }
}
