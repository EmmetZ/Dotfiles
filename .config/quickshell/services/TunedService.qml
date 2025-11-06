pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import Quickshell
import Quickshell.Io
import QtQuick

/**
 * Provides extra features not in Quickshell.Services.Notifications:
 *  - Persistent storage
 *  - Popup notifications, with timeout
 *  - Notification groups by app
 */
Singleton {
    id: root

    property list<string> profiles: Config.options.tuned.profiles
    property string active: Config.options.tuned.defaultProfile

    Process {
        id: activeProfileProcess
        command: ["cat", `${Directories.tunedPath}`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.active = this.text.trim();
            }
        }
    }

    function setProfile(profile) {
        Quickshell.execDetached(["tuned-adm", "profile", `${profile}`]);
    }

    FileView {
        id: tunedStatusFile
        path: Qt.resolvedUrl(Directories.tunedPath)
        watchChanges: true
        onFileChanged: {
            activeProfileProcess.running = false;
            activeProfileProcess.running = true;
        }
    }
}
