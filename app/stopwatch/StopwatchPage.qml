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

    property int totalTime: 0

    Component.onCompleted: {
        console.log("[LOG]: Stopwatch Page Loaded")
    }

    Timer {
        id: refreshTimer
        interval: 45
        repeat: true
        running: stopwatchEngine.isRunning()
        onTriggered: {
             _stopwatchPage.totalTime = stopwatchEngine.getTotalTimeOfStopwatch()
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
            width: stopwatchEngine.getPreviousTimeInmsecs() !== 0 || stopwatchEngine.isRunning ? (parent.width - parent.spacing) / 2 : parent.width
            color: !stopwatchEngine.isRunning() ? UbuntuColors.green : UbuntuColors.red
            text: stopwatchEngine.isRunning ? i18n.tr("Stop") : (stopwatchEngine.getPreviousTimeInmsecs() === 0 ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {
                if (stopwatchEngine.isRunning()) {
                    stopwatchEngine.stopStopwatch();
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
            text: stopwatchEngine.isRunning() ? i18n.tr("Lap") : i18n.tr("Clear")
            width:  stopwatchEngine.getPreviousTimeInmsecs() !== 0 || stopwatchEngine.isRunning() ? (parent.width - parent.spacing) / 2 : 0
            strokeColor: UbuntuColors.lightGrey
            visible:  stopwatchEngine.getPreviousTimeInmsecs() !== 0 || stopwatchEngine.isRunning()
            onClicked: {
                if (stopwatchEngine.isRunning()) {
                    stopwatchEngine.addLap(_stopwatchPage.totalTime)
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
            sourceComponent: !stopwatchEngine.isRunning() && _stopwatchPage.totalTime == 0 ? undefined : lapListViewComponent
        }
    }

    StopwatchEngine {
        id: stopwatchEngine
    }

    Component {
        id: lapListViewComponent
        LapListView {
            id: lapListView
            model: stopwatchEngine
        }
    }
}
