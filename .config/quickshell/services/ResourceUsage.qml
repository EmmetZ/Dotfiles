pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Simple polled resource usage service with RAM, Swap, and CPU usage.
 */
Singleton {
    property double memoryTotal: 1
    property double memoryFree: 1
    property double memoryUsed: memoryTotal - memoryFree
    property double memoryUsedPercentage: memoryUsed / memoryTotal
    property double swapTotal: 1
    property double swapFree: 1
    property double swapUsed: swapTotal - swapFree
    property double swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0
    property double cpuUsage: 0
    property int cpuTemp: 0
    property var previousCpuStats
    property double diskTotal: 1
    property double diskUsed: 0
    property double diskUsedPercentage: 0

    property int m: 10

    Process {
        id: diskUsage
        command: ["sh", "-c", "df | rg '/dev/nvme0n1p7' | awk '{print $2, $3}' | head -n 1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(' ');
                if (parts.length === 2) {
                    diskTotal = Number(parts[0]);
                    diskUsed = Number(parts[1]);
                    diskUsedPercentage = diskTotal > 0 ? (diskUsed / diskTotal) : 0;
                }
            }
        }
    }

    Timer {
        interval: 1
        running: true
        repeat: true
        onTriggered: {
            // Reload files
            fileMeminfo.reload();
            fileStat.reload();
            fileTemp.reload();

            if (m < 10) {
                m = m + 1;
            } else {
                m = 0;
                diskUsage.running = true;
            }

            // Parse memory and swap usage
            const textMeminfo = fileMeminfo.text();
            memoryTotal = Number(textMeminfo.match(/MemTotal: *(\d+)/)[1] ?? 1);
            memoryFree = Number(textMeminfo.match(/MemAvailable: *(\d+)/)[1] ?? 0);
            swapTotal = Number(textMeminfo.match(/SwapTotal: *(\d+)/)[1] ?? 1);
            swapFree = Number(textMeminfo.match(/SwapFree: *(\d+)/)[1] ?? 0);

            // Parse CPU usage
            const textStat = fileStat.text();
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number);
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3];

                if (previousCpuStats) {
                    const totalDiff = total - previousCpuStats.total;
                    const idleDiff = idle - previousCpuStats.idle;
                    cpuUsage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
                }

                previousCpuStats = {
                    total,
                    idle
                };
            }
            cpuTemp = Math.round((Number(fileTemp.text()) ?? 0) / 1000);
            interval = Config.options.resources.updateInterval ?? 3000;
        }
    }

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }
    FileView {
        id: fileStat
        path: "/proc/stat"
    }
    FileView {
        id: fileTemp
        path: "/sys/class/thermal/thermal_zone0/hwmon2/temp1_input"
    }
}
