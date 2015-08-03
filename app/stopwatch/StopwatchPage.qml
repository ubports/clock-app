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

    Flickable {
        id: _flickable

        onFlickStarted: {
            forceActiveFocus()
        }

        clip: true
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: stopwatch.height + stopButton.height

        StopwatchFace {
            id: stopwatch
            objectName: "stopwatch"

            anchors {
                verticalCenter: parent.top
                verticalCenterOffset: units.gu(18)
                horizontalCenter: parent.horizontalCenter
            }
        }

        Button {
            id: stopButton

            text: "Stop"
            width: parent.width/2.5
            anchors {
                left: parent.left
                top: parent.top
                topMargin: units.gu(40)
                margins: units.gu(2)
            }
        }

        Button {
            id: lapButton

            text: "Lap"
            width: parent.width/2.5
            anchors {
                right: parent.right
                top: parent.top
                topMargin: units.gu(40)
                margins: units.gu(2)
            }
        }
    }
}
