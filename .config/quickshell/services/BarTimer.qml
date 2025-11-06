pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs

Singleton {
    id: root
    Timer {
        id: timer
        interval: 1000

        running: false
        repeat: false

        onTriggered: {
            GlobalStates.barTooltipOpen = true;
        }
    }

    function start() {
        if (!timer.running) {
            timer.running = true;
        }
    }

    function stop() {
        timer.running = false;
    }
}
