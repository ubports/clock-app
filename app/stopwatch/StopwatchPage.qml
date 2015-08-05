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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.2
import "../components"

Item {
    id: _stopwatchPage
    objectName: "stopwatchPage"

    property date startTime: new Date()
    property date snapshot: startTime
    property bool running: false

    property int timeDiff: snapshot - startTime
    property int oldDiff: 0

    property int totalTimeDiff: timeDiff + oldDiff

    Component.onCompleted: {
        console.log("[LOG]: Stopwatch Page Loaded")
    }

    function start() {
        startTime = new Date()
        snapshot = startTime
        running = true
    }

    function stop() {
        oldDiff += timeDiff
        startTime = new Date()
        snapshot = startTime
        running = false
    }

    function update() {
        snapshot = new Date()
    }

    function clear() {
        oldDiff = 0
        startTime = new Date()
        snapshot = startTime
        lapsModel.clear()
    }

    ListModel {
        id: lapsModel
        function addLap(totalTime) {
            if (lapsModel.count === 0) {
                append({"laptime": totalTime, "totaltime": totalTime})
            } else {
                insert(0, {"laptime": totalTime - lapsModel.get(0).totaltime, "totaltime": totalTime})
            }
        }
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

    Flickable {
        id: _flickable

        onFlickStarted: {
            forceActiveFocus()
        }

        clip: true
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: stopwatch.height + buttonRow.height + lapListViewLoader.height + units.gu(14)

        HeaderNavigation {
            id: headerRow
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 0
            }
        }

        StopwatchFace {
            id: stopwatch
            objectName: "stopwatch"

            milliseconds: _stopwatchPage.totalTimeDiff

            anchors {
                verticalCenter: parent.top
                verticalCenterOffset: units.gu(25)
                horizontalCenter: parent.horizontalCenter
            }
        }

        RowLayout {
            id: buttonRow

            spacing: units.gu(2)
            anchors {
                top: parent.top
                topMargin: units.gu(44)
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            Button {
                id: stopButton
                Layout.fillWidth: true
                color: !_stopwatchPage.running ? UbuntuColors.green : UbuntuColors.red
                text: _stopwatchPage.running ? i18n.tr("Stop") : i18n.tr("Start")
                onClicked: {
                    if (_stopwatchPage.running) {
                        _stopwatchPage.stop()
                    } else {
                        _stopwatchPage.start()
                    }
                }
            }

            Button {
                id: lapButton
                text: _stopwatchPage.running ? i18n.tr("Lap") : i18n.tr("Clear")
                Layout.fillWidth: true
                strokeColor: UbuntuColors.lightGrey
                onClicked: {
                    if (_stopwatchPage.running) {
                        _stopwatchPage.update()
                        lapsModel.addLap(_stopwatchPage.totalTimeDiff)
                    } else {
                        _stopwatchPage.clear()
                    }
                }
            }
        }

        Loader {
            id: lapListViewLoader
            anchors {
                top: buttonRow.bottom
                left: parent.left
                right: parent.right
                topMargin: units.gu(1)
            }
            height: units.gu(7) * lapsModel.count
            sourceComponent: !_stopwatchPage.running && _stopwatchPage.totalTimeDiff == 0 ? undefined : lapListViewComponent
        }

        Component {
            id: lapListViewComponent
            LapListView {
                id: lapListView
                model: lapsModel
            }
        }
    }
}
