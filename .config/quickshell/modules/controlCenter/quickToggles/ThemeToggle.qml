import Quickshell
import Quickshell.Io
import qs
import qs.modules.common
import qs.modules.common.widgets

QuickToggleButton {
    id: root

    property bool status: Appearance.m3colors.darkmode
    property string mode: Appearance.m3colors.darkmode ? "dark" : "light"
    buttonIcon: status? "󰽧" : "󰖨"

    toggled: false 
    onClicked: {
        root.status = !root.status;
        root.mode = status ? "dark" : "light";
        Quickshell.execDetached(["matugen", "image", `${Appearance.background.path}`, "-t", "scheme-rainbow", "-m", `${root.mode}`]);
    }

    StyledToolTip {
        text: Appearance.m3colors.darkmode ? "Switch to light theme" : "Switch to dark theme"
    }
}
