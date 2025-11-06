import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.bar.height
    Layout.fillHeight: true

    function rewrite(title) {
        if (!title)
            return "";

        // Fast lookup for exact matches
        const exactMatches = {
            "Mozilla Firefox": " Mozilla Firefox",
            "Visual Studio Code": "󰨞 Visual Studio Code",
            "kitty": "󰄛 kitty",
            "微信": " wechat",
            "steam": "󰓓 Steam",
            "sioyek": "󰂾 sioyek",
            "Translate": "󰗊 Pot Translate"
        };

        // Check exact matches first
        if (exactMatches[title]) {
            return exactMatches[title];
        }

        // Regex patterns for more complex matches
        const patterns = [
            {
                regex: /(.*) — Mozilla Firefox/,
                replacement: " $1"
            },
            {
                regex: /(.*) - Microsoft Edge/,
                replacement: " $1"
            },
            {
                regex: /(.*) - Google Chrome/,
                replacement: " $1"
            },
            {
                regex: /(.*) - Visual Studio Code/,
                replacement: "󰨞 $1"
            },
            {
                regex: /\$term/,
                replacement: "> [$1]"
            },
            {
                regex: /(.*) - Text Editor/,
                replacement: "󱩼 $1"
            },
            {
                regex: /(.*) - Thunar/,
                replacement: "󰝰 $1"
            },
            {
                regex: /(.*) - mpv/,
                replacement: " $1"
            },
            {
                regex: /(.*)\.pdf(.*)/,
                replacement: " $1.pdf"
            },
            {
                regex: /(.*) - Zotero/,
                replacement: "󱛉 $1"
            }
        ];

        // Check regex patterns
        for (let i = 0; i < patterns.length; i++) {
            const pattern = patterns[i];
            if (pattern.regex.test(title)) {
                return title.replace(pattern.regex, pattern.replacement);
            }
        }

        return title;
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent

        StyledText {
            width: rowLayout.width
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true // Ensures the text takes up available space
            color: Appearance.mocha.sky
            font.bold: true
            elide: Text.ElideRight
            font.pixelSize: Appearance.font.pixelSize.medium
            text: root.activeWindow?.activated ? root.rewrite(root.activeWindow?.title) : ""
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        StyledPopup {
            hoverTarget: mouseArea
            enableDelay: true
            margin: 8

            RowLayout {
                anchors.centerIn: parent

                StyledText {
                    text: root.activeWindow?.activated ? root.rewrite(root.activeWindow?.title) : ""
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.bold: true
                    color: Appearance.mocha.text
                }
            }
        }
    }
}
