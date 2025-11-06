import qs.modules.controlCenter.notifications
import qs.modules.controlCenter.volumeMixer
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Rectangle {
    id: root

    property int selectedTab: 0
    property var tabButtonList: [
        {
            "icon": "󰂜",
            "name": "Notifications"
        },
        {
            "icon": "󰕾",
            "name": "Audio"
        }
    ]

    radius: Appearance.rounding.normal
    color: Appearance.colors.colLayer1
    Keys.onPressed: event => {
        if (event.key === Qt.Key_PageDown || event.key === Qt.Key_PageUp) {
            if (event.key === Qt.Key_PageDown)
                root.selectedTab = Math.min(root.selectedTab + 1, root.tabButtonList.length - 1);
            else if (event.key === Qt.Key_PageUp)
                root.selectedTab = Math.max(root.selectedTab - 1, 0);
            event.accepted = true;
        }
        if (event.modifiers === Qt.ControlModifier) {
            if (event.key === Qt.Key_Tab)
                root.selectedTab = (root.selectedTab + 1) % root.tabButtonList.length;
            else if (event.key === Qt.Key_Backtab)
                root.selectedTab = (root.selectedTab - 1 + root.tabButtonList.length) % root.tabButtonList.length;
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.margins: 5
        anchors.fill: parent
        spacing: 0

        PrimaryTabBar {
            id: tabBar

            function onCurrentIndexChanged(currentIndex) {
                root.selectedTab = currentIndex;
            }

            tabButtonList: root.tabButtonList
            externalTrackedTab: root.selectedTab
        }

        SwipeView {
            id: swipeView

            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            currentIndex: root.selectedTab
            onCurrentIndexChanged: {
                tabBar.enableIndicatorAnimation = true;
                root.selectedTab = currentIndex;
            }
            clip: true
            layer.enabled: true

            NotificationList {}

            VolumeMixer {}

            layer.effect: OpacityMask {

                maskSource: Rectangle {
                    width: swipeView.width
                    height: swipeView.height
                    radius: Appearance.rounding.small
                }
            }
        }
    }
}
