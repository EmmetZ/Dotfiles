import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common.widgets
import qs.services
import Quickshell.Services.Pipewire
import qs.modules.common
import qs.modules.common.functions

Item {
    id: root

    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height
    Layout.fillHeight: true

    property real volume: Audio.sinkVol
    property bool muted: Audio.sinkMuted
    property string deviceApi: Audio.sinkInfo[0] ?? "unknown"
    property string deviceType: Audio.sinkInfo[1] ?? "unknown"
    readonly property list<string> icons: ["󰕿", "󰖀", "󰕾"]

    property color theme: getTheme()

    function getIcon() {
        if (root.deviceApi === "alsa" && root.deviceType.includes("headphone")) {
            if (muted || volume === 0)
                return "󰝟";
            return "󰋋";
        }
        if (root.deviceApi.includes("bluez")) {
            if (muted || volume === 0)
                return "󰝟";
            return "󰋋󰂰";
        }
        return Icons.getVolumeIcon(volume, muted);
    }

    function getLabel() {
        if (muted || volume === 0)
            return "";
        return `${Math.round(volume * 100)}`;
    }

    function getTheme() {
        if (Config.options.bar.m3theme) {
            const color = Appearance.colors.colPrimary;
            if (muted || volume === 0)
                return ColorUtils.applyAlpha(color, 0.7);
            return color;
        }
        let color = Appearance.mocha.peach;;
        if (root.deviceApi.includes("bluez"))
            color = Appearance.mocha.pink;
        if (muted || volume === 0)
            return ColorUtils.applyAlpha(color, 0.7);
        return color;
    }

    RowLayout {
        id: rowLayout

        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        spacing: 2

        StyledText {
            text: getIcon()
            color: theme
            font.bold: true
            font.pixelSize: Appearance.font.pixelSize.normal
        }
        StyledText {
            text: getLabel()
            color: theme
            font.bold: true
            font.pixelSize: Appearance.font.pixelSize.small
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                Audio.setMuted(!muted);
            }
        }

        WheelHandler {
            onWheel: event => {
                let variable;
                if (event.angleDelta.y > 0) {
                    variable = 0.05;
                } else if (event.angleDelta.y < 0) {
                    variable = -0.05;
                }
                Audio.setVolume(variable);
            }
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        }

        StyledPopup {
            hoverTarget: mouseArea
            enableDelay: true
            margin: 8

            RowLayout {
                anchors.centerIn: parent

                StyledText {
                    text: Audio?.sink?.description ?? "unknown"
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.bold: true
                    color: Config.options.bar.m3theme ? Appearance.colors.colOnSurfaceVariant : Appearance.mocha.text
                }
            }
        }
    }
}
