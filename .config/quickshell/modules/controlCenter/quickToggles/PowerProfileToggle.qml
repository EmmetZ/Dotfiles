import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common.widgets
import qs.services
import qs.modules.common

ButtonGroup {
    id: root
    Layout.alignment: Qt.AlignRight
    spacing: 3
    padding: 5
    color: Appearance.colors.colLayer1

    property string active: TunedService.active
    property list<string> profiles: Config.options.tuned.profiles
    property var iconMap: {
        "save": "󰌪",
        "balance": "󰗑",
        "performance": "󱓞"
    }

    function getIcon(profile) {
        if (profile.includes("save"))
            return iconMap["save"];
        else if (profile.includes("balance"))
            return iconMap["balance"];
        else if (profile.includes("performance"))
            return iconMap["performance"];
    }

    Connections {
        target: TunedService
        function onActiveChanged() {
            root.active = TunedService.active;
        }
    }

    Repeater {
        model: profiles

        delegate: QuickToggleButton {
            required property string modelData
            property string profile: modelData

            buttonIcon: getIcon(profile)

            onClicked: {
                TunedService.setProfile(profile);
            }

            toggled: root.active === profile

            StyledToolTip {
                text: profile
            }
        }
    }
}
