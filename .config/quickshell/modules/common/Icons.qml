pragma Singleton

// From https://github.com/caelestia-dots/shell (GPLv3)

import Quickshell

Singleton {
    id: root

    readonly property list<string> bIcons: ["󰃞", "󰃝", "󰃟", "󰃠"]
    readonly property list<string> vIcons: ["󰕿", "󰖀", "󰕾"]

    function getBluetoothDeviceMaterialSymbol(systemIconName: string): string {
        if (systemIconName.includes("headset") || systemIconName.includes("headphones"))
            return "󰋋";
        if (systemIconName.includes("audio"))
            return "󰓃";
        if (systemIconName.includes("phone"))
            return "󰄜";
        if (systemIconName.includes("mouse"))
            return "󰍽";
        if (systemIconName.includes("keyboard"))
            return "󰌌";
        return "󰂯";
    }

    function getVolumeIcon(volume: real, muted: bool): string {
        if (muted || volume === 0)
            return "󰝟";
        if (volume <= 0.3)
            return vIcons[0];
        if (volume <= 0.6)
            return vIcons[1];
        return vIcons[2];
    }

    function getBrightnessIcon(brightness: real): string {
        return bIcons[Math.floor(Math.round(brightness * 100) / 25)];
    }
}
