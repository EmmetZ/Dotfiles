import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs
import qs.services
import Quickshell.Io

QuickToggleButton {
    id: nightLightButton
    property bool enabled: Hyprsunset.active
    toggled: enabled
    buttonIcon: Config.options.hyprsunset.automatic ? "󰔎" : "󰖔"
    onClicked: {
        Hyprsunset.toggle();
    }

    altAction: () => {
        Config.options.hyprsunset.automatic = !Config.options.hyprsunset.automatic;
    }

    Component.onCompleted: {
        Hyprsunset.fetchState();
    }

    StyledToolTip {
        text: Config.options.hyprsunset.automatic ? "Night Light | Right-click to disable Auto mode" : "Night Light | Right-click to enable Auto mode"
    }
}
