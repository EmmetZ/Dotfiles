import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import qs.modules.common.functions

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import Quickshell.Io

Item {
    id: root
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    // readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || Translation.tr("No media")

    property bool isRealPlayer: activePlayer ? isRealPlayers(activePlayer) : false
    readonly property string cleanedTitle: isRealPlayer ? activePlayer?.trackTitle || "No media" : "No media"
    // readonly property string cleanedTitle: isRealPlayer ? StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || "No media" : "No media"

    Layout.fillHeight: true
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: Appearance.bar.height

    property color theme: Config.options.bar.m3theme ? Appearance.colors.colPrimary : Appearance.mocha.peach

    function isRealPlayers(player) {
        return (
            // Remove unecessary native buses from browsers if there's plasma integration
            // Don't filter chromium because some app based on electron
            // !(hasPlasmaIntegration && player.dbusName.startsWith('org.mpris.MediaPlayer2.firefox')) && !(hasPlasmaIntegration && player.dbusName.startsWith('org.mpris.MediaPlayer2.chromium')) &&
            !player.dbusName.startsWith('org.mpris.MediaPlayer2.firefox') &&
            // playerctld just copies other buses and we don't need duplicates
            // !player.dbusName?.startsWith('org.mpris.MediaPlayer2.playerctld') &&
            // Non-instance mpd bus
            !(player.dbusName?.endsWith('.mpd') && !player.dbusName.endsWith('MediaPlayer2.mpd')));
    }

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }

    MouseArea {
        anchors.fill: parent
        // enabled: isRealPlayers
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        onPressed: event => {
            if (event.button === Qt.RightButton) {
                activePlayer.togglePlaying();
            } else if (event.button === Qt.BackButton) {
                activePlayer.previous();
            } else if (event.button === Qt.ForwardButton) {
                activePlayer.next();
            } else if (event.button === Qt.LeftButton) {
                // console.info(activePlayer.dbusName);
                // for (const player of Mpris.players.values) {
                //     console.info(`- ${player.dbusName}`);
                // }
                GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen;
            }
        }
    }

    RowLayout { // Real content
        id: rowLayout

        spacing: 4
        anchors.fill: parent
        // visible: isRealPlayer && cleanedTitle !== ""

        CircularProgress {
            id: mediaCircProg
            Layout.alignment: Qt.AlignVCenter
            lineWidth: Appearance.rounding.unsharpen
            value: (activePlayer?.position ?? 0) / (activePlayer?.length ?? 1)
            implicitSize: 18
            colPrimary: theme
            enableAnimation: true
            visible: isRealPlayer && cleanedTitle !== ""

            StyledText {
                anchors.centerIn: parent
                text: activePlayer?.isPlaying ? "󰎇" : ""
                font.pixelSize: 9
                color: theme
            }
        }

        StyledText {
            id: titleText
            width: rowLayout.width - (CircularProgress.size + rowLayout.spacing * 2)
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true // Ensures the text takes up available space
            // Layout.rightMargin: rowLayout.spacing
            elide: Text.ElideRight // Truncates the text on the right
            color: theme
            // text: `${cleanedTitle}${activePlayer?.trackArtist ? ' • ' + activePlayer.trackArtist : ''}`
            text: `${cleanedTitle}`
            font.pixelSize: Appearance.font.pixelSize.medium
            // font.family: Appearance.font.family.sans
            font.bold: true
            font.italic: true
        }
    }
}
