pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

/**
 * Provides extra features not in Quickshell.Services.Notifications:
 *  - Persistent storage
 *  - Popup notifications, with timeout
 *  - Notification groups by app
 */
Singleton {
    id: root

    property list<string> profiles: Config.options.power.profiles
    property string active: PowerProfiles.profile

    function setProfile(profile) {
        if (profile == PowerProfile.PowerSaver) {
            PowerProfiles.profile = PowerProfile.PowerSaver
        }
        else if (profile == PowerProfile.Balanced) {
            PowerProfiles.profile = PowerProfile.Balanced
        }
        else if (profile == PowerProfile.Performance) {
            PowerProfiles.profile = PowerProfile.Performance
        }
    }

}
