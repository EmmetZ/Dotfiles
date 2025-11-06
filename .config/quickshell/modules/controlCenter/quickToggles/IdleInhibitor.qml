import Quickshell
import Quickshell.Io
import qs
import qs.modules.common
import qs.modules.common.widgets

QuickToggleButton {
    id: root

    toggled: false
    buttonIcon: toggled ? "󰅶" : "󰛊"
    onClicked: {
        if (toggled) {
            root.toggled = false;
            Quickshell.execDetached(["pkill", "hypridle"]);
        } else {
            root.toggled = true;
            Quickshell.execDetached(["hypridle"]);
        }
    }

    Process {
        id: fetchActiveState

        running: true
        command: ["pidof", "hypridle"]
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode === 0;
        }
    }

    StyledToolTip {
        text: "Keep system awake"
    }

}
