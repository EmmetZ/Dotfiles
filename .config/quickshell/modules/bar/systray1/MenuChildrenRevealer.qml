//@ pragma Internal
import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.modules.common

Item {

    property bool expanded: false
    readonly property bool open: progress != 0
    readonly property bool animating: internalProgress != (expanded ? 101 : -1)
    property var xStart: Math.round(width * 0.3)
    property var yStart: Math.round(height * 0.1)
    property var xEnd: Math.round(width * 0.7)
    property var yEnd: Math.round(height * 0.9)
    property real internalProgress: expanded ? 101 : -1

    Behavior on internalProgress {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        // SmoothedAnimation {
        //     velocity: 400
        // }
    }
    // EasingCurve {
    //     id: curve
    //     curve.type: Easing.InOutQuad
    // }
    // readonly property real progress: curve.valueAt(Math.min(100, Math.max(internalProgress, 0)) * 0.01)
    readonly property real progress: Math.min(100, Math.max(internalProgress, 0)) * 0.01

    implicitHeight: 16
    implicitWidth: 16
    rotation: progress * 90

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 3

        ShapePath {
            strokeWidth: 2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.MiterJoin
            strokeColor: Appearance.colors.colOnSurfaceVariant
            fillColor: "transparent"
            startX: xStart
            startY: yStart

            PathLine {
                x: xEnd
                y: height / 2
            }

            PathLine {
                y: yEnd
                x: xStart
            }
        }
    }
}
