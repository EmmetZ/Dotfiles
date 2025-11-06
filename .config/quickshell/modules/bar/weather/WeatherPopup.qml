import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts
import "../"

StyledPopup {
    id: root
    enableDelay: true

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        implicitWidth: Math.max(header.implicitWidth, gridLayout.implicitWidth)
        implicitHeight: gridLayout.implicitHeight
        spacing: 5

        // Header
        ColumnLayout {
            id: header
            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 6

                StyledText {
                    text: "󰍎"
                    font.pixelSize: Appearance.font.pixelSize.large
                    font.bold: true
                    color: Appearance.mocha.yellow
                }

                StyledText {
                    text: Weather.data.city
                    font {
                        bold: true
                        pixelSize: Appearance.font.pixelSize.normal
                    }
                    color: Appearance.mocha.yellow
                }
            }
            StyledText {
                id: temp
                font.pixelSize: Appearance.font.pixelSize.smaller
                font.bold: true
                color: Appearance.mocha.yellow
                text: Weather.data.temp + " • " + "Feels like %1".arg(Weather.data.tempFeelsLike)
            }
        }

        // Metrics grid
        GridLayout {
            id: gridLayout
            columns: 2
            rowSpacing: 5
            columnSpacing: 5
            uniformCellWidths: true

            WeatherCard {
                title: "UV Index"
                symbol: "󰖙"
                value: Weather.data.uv
            }
            WeatherCard {
                title: "Wind"
                symbol: "󰖝"
                value: `(${Weather.data.windDir}) ${Weather.data.wind}`
            }
            WeatherCard {
                title: "Precipitation"
                symbol: "󰖖"
                value: Weather.data.precip
            }
            WeatherCard {
                title: "Humidity"
                symbol: "󰖌"
                value: Weather.data.humidity
            }
            WeatherCard {
                title: "Visibility"
                symbol: "󰈈"
                value: Weather.data.visib
            }
            WeatherCard {
                title: "Pressure"
                symbol: "󰾅"
                value: Weather.data.press
            }
            WeatherCard {
                title: "Sunrise"
                symbol: "󰖜"
                value: Weather.data.sunrise
            }
            WeatherCard {
                title: "Sunset"
                symbol: "󰖛"
                value: Weather.data.sunset
            }
        }
    }
}
