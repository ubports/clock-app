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
import "../components"

ClockCircle {
    id: stopwatchCircle

    // Property to hold the total time (in milliseconds)
    property int milliseconds: 0

    isFoldVisible: false

    width: units.gu(24)

    StopwatchFormatTime {
        id: stopwatchFormatTime
    }

    Label {
        id: time
        objectName: "stopwatchTime"

        text: stopwatchFormatTime.millisToTimeString(milliseconds, true)
        font.pixelSize: units.dp(36)
        anchors.centerIn: parent
        color: Theme.palette.normal.baseText
    }

    Label {
        id: miliseconds
        objectName: "stopwatchMilliseconds"

        text: stopwatchFormatTime.millisToString(milliseconds)
        textSize: Label.Large
        color: Theme.palette.normal.baseText
        anchors {
            top: time.bottom
            topMargin: units.gu(1.5)
            horizontalCenter: parent.horizontalCenter
        }
    }

}
