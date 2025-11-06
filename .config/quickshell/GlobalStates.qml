pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root
    property bool overviewOpen: false
    property bool barOpen: true
    property bool mediaControlsOpen: false
    property bool muteNotifications: false
    property bool barTooltipOpen: false
    property bool osdVolumeOpen: false
    property bool osdMicrophoneOpen: false
    property bool osdBrightnessOpen: false
    property bool controlCenterOpen: false
    property bool timeMenuOpen: false
    property bool sessionOpen: false
    property bool superDown: false
    property bool superReleaseMightTrigger: true

    GlobalShortcut {
        name: "workspaceNumber"
        description: "Hold to show workspace numbers, release to show icons"

        onPressed: {
            root.superDown = true
        }
        onReleased: {
            root.superDown = false
        }
    }
}
