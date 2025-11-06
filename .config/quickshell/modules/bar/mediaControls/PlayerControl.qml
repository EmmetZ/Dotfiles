pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs.modules.common.functions
import qs.modules.common.models
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Item { // Player instance
    id: playerController
    required property MprisPlayer player
    property var artUrl: player?.trackArtUrl
    property string artDownloadLocation: Directories.coverArt
    property string artFileName: Qt.md5(artUrl) + ".jpg"
    property string artFilePath: getArtFilePath() ?? ""
    // property string artFilePath: `${artDownloadLocation}/${artFileName}`
    // property color artDominantColor: ColorUtils.mix((colorQuantizer?.colors[0] ?? Appearance.colors.colPrimary), Appearance.colors.colPrimaryContainer, 0.8) || Appearance.m3colors.m3secondaryContainer
    property color artDominantColor
    property bool downloaded: false
    property list<real> visualizerPoints: []
    property real maxVisualizerValue: 1000 // Max value in the data points
    property int visualizerSmoothing: 2 // Number of points to average for smoothing
    property real radius

    Binding {
        target: playerController
        property: "artDominantColor"
        value: ColorUtils.mix((colorQuantizer?.colors[0] ?? Appearance.colors.colPrimary), Appearance.colors.colPrimaryContainer, 0.8) || Appearance.m3colors.m3secondaryContainer
        when: colorQuantizer.colors.length > 0
    }

    function dbusType(player) {
        if (player.dbusName.startsWith('org.mpris.MediaPlayer2.chromium')) {
            return "chromium";  // Chromium-based browsers and music client ...
        }
        if (player.dbusName.startsWith('org.mpris.MediaPlayer2.mpv')) {
            return "mpv";
        }
    }

    function getArtFilePath() {
        if (player?.trackArtUrl.length > 4) {
            return `${artDownloadLocation}/${artFileName}`;
        }
        if (artUrl.length === 0 && dbusType(player) === "mpv") {
            return Quickshell.iconPath(AppSearch.guessIcon("mpv"), "");
        }
    }

    component TrackChangeButton: RippleButton {
        implicitWidth: 24
        implicitHeight: 24

        property var iconName
        colBackground: ColorUtils.transparentize(blendedColors.colSecondaryContainer, 1)
        colBackgroundHover: blendedColors.colSecondaryContainerHover
        colRipple: blendedColors.colSecondaryContainerActive

        contentItem: StyledText {
            font.pixelSize: Appearance.font.pixelSize.huge
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            color: blendedColors.colOnSecondaryContainer
            text: iconName

            Behavior on color {
                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
            }
        }
    }

    Timer {
        // Force update for revision
        running: playerController.player?.playbackState == MprisPlaybackState.Playing
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: {
            playerController.player.positionChanged();
        }
    }

    onArtUrlChanged: {
        if (playerController.artUrl.length == 0) {
            playerController.artDominantColor = Appearance.m3colors.m3secondaryContainer;
            return;
        }
        // console.info("Download cmd:", coverArtDownloader.command.join(" "));
        // update art file path
        artFileName = Qt.md5(artUrl) + ".jpg";
        artFilePath = getArtFilePath();

        playerController.downloaded = false;
        coverArtDownloader.running = true;
    }

    Process { // Cover art downloader
        id: coverArtDownloader
        property string targetFile: player?.trackArtUrl
        command: ["bash", "-c", `[ -f ${artFilePath} ] || curl -sSL '${player?.trackArtUrl}' -o '${artFilePath}'`]
        onExited: (exitCode, exitStatus) => {
            playerController.downloaded = true;
            // Ensure ColorQuantizer updates when download completes
            colorQuantizer.source = Qt.resolvedUrl(artFilePath);
        }
    }

    ColorQuantizer {
        id: colorQuantizer
        source: playerController.downloaded ? Qt.resolvedUrl(artFilePath) : ""
        depth: 0 // 2^0 = 1 color
        rescaleSize: 1 // Rescale to 1x1 pixel for faster processing
    }

    property bool backgroundIsDark: artDominantColor.hslLightness < 0.5
    property QtObject blendedColors: AdaptedMaterialScheme {
        color: artDominantColor
    }

    StyledRectangularShadow {
        target: background
    }
    Rectangle { // Background
        id: background
        anchors.fill: parent
        anchors.margins: Appearance.sizes.elevationMargin
        color: blendedColors.colLayer0
        radius: playerController.radius

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: background.width
                height: background.height
                radius: background.radius
            }
        }

        Image {
            id: blurredArt
            anchors.fill: parent
            source: {
                if (dbusType(playerController.player) === "mpv"){
                    return artFilePath;
                }
                return playerController.downloaded ? Qt.resolvedUrl(artFilePath) : ""
            }
            sourceSize.width: background.width
            sourceSize.height: background.height
            fillMode: Image.PreserveAspectCrop
            cache: false
            antialiasing: true
            asynchronous: true

            layer.enabled: true
            layer.effect: MultiEffect {
                source: blurredArt
                saturation: 0.2
                blurEnabled: true
                blurMax: 100
                blur: 1
            }

            Rectangle {
                anchors.fill: parent
                color: ColorUtils.transparentize(blendedColors.colLayer0, 0.3)
                radius: playerController.radius
            }
        }

        WaveVisualizer {
            id: visualizerCanvas
            anchors.fill: parent
            live: playerController.player?.isPlaying
            points: playerController.visualizerPoints
            maxVisualizerValue: playerController.maxVisualizerValue
            smoothing: playerController.visualizerSmoothing
            color: blendedColors.colPrimary
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: root.contentPadding
            spacing: 15

            Rectangle { // Art background
                id: artBackground
                Layout.fillHeight: true
                implicitWidth: height
                radius: root.artRounding
                color: ColorUtils.transparentize(blendedColors.colLayer1, 0.5)

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: artBackground.width
                        height: artBackground.height
                        radius: artBackground.radius
                    }
                }

                StyledImage { // Art image
                    id: mediaArt
                    property int size: parent.height
                    anchors.fill: parent

                    source: {
                        if (dbusType(playerController.player) === "mpv"){
                            return artFilePath;
                        }
                        return playerController.downloaded ? Qt.resolvedUrl(artFilePath) : ""
                    }
                    fillMode: Image.PreserveAspectCrop
                    cache: false
                    antialiasing: true
                    asynchronous: true

                    width: size
                    height: size
                    sourceSize.width: size
                    sourceSize.height: size
                }
            }

            ColumnLayout {
                // Info & controls
                Layout.fillHeight: true
                spacing: 2

                StyledText {
                    id: trackTitle
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.largest
                    font.bold: true
                    font.family: Appearance.font.family.sans
                    color: blendedColors.colOnLayer0
                    elide: Text.ElideRight
                    text: StringUtils.cleanMusicTitle(playerController.player?.trackTitle) || "Untitled"
                    animateChange: true
                    animationDistanceX: 6
                    animationDistanceY: 0
                }
                StyledText {
                    id: trackArtist
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.bold: true
                    font.family: Appearance.font.family.sans
                    color: blendedColors.colSubtext
                    elide: Text.ElideRight
                    text: playerController.player?.trackArtist
                    animateChange: true
                    animationDistanceX: 6
                    animationDistanceY: 0
                }
                Item {
                    Layout.fillHeight: true
                }
                Item {
                    Layout.fillWidth: true
                    implicitHeight: trackTime.implicitHeight + sliderRow.implicitHeight

                    StyledText {
                        id: trackTime
                        anchors.bottom: sliderRow.top
                        anchors.bottomMargin: 5
                        anchors.left: parent.left
                        font.pixelSize: Appearance.font.pixelSize.normal
                        font.bold: true
                        font.family: Appearance.font.family.sans
                        color: blendedColors.colSubtext
                        elide: Text.ElideRight
                        text: `${StringUtils.friendlyTimeForSeconds(playerController.player?.position)} / ${StringUtils.friendlyTimeForSeconds(playerController.player?.length)}`
                    }
                    RowLayout {
                        id: sliderRow
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            right: parent.right
                        }
                        TrackChangeButton {
                            iconName: "󰒮"
                            downAction: () => playerController.player?.previous()
                        }
                        Item {
                            id: progressBarContainer
                            Layout.fillWidth: true
                            implicitHeight: Math.max(sliderLoader.implicitHeight, progressBarLoader.implicitHeight)

                            Loader {
                                id: sliderLoader
                                anchors.fill: parent
                                active: playerController.player?.canSeek ?? false
                                // active: false
                                sourceComponent: StyledSlider { 
                                    // configuration: StyledSlider.Configuration.Wavy
                                    wavy: true
                                    wavyState: playerController.player?.isPlaying
                                    highlightColor: blendedColors.colPrimary
                                    trackColor: blendedColors.colSecondaryContainer
                                    handleColor: blendedColors.colPrimary
                                    value: playerController.player?.position / playerController.player?.length
                                    onMoved: {
                                        playerController.player.position = value * playerController.player.length;
                                    }
                                }
                            }

                            Loader {
                                id: progressBarLoader
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    right: parent.right
                                }
                                active: !(playerController.player?.canSeek ?? false)
                                sourceComponent: StyledProgressBar { 
                                    wavy: playerController.player?.isPlaying
                                    highlightColor: blendedColors.colPrimary
                                    trackColor: blendedColors.colSecondaryContainer
                                    value: playerController.player?.position / playerController.player?.length
                                }
                            }
                        }

                        TrackChangeButton {
                            iconName: "󰒭"
                            downAction: () => playerController.player?.next()
                        }
                    }

                    RippleButton {
                        id: playPauseButton
                        anchors.right: parent.right
                        anchors.bottom: sliderRow.top
                        anchors.bottomMargin: 5
                        property real size: 44
                        implicitWidth: size
                        implicitHeight: size
                        onClicked: playerController.player.togglePlaying()

                        buttonRadius: playerController.player?.isPlaying ? Appearance?.rounding.normal : size / 2
                        colBackground: playerController.player?.isPlaying ? blendedColors.colPrimary : blendedColors.colSecondaryContainer
                        colBackgroundHover: playerController.player?.isPlaying ? blendedColors.colPrimaryHover : blendedColors.colSecondaryContainerHover
                        colRipple: playerController.player?.isPlaying ? blendedColors.colPrimaryActive : blendedColors.colSecondaryContainerActive

                        contentItem: StyledText {
                            font.pixelSize: Appearance.font.pixelSize.huge
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            color: playerController.player?.isPlaying ? blendedColors.colOnPrimary : blendedColors.colOnSecondaryContainer
                            text: playerController.player?.isPlaying ? "" : ""

                            Behavior on color {
                                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                            }
                        }
                    }
                }
            }
        }
    }
}
