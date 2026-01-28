import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common.widgets
import qs.services
import qs.modules.common
import Quickshell.Services.UPower

ButtonGroup {
    id: root
    Layout.alignment: Qt.AlignRight
    spacing: 3
    padding: 5
    color: Appearance.colors.colLayer1

    // property string active: TunedService.active
    property string active: PowerProfileService.active
    property list<string> profiles: Config.options.power.profiles
    property var iconMap: {
        "save": "󰌪",
        "balance": "󰗑",
        "performance": "󱓞"
    }

    // function getIcon(profile) {
    //     if (profile.includes("save"))
    //         return iconMap["save"];
    //     else if (profile.includes("balance"))
    //         return iconMap["balance"];
    //     else if (profile.includes("performance"))
    //         return iconMap["performance"];
    // }

    // Connections {
    //     target: TunedService
    //     function onActiveChanged() {
    //         root.active = TunedService.active;
    //     }
    // }

    function getIcon(profile) {
        if (profile == PowerProfile.PowerSaver)
            return iconMap["save"];
        else if (profile == PowerProfile.Balanced)
            return iconMap["balance"];
        else if (profile == PowerProfile.Performance)
            return iconMap["performance"];
    }

    function getTooltip(profile) {
        if (profile == PowerProfile.PowerSaver)
            return "power-saver"
        else if (profile == PowerProfile.Balanced)
            return "balanced"
        else if (profile == PowerProfile.Performance)
            return "performance"
    }

    Repeater {
        model: profiles

        delegate: QuickToggleButton {
            required property string modelData
            property string profile: modelData

            buttonIcon: getIcon(profile)

            onClicked: {
                // TunedService.setProfile(profile);
                PowerProfileService.setProfile(profile);
            }

            toggled: root.active === profile

            StyledToolTip {
                text: getTooltip(profile)
            }
        }
    }
}
