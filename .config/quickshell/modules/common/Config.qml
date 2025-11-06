pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property string filePath: Directories.shellConfigPath
    property alias options: configOptionsJsonAdapter
    property bool ready: false
    property int readWriteDelay: 50 // milliseconds

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.options;
        let parents = [obj];

        // Traverse and collect parent objects
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        // Convert value to correct type using JSON.parse when safe
        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        obj[keys[keys.length - 1]] = convertedValue;
    }

    Timer {
        id: fileReloadTimer
        interval: root.readWriteDelay
        repeat: false
        onTriggered: {
            configFileView.reload()
        }
    }

    Timer {
        id: fileWriteTimer
        interval: root.readWriteDelay
        repeat: false
        onTriggered: {
            configFileView.writeAdapter()
        }
    }

    FileView {
        id: configFileView
        path: root.filePath
        watchChanges: true
        onFileChanged: fileReloadTimer.restart()
        onAdapterUpdated: fileWriteTimer.restart()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: configOptionsJsonAdapter

            property JsonObject appearance: JsonObject {
                property bool extraBackgroundTint: true
                property string palette: "auto" // Allowed: auto, scheme-content, scheme-expressive, scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral, scheme-rainbow, scheme-tonal-spot
                property JsonObject transparency: JsonObject {
                    property bool enable: true
                    property bool automatic: true
                    property real backgroundTransparency: 0.11
                    property real contentTransparency: 0.0
                }
            }

            property JsonObject overview: JsonObject {
                property bool enable: true
                property real scale: 0.15 // Relative to screen size
                property real rows: 2
                property real columns: 5
                property real position: 1 // 0: top | 1: middle | 2: bottom
                property real workspaceNumberSize: 120 // Set 0, dynamic calculation based on monitor size
                property bool showWallpaper: false
            }

            property JsonObject resources: JsonObject {
                property int updateInterval: 3000
            }

            property JsonObject hacks: JsonObject {
                property int arbitraryRaceConditionDelay: 20 // milliseconds
            }

            property JsonObject bar: JsonObject {
                property bool m3theme: false
                property bool bottom: false // Instead of top
                property JsonObject autoHide: JsonObject {
                    property bool enable: false
                    property bool pushWindows: true
                    property int hoverRegionWidth: 2
                    property JsonObject showWhenPressingSuper: JsonObject {
                        property bool enable: true
                        property int delay: 140
                    }
                }
                property list<string> screenList: [] // Empty = all screens
                property bool vertical: false
                property JsonObject workspaces: JsonObject {
                    property real shown: 10
                    property real defaultNum: 5
                    property bool monochromeIcons: true
                    property bool showAppIcons: false
                    property bool alwaysShowNumbers: false
                    property bool showNumberOnOccupiedOnly: true
                    property int showNumberDelay: 300 // milliseconds
                    property list<string> numberMap: ["1", "2"] // Characters to show instead of numbers on workspace indicator
                }
                property JsonObject tray: JsonObject {
                    property list<string> pinnedItems: ["Fcitx"]
                    property bool invertPinnedItems: false
                    property bool monochromeIcons: true
                }
                property JsonObject weather: JsonObject {
                    property bool enableGPS: false // gps based location
                    property string city: "" // When 'enableGPS' is false
                    property bool useUSCS: false // Instead of metric (SI) units
                    property int fetchInterval: 10 // minutes
                }
            }

            property JsonObject audio: JsonObject {
                property JsonObject protection: JsonObject {
                    property bool enable: true
                    property int maxAllowedIncrease: 10 // percentage points
                    property int maxAllowed: 101 // percentage points
                }
                property string notifySound: ""
            }

            property JsonObject battery: JsonObject {
                property int low: 20
                property int critical: 10
                property bool automaticSuspend: true
                property int suspend: 5
            }

            property JsonObject notifications: JsonObject {
                property int timeout: 6000
            }

            property JsonObject osd: JsonObject {
                property int timeout: 2000
                property bool bottom: true
            }

            property JsonObject interactions: JsonObject {
                property JsonObject scrolling: JsonObject {
                    property bool fasterTouchpadScroll: false // Enable faster scrolling with touchpad
                    property int mouseScrollDeltaThreshold: 120 // delta >= this then it gets detected as mouse scroll rather than touchpad
                    property int mouseScrollFactor: 120
                    property int touchpadScrollFactor: 450
                }
            }

            property JsonObject apps: JsonObject {
                property string bluetooth: "blueman-manager"
                // property string network: "kitty -1 fish -c nmtui"
                property string network: "kcmshell6 kcm_networkmanagement"
                property string taskManager: "plasma-systemmonitor --page-name Processes"
                property string terminal: "kitty -1" // This is only for shell actions
            }
            property JsonObject controlCenter: JsonObject {
                property bool keepControlCenterLoaded: true
            }

            property JsonObject timeMenu: JsonObject {
                property bool keepControlCenterLoaded: true
            }

            property JsonObject time: JsonObject {
                // https://doc.qt.io/qt-6/qtime.html#toString
                property string format: "hh:mm"
                property string shortDateFormat: "dd/MM"
                property string dateFormat: "ddd, dd/MM"
                property JsonObject pomodoro: JsonObject {
                    property string alertSound: ""
                    property int breakTime: 300
                    property int cyclesBeforeLongBreak: 4
                    property int focus: 1500
                    property int longBreak: 900
                }
            }
            property JsonObject tuned: JsonObject {
                property list<string> profiles: ["powersave", "balanced-battery", "throughput-performance"]
                property string defaultProfile: "balanced-battery"
            }

            property JsonObject hyprsunset: JsonObject {
                property bool automatic: false
                property string from: "23:00" // Format: "HH:mm", 24-hour time
                property string to: "06:30"   // Format: "HH:mm", 24-hour time
                property int colorTemperature: 5000
            }

            // property JsonObject dock: JsonObject {
            //     property bool enable: false
            //     property bool monochromeIcons: true
            //     property real height: 60
            //     property real hoverRegionHeight: 2
            //     property bool pinnedOnStartup: false
            //     property bool hoverToReveal: true // When false, only reveals on empty workspace
            //     property list<string> pinnedApps: ["kitty"]
            //     property list<string> ignoredAppRegexes: []
            // }

            property JsonObject media: JsonObject {
                property bool enableMediaControls: true
            }

            property JsonObject light: JsonObject {
                property JsonObject antiFlashbang: JsonObject {
                    property bool enable: false
                }
            }
        }
    }
}
