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
import Timer 1.0
import Ubuntu.Components 1.3

import "../components"

Item {
    id: _timerPage
    objectName: "timerPage"

    property alias isRunning: timerEngine.running

    Component.onCompleted: {
        console.log("[LOG]: Timer Page Loaded")
    }


    TimerEngine {
        id: timerEngine
    }

    TimerFace {
        id: timerFace
        objectName: "timerFace"

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
            top: timerFace.bottom
            topMargin: units.gu(4)
            horizontalCenter: parent.horizontalCenter
            margins: units.gu(2)
        }

        ActionIcon {
            id:saveTimerButton
            objectName:"saveTimerButton"
            icon.name: "save"
            width: units.gu(7)
            height: units.gu(4)
            icon.color: UbuntuColors.slate
            enabled: timerFace.hasTime
            opacity: timerFace.hasTime ? 1: 0

            Behavior on opacity {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }

        }

        Button {
            id: startStopButton
            objectName: "startAndStopButton"
            width: _timerPage.width / 2 - units.gu(1)
            height: units.gu(4)
            enabled: timerEngine.isRunning || timerFace.hasTime
            color: !timerEngine.isRunning  ? UbuntuColors.green : UbuntuColors.red
            text: timerEngine.isRunning ? i18n.tr("Stop") : (true ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {

            }
        }
        ActionIcon {
            id:resetTimerButton
            objectName:"resetTimerButton"
            icon.name: "reset"
            width: units.gu(7)
            height: units.gu(4)
            enabled: timerFace.hasTime
            opacity:  timerFace.hasTime ? 1: 0
            Behavior on opacity {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }

            onClicked: {
                timerFace.reset()
            }
        }
    }

    NestedListviewsHack {
        z:10
        parentListView : listview
        nestedListView : lapListView
    }

    TimerListView {
         id: timersList
         objectName: "timersList"
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
