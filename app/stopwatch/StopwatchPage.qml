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
import Ubuntu.Components 1.2

Item {
    id: _stopwatchPage
    objectName: "stopwatchPage"

    Component.onCompleted: {
        console.log("[LOG]: Stopwatch Page Loaded")
    }

    StopwatchFace {
        id: stopwatch
        objectName: "stopwatch"

        milliseconds: stopwatchEngine.totalTimeOfStopwatch

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
            width: stopwatchEngine.previousTimeOfStopwatch !== 0 || stopwatchEngine.running ? (parent.width - parent.spacing) / 2 : parent.width
            color: !stopwatchEngine.running ? UbuntuColors.green : UbuntuColors.red
            text: stopwatchEngine.running ? i18n.tr("Stop") : (stopwatchEngine.previousTimeOfStopwatch === 0 ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {
                if (stopwatchEngine.running) {
                    stopwatchEngine.pauseStopwatch();
                } else {
                    stopwatchEngine.startStopwatch();
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
            text: stopwatchEngine.running ? i18n.tr("Lap") : i18n.tr("Clear")
            width:  stopwatchEngine.previousTimeOfStopwatch !== 0 || stopwatchEngine.running ? (parent.width - parent.spacing) / 2 : 0
            strokeColor: UbuntuColors.lightGrey
            visible:  stopwatchEngine.previousTimeOfStopwatch !== 0 || stopwatchEngine.running
            onClicked: {
                if (stopwatchEngine.running) {
                    stopwatchEngine.addLap()
                } else {
                    stopwatchEngine.clearStopwatch()
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
            sourceComponent: !stopwatchEngine.running && stopwatchEngine.totalTimeOfStopwatch === 0 ? undefined : lapListViewComponent
        }
    }

    Component {
        id: lapListViewComponent
        LapListView {
            id: lapListView
            model: stopwatchEngine
        }
    }
}
