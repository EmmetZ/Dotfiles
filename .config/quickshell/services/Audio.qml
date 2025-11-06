pragma Singleton
pragma ComponentBehavior: Bound
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import Quickshell.Hyprland

/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property bool micReady: Pipewire.defaultAudioSource?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource
    property int sinkId: Pipewire.defaultAudioSink?.id ?? -1
    property real sinkVol
    property bool sinkMuted
    property list<string> sinkInfo: []

    signal sinkProtectionTriggered(string reason)

    function isSinkNaN() {
        return isNaN(sink?.audio.volume) || sink?.audio.volume === undefined || sink?.audio.volume === null;
    }

    PwObjectTracker {
        objects: [sink, source]
    }

    Connections {
        // Protection against sudden volume changes
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onVolumeChanged() {
            root.sinkVol = sink.audio.volume;
            if (!Config.options.audio.protection.enable)
                return;
            if (!lastReady) {
                lastVolume = sink.audio.volume;
                lastReady = true;
                return;
            }
            const newVolume = sink.audio.volume;
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100;
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Illegal increment");
            } else if (newVolume > maxAllowed) {
                root.sinkProtectionTriggered("Exceeded max allowed");
                sink.audio.volume = Math.min(lastVolume, maxAllowed);
            }
            if (sink.ready && isSinkNaN()) {
                sink.audio.volume = 0;
            }
            lastVolume = sink.audio.volume;
        }

        function onMutedChanged() {
            root.sinkMuted = sink.audio.muted;
        }
    }

    Connections {
        target: root

        function onSinkVolChanged() {
            if (isSinkNaN()) {
                console.warn("Audio: Sink volume is NaN, use wpctl");
                refreshTimer.restart();
            }

            // if (sinkVol === 0) {
            //     sinkMuted = true;
            // }
            // if (sinkVol > 0 && sinkMuted) {
            //     sinkMuted = false;
            // }
        }
    }

    Connections {
        target: sink ?? null
        function onReadyChanged() {
            if (sink.ready && sink?.id) {
                root.sinkId = sink.id;
                deviceProc.running = true;
            }
        // if (isNaN(sink.audio.volume) || sink.audio.volume === undefined || sink.audio.volume === null) {
        //     console.warn("Audio: Sink volume is NaN");
        //     console.info("Audio: New sink ID", root.sinkId);
        //     // hack to reset volume to the current value rather than NaN
        //     Quickshell.execDetached(["bash", "-c", `pamixer --set-volume "$(pamixer --get-volume)"`]);
        // }
        }
    }

    Process {
        id: deviceProc
        command: ["pw-cli", "i", root.sinkId.toString()]
        running: true
        property list<string> buffer: []
        stdout: SplitParser {
            onRead: data => {
                deviceProc.buffer.push(data);
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.sinkInfo = [];
                for (let line of deviceProc.buffer) {
                    if (line.includes("device.api") || line.includes("device.profile.description")) {
                        const match = line.match(/"([^"]*)"/);
                        const value = match ? match[1] : null;
                        root.sinkInfo.push(value.toLowerCase());
                    }
                }
                deviceProc.buffer = [];
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 200
        repeat: false
        running: false
        onTriggered: {
            console.info("Audio: Refreshing sink volume via wpctl");
            sinkAudioProc.running = true;
        }
    }

    Process {
        id: sinkAudioProc
        command: ["wpctl", "get-volume", "@DEFAULT_SINK@"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim().toLowerCase();
                const match = output.match(/volume:\s*([0-9]*\.?[0-9]+)/);
                if (match) {
                    root.sinkVol = match[1];
                }
                if (output.toLowerCase().includes("muted")) {
                    root.sinkMuted = true;
                } else {
                    root.sinkMuted = false;
                }
            }
        }
    }

    function setVolume(variable) {
        if (isSinkNaN()) {
            const direction = variable > 0 ? "+" : "-";
            const newVolume = sinkVol + variable;
            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", `${Math.abs(variable) * 100}%${direction}`]);
            if (newVolume > 0 && sinkMuted) {
                console.info("Audio: Unmuting sink via wpctl");
                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "0"]);
            }
            if (newVolume <= 0 && !sinkMuted) {
                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "1"]);
            }
            if (newVolume > 0 && Config.options.audio.notifySound !== "") {
                Quickshell.execDetached(["pw-play", Config.options.audio.notifySound]);
            }
            refreshTimer.restart()
        } else {
            let newVolume = sink.audio.volume + variable;
            newVolume = Math.max(0, Math.min(1, newVolume));
            sink.audio.volume = newVolume;
            if (newVolume > 0 && sink.audio.muted) {
                sink.audio.muted = false;
            }
            if (newVolume <= 0 && !sink.audio.muted) {
                sink.audio.muted = true;
            }
            if (newVolume > 0 && Config.options.audio.notifySound !== "") {
                Quickshell.execDetached(["pw-play", Config.options.audio.notifySound]);
            }
        }
    }

    function setMuted(muted) {
        if (isSinkNaN()) {
            Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", muted ? "1" : "0"]);
            refreshTimer.restart()
        } else {
            sink.audio.muted = muted;
        }
    }

    function getMicMuted() {
        if (micReady) {
            return source.audio.muted;
        }
        return false;
    }

    function setMicMuted(muted) {
        if (micReady) {
            source.audio.muted = muted;
        }
    }

    function getMicVolume() {
        if (micReady) {
            return source.audio.volume;
        }
        return 0;
    }

    GlobalShortcut {
        name: "volumeIncrease"
        description: "Increase volume"
        onPressed: root.setVolume(0.05)
    }

    GlobalShortcut {
        name: "volumeDecrease"
        description: "Decrease volume"
        onPressed: root.setVolume(-0.05)
    }

    GlobalShortcut {
        name: "volumeToggleMute"
        description: "Toggle mute"
        onPressed: {
            root.setMuted(!root.sinkMuted);
        }
    }
}
