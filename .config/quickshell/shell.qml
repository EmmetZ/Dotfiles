//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.notificationPopup
import qs.modules.sessionScreen
import qs.modules.osd
import qs.modules.overview
import qs.modules.controlCenter
import qs.modules.timeMenu
import qs.services
import qs
import qs.modules.common

ShellRoot {
    // Enable/disable modules here. False = not loaded at all, so rest assured
    // no unnecessary stuff will take up memory if you decide to only use, say, the overview.
    property bool enableOverview: true
    property bool enableBar: true
    property bool enableOnScreenDisplayBrightness: true
    property bool enableOnScreenDisplayVolume: true
    property bool enableOnScreenDisplayMicrophone: true
    property bool enableNotificationPopup: true
    property bool enableSessionScreen: true
    property bool enableReloadPopup: true
    property bool enableControlCenter: true
    property bool enableTimeMenu: true

    // Force initialization of some singletons
    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
    }

    LazyLoader { active: enableOverview && Config.ready && Config.options.overview.enable; component: Overview {} }
    LazyLoader { active: enableBar && Config.ready; component: Bar {} }
    LazyLoader { active: enableOnScreenDisplayBrightness; component: OnScreenDisplayBrightness {} }
    LazyLoader { active: enableOnScreenDisplayVolume; component: OnScreenDisplayVolume {} }
    LazyLoader { active: enableOnScreenDisplayMicrophone; component: OnScreenDisplayMicrophone {} }
    LazyLoader { active: enableNotificationPopup; component: NotificationPopup {} }
    LazyLoader { active: enableSessionScreen; component: SessionScreen {} }
    LazyLoader { active: enableControlCenter; component: ControlCenter {} }
    LazyLoader { active: enableReloadPopup; component: TimeMenu {} }
    LazyLoader { active: enableTimeMenu; component: ReloadPopup {} }
}
