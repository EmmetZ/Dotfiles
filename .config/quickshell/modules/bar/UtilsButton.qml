import Quickshell
import QtQuick
import qs.modules.common
import qs
import qs.modules.common.widgets
import Quickshell
import qs.modules.common.functions
import QtQuick.Layouts

RippleButton {
    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    Layout.leftMargin: -4
    Layout.rightMargin: -4

    Layout.fillWidth: false
    implicitWidth: indicatorsRowLayout.implicitWidth + 10
    implicitHeight: indicatorsRowLayout.implicitHeight - 6
    buttonRadius: Appearance.rounding.full
    colBackground: {
        if (Config.options.bar.m3theme) {
            controlCenterMouseArea.hovered ? Appearance.colors.colLayer1Hover : ColorUtils.transparentize(Appearance.colors.colLayer1Hover, 1);
        } else {
            controlCenterMouseArea.containsMouse ? Appearance.mocha.surface1 : ColorUtils.transparentize(Appearance.mocha.surface1, 1);
        }
    }
    colBackgroundHover: {
        if (Config.options.bar.m3theme) {
            Appearance.colors.colLayer1Hover;
        } else {
            Appearance.mocha.surface1;
        }
    }
    colRipple: {
        if (Config.options.bar.m3theme) {
            Appearance.colors.colLayer1Active;
        } else {
            Appearance.mocha.surface2;
        }
    }
    colBackgroundToggled: {
        if (Config.options.bar.m3theme) {
            Appearance.colors.colSecondaryContainer;
        } else {
            Appearance.mocha.surface2;
        }
    }
    colBackgroundToggledHover: {
        if (Config.options.bar.m3theme) {
            Appearance.colors.colSecondaryContainerHover;
        } else {
            Appearance.mocha.surface2;
        }
    }
    colRippleToggled: {
        if (Config.options.bar.m3theme) {
            Appearance.colors.colSecondaryContainerActive;
        } else {
            Appearance.mocha.overlay0;
        }
    }
    property color colText: {
        if (Config.options.bar.m3theme) {
            toggled ? Appearance.m3colors.m3onSecondaryContainer : Appearance.colors.colOnLayer0;
        } else {
            return toggled ? Appearance.m3colors.m3onSecondaryContainer : Appearance.colors.colOnLayer0;
        }
    }
    toggled: GlobalStates.controlCenterOpen

    RowLayout {
        id: indicatorsRowLayout
        anchors.centerIn: parent
        spacing: 3

        NetworkIcon {}
        BluetoothIcon {}
        Notification {}
    }

    MouseArea {
        id: controlCenterMouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: {
            GlobalStates.controlCenterOpen = !GlobalStates.controlCenterOpen;
        }
    }
}
