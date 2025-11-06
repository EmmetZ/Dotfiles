pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import qs.modules.common.functions
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root
    property bool visible: false
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property var realPlayers: Mpris.players.values.filter(player => isRealPlayer(player))
    readonly property var meaningfulPlayers: filterDuplicatePlayers(realPlayers)
    readonly property real timeMenuWidth: Appearance.sizes.timeMenuWidth
    readonly property real widgetWidth: Appearance.media.controlsWidth
    readonly property real widgetHeight: Appearance.media.controlsHeight
    property real contentPadding: 13
    property real popupRounding: Appearance.rounding.screenRounding - Appearance.sizes.elevationMargin + 1
    property real artRounding: Appearance.rounding.verysmall
    property list<real> visualizerPoints: []

    property var anchorItem

    property bool hasPlasmaIntegration: false
    Process {
        id: plasmaIntegrationAvailabilityCheckProc
        running: true
        command: ["bash", "-c", "command -v plasma-browser-integration-host"]
        onExited: (exitCode, exitStatus) => {
            root.hasPlasmaIntegration = (exitCode === 0);
        }
    }
    function isRealPlayer(player) {
        return (
            // Remove unecessary native buses from browsers if there's plasma integration
            // Don't filter chromium because some app based on electron
            // !(hasPlasmaIntegration && player.dbusName.startsWith('org.mpris.MediaPlayer2.firefox')) && !(hasPlasmaIntegration && player.dbusName.startsWith('org.mpris.MediaPlayer2.chromium')) &&
            !(hasPlasmaIntegration && player.dbusName.startsWith('org.mpris.MediaPlayer2.firefox')) &&
            // playerctld just copies other buses and we don't need duplicates
            !player.dbusName?.startsWith('org.mpris.MediaPlayer2.playerctld') &&
            // Non-instance mpd bus
            !(player.dbusName?.endsWith('.mpd') && !player.dbusName.endsWith('MediaPlayer2.mpd')));
    }
    function filterDuplicatePlayers(players) {
        let filtered = [];
        let used = new Set();

        for (let i = 0; i < players.length; ++i) {
            if (used.has(i))
                continue;
            let p1 = players[i];
            let group = [i];

            // Find duplicates by trackTitle prefix
            for (let j = i + 1; j < players.length; ++j) {
                let p2 = players[j];
                if (p1.trackTitle && p2.trackTitle && (p1.trackTitle.includes(p2.trackTitle) || p2.trackTitle.includes(p1.trackTitle)) || Math.abs((p1.position - p2.position) <= 2 && Math.abs(p1.length - p2.length) <= 2)) {
                    group.push(j);
                }
            }

            // Pick the one with non-empty trackArtUrl, or fallback to the first
            let chosenIdx = group.find(idx => players[idx].trackArtUrl && players[idx].trackArtUrl.length > 0);
            if (chosenIdx === undefined)
                chosenIdx = group[0];

            filtered.push(players[chosenIdx]);
            group.forEach(idx => used.add(idx));
        }
        return filtered;
    }

    Process {
        id: cavaProc
        running: mediaControlsLoader.active
        onRunningChanged: {
            if (!cavaProc.running) {
                root.visualizerPoints = [];
            }
        }
        command: ["cava", "-p", `${FileUtils.trimFileProtocol(Directories.scriptPath)}/cava/raw_output_config.txt`]
        stdout: SplitParser {
            onRead: data => {
                // Parse `;`-separated values into the visualizerPoints array
                let points = data.split(";").map(p => parseFloat(p.trim())).filter(p => !isNaN(p));
                root.visualizerPoints = points;
            }
        }
    }

    Loader {
        id: mediaControlsLoader
        active: GlobalStates.mediaControlsOpen
        onActiveChanged: {
            if (!mediaControlsLoader.active && Mpris.players.values.filter(player => isRealPlayer(player)).length === 0) {
                GlobalStates.mediaControlsOpen = false;
            }
        }

        sourceComponent: PanelWindow {
            id: mediaControlsRoot
            visible: true

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            implicitWidth: root.widgetWidth
            implicitHeight: playerColumnLayout.implicitHeight
            color: "transparent"
            WlrLayershell.namespace: "quickshell:mediaControls"

            anchors {
                top: !Config.options.bar.bottom || Config.options.bar.vertical
                bottom: Config.options.bar.bottom && !Config.options.bar.vertical
                left: !(Config.options.bar.vertical && Config.options.bar.bottom)
                right: Config.options.bar.vertical && Config.options.bar.bottom
            }
            // margins {
            //     top: Config.options.bar.vertical ? ((mediaControlsRoot.screen.height / 2) - widgetHeight * 1.5) : Appearance.bar.height
            //     bottom: Appearance.bar.height
            //     left: Config.options.bar.vertical ? Appearance.bar.height : ((mediaControlsRoot.screen.width / 2) - (timeMenuWidth / 2) - widgetWidth)
            //     right: Appearance.bar.height
            // }

            margins {
                left: {
                    if (!Config.options.bar.vertical) {
                        let margin = root.QsWindow?.mapFromItem(root.anchorItem, 0, 0).x;
                        // let margin = root.QsWindow?.mapFromItem(root.anchorItem, (root.anchorItem.width - root.widgetWidth) / 2, 0).x;

                        // Get the window's position on the screen
                        let windowX = root.QsWindow?.screenX ?? 0;
                        let screenWidth = mediaControlsRoot.screen?.width ?? root.QsWindow.width;

                        if (margin < 0) {
                            // console.warn("Popup position adjusted to prevent left overflow");
                            return 0;
                        }
                        // Check if popup would go beyond right edge of screen
                        // if (windowX + margin + widgetWidth > (screenWidth - timeMenuWidth) / 2) {
                        //     // console.warn("Popup position adjusted to prevent right overflow");
                        //     return Math.max(0, (screenWidth - timeMenuWidth) / 2 - widgetWidth);
                        // }
                        return margin;
                    }
                    return Appearance.bar.verticalBarWidth;
                }
                top: {
                    if (!Config.options.bar.vertical)
                        return Appearance.bar.height;
                    let margin = root.QsWindow?.mapFromItem(root.anchorItem, (root.anchorItem.height - widgetHeight) / 2, 0).y;

                    // Get the window's position on the screen
                    let windowY = root.QsWindow?.screenY ?? 0;
                    let screenHeight = mediaControlsRoot.screen?.height ?? root.QsWindow.height;

                    if (margin < 0) {
                        // console.warn("Popup position adjusted to prevent top overflow");
                        return 0;
                    }
                    // Check if popup would go beyond bottom edge of screen
                    // if (windowY + margin + popupBackground.implicitHeight > screenHeight) {
                    //     // console.warn("Popup position adjusted to prevent bottom overflow");
                    //     return Math.max(0, screenHeight - popupBackground.implicitHeight - windowY);
                    // }
                    return margin;
                }
                right: Appearance.bar.verticalBarWidth
                bottom: Appearance.bar.height
            }

            mask: Region {
                item: playerColumnLayout
            }

            HyprlandFocusGrab {
                windows: [mediaControlsRoot]
                active: mediaControlsLoader.active
                onCleared: () => {
                    if (!active) {
                        GlobalStates.mediaControlsOpen = false;
                    }
                }
            }

            ColumnLayout {
                id: playerColumnLayout
                anchors.fill: parent
                spacing: -Appearance.sizes.elevationMargin // Shadow overlap okay

                Repeater {
                    model: ScriptModel {
                        values: root.meaningfulPlayers
                    }
                    delegate: PlayerControl {
                        required property MprisPlayer modelData
                        player: modelData
                        visualizerPoints: root.visualizerPoints
                        implicitWidth: root.widgetWidth
                        implicitHeight: root.widgetHeight
                        radius: root.popupRounding
                    }
                }

                Item {
                    // No player placeholder
                    Layout.alignment: {
                        if (mediaControlsRoot.anchors.left) return Qt.AlignLeft;
                        if (mediaControlsRoot.anchors.right) return Qt.AlignRight;
                        return Qt.AlignHCenter;
                    }
                    visible: root.meaningfulPlayers.length === 0
                    implicitWidth: placeholderBackground.implicitWidth + Appearance.sizes.elevationMargin
                    implicitHeight: placeholderBackground.implicitHeight + Appearance.sizes.elevationMargin

                    StyledRectangularShadow {
                        target: placeholderBackground
                    }

                    Rectangle {
                        id: placeholderBackground
                        // anchors.centerIn: parent
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        color: Appearance.colors.colLayer0
                        radius: root.popupRounding
                        property real padding: 20
                        implicitWidth: placeholderLayout.implicitWidth + padding * 2
                        implicitHeight: placeholderLayout.implicitHeight + padding * 2

                        ColumnLayout {
                            id: placeholderLayout
                            anchors.centerIn: parent

                            StyledText {
                                text: "No active player"
                                font.pixelSize: Appearance.font.pixelSize.large
                            }
                            StyledText {
                                color: Appearance.colors.colSubtext
                                text: "Make sure your player has MPRIS support\nor try turning off duplicate player filtering"
                                font.pixelSize: Appearance.font.pixelSize.small
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "mediaControls"

        function toggle(): void {
            mediaControlsLoader.active = !mediaControlsLoader.active;
            if (mediaControlsLoader.active)
                Notifications.timeoutAll();
        }

        function close(): void {
            mediaControlsLoader.active = false;
        }

        function open(): void {
            mediaControlsLoader.active = true;
            Notifications.timeoutAll();
        }
    }

    GlobalShortcut {
        name: "mediaControlsToggle"
        description: "Toggles media controls on press"

        onPressed: {
            GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen;
        }
    }
    GlobalShortcut {
        name: "mediaControlsOpen"
        description: "Opens media controls on press"

        onPressed: {
            GlobalStates.mediaControlsOpen = true;
        }
    }
    GlobalShortcut {
        name: "mediaControlsClose"
        description: "Closes media controls on press"

        onPressed: {
            GlobalStates.mediaControlsOpen = false;
        }
    }
}
