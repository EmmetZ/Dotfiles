import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.modules.common.functions

Item {
    id: root
    required property PwNode node
    PwObjectTracker {
        objects: [node]
    }

    implicitHeight: rowLayout.implicitHeight

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 10

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                StyledText {
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.normal
                    elide: Text.ElideRight
                    color: Appearance.colors.colSubtext
                    text: {
                        // application.name -> description -> name
                        const app = root.node.properties["application.name"] ?? (root.node.description != "" ? root.node.description : root.node.name);
                        const media = root.node.properties["media.name"];
                        return media != undefined ? `${app} • ${media}` : app;
                    }
                }
            }

            RowLayout {
                Item {
                    // Layout.alignment: Qt.AlignVCenter
                    width: icon.width
                    height: icon.height
                    Image {
                        id: icon
                        property real size: slider.height * 0.25
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        visible: source != ""
                        sourceSize.width: size
                        sourceSize.height: size
                        source: {
                            let icon;
                            icon = AppSearch.guessIcon(root.node.properties["application.icon-name"]);
                            if (AppSearch.iconExists(icon))
                                return Quickshell.iconPath(icon, "image-missing");
                            icon = AppSearch.guessIcon(root.node.properties["node.name"]);
                            return Quickshell.iconPath(icon, "image-missing");
                        }
                    }
                    RippleButton {
                        buttonRadius: Appearance.rounding.full
                        implicitHeight: slider.height * 0.33
                        implicitWidth: slider.height * 0.33
                        colBackground: ColorUtils.applyAlpha(Appearance.colors.colLayer1, 1)
                        colBackgroundHover: ColorUtils.applyAlpha(Appearance?.colors.colLayer1Hover ?? "#E5DFED", 1)
                        anchors {
                            bottom: icon.bottom
                            right: icon.right
                            bottomMargin: -4
                            rightMargin: -4
                        }

                        StyledText {
                            id: volumeIcon
                            text: Icons.getVolumeIcon(root.node.audio.volume, root.node.audio.muted)
                            font.pixelSize: Appearance.font.pixelSize.normal
                            font.bold: true
                            horizontalAlignment: Text.AlignRight
                            color: Appearance.colors.colOnLayer1
                            anchors.fill: parent

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.LeftButton
                                onClicked: event => {
                                    if (event.button === Qt.LeftButton) {
                                        root.node.audio.muted = !root.node.audio.muted;
                                    }
                                }
                            }
                        }
                    }
                }
                StyledSlider {
                    id: slider
                    value: root.node.audio.volume
                    highlightColor: root.node.audio.muted ? ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.3) : Appearance.colors.colPrimary
                    handleColor: root.node.audio.muted ? ColorUtils.applyAlpha(Appearance.colors.colPrimary, 0.3) : Appearance.colors.colPrimary
                    onMoved: {
                        if (root.node.ready) {
                            root.node.audio.volume = value;
                        }
                    }

                    Behavior on highlightColor {
                        animation: Appearance.animation.elementMove.colorAnimation.createObject(this)
                    }
                }
            }
        }
    }
}
