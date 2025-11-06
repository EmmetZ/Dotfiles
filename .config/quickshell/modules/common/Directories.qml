pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions
import Qt.labs.platform
import Quickshell

Singleton {
    // XDG Dirs, with "file://"
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    
    // Other dirs used by the shell, without "file://"
    property string shellConfig: FileUtils.trimFileProtocol(`${Directories.config}/quickshell`)
    property string shellConfigPath: `${Directories.shellConfig}/config.json`
    property string generatedMaterialThemePath: `${Directories.shellConfig}/colors.json`
    property string coverArt: FileUtils.trimFileProtocol(`${Directories.cache}/media/coverart`)
    property string scriptPath: Quickshell.shellPath("scripts")
    property string notificationsPath: FileUtils.trimFileProtocol(`${Directories.cache}/notifications/notifications.json`)
    property string wallpaperPath: FileUtils.trimFileProtocol(`${Directories.state}/user/wallpaper.txt`)
    property string tunedPath: FileUtils.trimFileProtocol("/etc/tuned/active_profile")
    property string wallpapersDir: FileUtils.trimFileProtocol(`${Directories.home}/Pictures/wallpapers`)
}
