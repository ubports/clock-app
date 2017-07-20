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
        id: timer
        objectName: "timer"

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
            top: timer.bottom
            topMargin: units.gu(4)
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        Button {
            id: startStopButton
            objectName: "startAndStopButton"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 2 - units.gu(1)
            height: units.gu(4)
            color: true? UbuntuColors.green : UbuntuColors.red
            text: true ? i18n.tr("Stop") : (true ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {
            }
            Behavior on x {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        }


    }
}
