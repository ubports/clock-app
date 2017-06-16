/*
 * Copyright (C) 2015-2016 Canonical Ltd
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
import Ubuntu.Components 1.3

Item {
    id: _stopwatchPage
    objectName: "stopwatchPage"

    property alias isRunning: stopwatchEngine.running

    Component.onCompleted: {
        console.log("[LOG]: Stopwatch Page Loaded")
    }

    // HACK : This is anpartof the hack fix in line #126
    MouseArea {
        z:1
        anchors {
            top: parent.top
            left:parent.left
            right:parent.right
            bottom: buttonRow.bottom
        }
        propagateComposedEvents: true
        onPressed: { listview.interactive = true ; mouse.accepted = false }
    }

    StopwatchEngine {
        id: stopwatchEngine
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

    Item {
        id: buttonRow

        width: parent.width - units.gu(4)
        height: units.gu(4)
        anchors {
            top: stopwatch.bottom
            topMargin: units.gu(4)
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        Button {
            id: startStopButton
            objectName: "startAndStopButton"

            width: parent.width / 2 - units.gu(1)
            height: units.gu(4)
            x: stopwatchEngine.previousTimeOfStopwatch !== 0 || stopwatchEngine.running ? 0 : (parent.width - width) / 2
            color: !stopwatchEngine.running ? UbuntuColors.green : UbuntuColors.red
            text: stopwatchEngine.running ? i18n.tr("Stop") : (stopwatchEngine.previousTimeOfStopwatch === 0 ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {
                if (stopwatchEngine.running) {
                    stopwatchEngine.pauseStopwatch();
                } else {
                    stopwatchEngine.startStopwatch();
                }
            }
            Behavior on x {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        }

        Button {
            id: lapButton
            objectName: "lapAndClearButton"

            text: stopwatchEngine.running ? i18n.tr("Lap") : i18n.tr("Clear")
            width: parent.width / 2 - units.gu(1)
            height: units.gu(4)
            x: stopwatchEngine.previousTimeOfStopwatch !== 0 || stopwatchEngine.running ? parent.width - width : parent.width
            color: UbuntuColors.porcelain
            visible:  stopwatchEngine.previousTimeOfStopwatch !== 0 || stopwatchEngine.running
            onClicked: {
                if (stopwatchEngine.running) {
                    stopwatchEngine.addLap()
                } else {
                    stopwatchEngine.clearStopwatch()
                    listview.interactive = true
                }
            }
            Behavior on x {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        }
    }


    // HACK : This is an hack to reduce the cases the swiping left/right on a lap might switch between the main view pages
    //        (This a QT issue when you have nested interactive listviews)
    MouseArea {
        z:10
        id:mouseFlickHack
        property bool preventFlick: lapListView.visible
        anchors {
            top:lapListView.top
            left: lapListView.left
            right: lapListView.right
        }
        height : Math.min((1+lapListView.count) * lapListView.headerItem.height,lapListView.height)
        hoverEnabled:true
        propagateComposedEvents: true
        preventStealing: preventFlick
        onPressed: { listview.interactive = !preventFlick ; mouse.accepted = false }
        onEntered: listview.interactive = !preventFlick
        onExited: listview.interactive = true
        onReleased: { listview.interactive = true ; mouse.accepted = false }

    }
    MouseArea {
        z:10
        anchors {
            top:mouseFlickHack.bottom
            left: mouseFlickHack.left
            right: mouseFlickHack.right
            bottom: parent.bottom
        }

        propagateComposedEvents: true
        preventStealing: preventFlick
        onPressed: { listview.interactive = true ; mouse.accepted = false }
    }

   LapListView {
        id: lapListView
        objectName: "lapsList"
        anchors {
            top: buttonRow.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(1)
        }
        visible: stopwatchEngine.running || stopwatchEngine.totalTimeOfStopwatch !== 0
        model: stopwatchEngine
    }
}
