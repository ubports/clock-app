/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Stopwatch 1.0
import Ubuntu.Components 1.2

Item {
    id: _stopwatchPage
    objectName: "stopwatchPage"

    property bool running: false

    property int lapTime: 0
    property int previousLapsTime: 0

    property int totalTime: lapTime + previousLapsTime

    Component.onCompleted: {
        console.log("[LOG]: Stopwatch Page Loaded")
    }

    function start() {
        if (running === false) {
            lapHistory.startStopwatch();
        }
        running = true
    }

    function stop() {
        previousLapsTime += lapTime
        lapTime = 0
        running = false
    }

    function update() {
        lapTime = lapHistory.updateStopwatch();
    }

    function clear() {
        running = false
        lapTime = 0
        previousLapsTime = 0
        lapHistory.clear()
    }

    Timer {
        id: refreshTimer
        interval: 45
        repeat: true
        running: _stopwatchPage.running
        onTriggered: {
            _stopwatchPage.update()
        }
    }

    StopwatchFace {
        id: stopwatch
        objectName: "stopwatch"

        milliseconds: _stopwatchPage.totalTime

        anchors {
            top: parent.top
            topMargin: units.gu(2)
            horizontalCenter: parent.horizontalCenter
        }
    }

    Row {
        id: buttonRow

        spacing: units.gu(2)
        anchors {
            top: stopwatch.bottom
            topMargin: units.gu(3)
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        Button {
            id: stopButton
            width: previousLapsTime !== 0 || running ? (parent.width - parent.spacing) / 2 : parent.width
            color: !_stopwatchPage.running ? UbuntuColors.green : UbuntuColors.red
            text: _stopwatchPage.running ? i18n.tr("Stop") : (previousLapsTime === 0 ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {
                if (_stopwatchPage.running) {
                    _stopwatchPage.stop()
                } else {
                    _stopwatchPage.start()
                }
            }
            Behavior on width {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        }

        Button {
            id: lapButton
            text: _stopwatchPage.running ? i18n.tr("Lap") : i18n.tr("Clear")
            width: previousLapsTime !== 0 || running ? (parent.width - parent.spacing) / 2 : 0
            strokeColor: UbuntuColors.lightGrey
            visible: previousLapsTime !== 0 || running
            onClicked: {
                if (_stopwatchPage.running) {
                    lapHistory.addLap(_stopwatchPage.totalTime)
                } else {
                    _stopwatchPage.clear()
                }
            }
            Behavior on width {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        }
    }

    MouseArea {
        anchors {
            top: buttonRow.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(1)
        }

        preventStealing: true

        Loader {
            id: lapListViewLoader
            anchors.fill: parent
            sourceComponent: !_stopwatchPage.running && _stopwatchPage.totalTime == 0 ? undefined : lapListViewComponent
        }
    }

    LapHistory {
        id: lapHistory
    }

    Component {
        id: lapListViewComponent
        LapListView {
            id: lapListView
            model: lapHistory
        }
    }
}
