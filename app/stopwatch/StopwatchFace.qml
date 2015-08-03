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
import "../components"

ClockCircle {
    id: outerCirle

    property int milliseconds: 0

    // Function to return only the milliseconds
    function millisToString(millis) {
        return zeroPadding(millis % 1000, 3)
    }

    // Function to break down time (milliseconds) to hours, minutes and seconds
    function millisToTimeString(millis, showMilliseconds) {
        var hours, minutes, seconds, milliseconds

        // Break down total time (milliseconds) to hours, minutes, seconds and milliseconds
        milliseconds = millis % 1000
        seconds = Math.floor(millis / 1000) % 60;
        minutes = Math.floor(millis / 1000 / 60) % 60
        hours = Math.floor(millis / 1000 / 60 / 60)

        // Build the time string without milliseconds
        var timeString = ""
        timeString += zeroPadding(hours, 2) + ":"
        timeString += zeroPadding(minutes, 2) + ":"
        timeString += zeroPadding(seconds, 2)

        if (showMilliseconds) {
            timeString += "." + zeroPadding(milliseconds, 3)
        }

        return timeString
    }

    // Function to add zero prefix if necessary.
    function zeroPadding (str, count) {
        var string, tmp

        string  = "" + str
        tmp = ""
        for (var i = 0; i < count; i++) {
            tmp += "0"
        }
        return (tmp + str).substring(string.length)
    }

    isOuter: true
    width: units.gu(32)

    ClockCircle {
        id: innerCircle

        width: units.gu(23)
        anchors.centerIn: parent
    }

    Column {
        id: text

        width: childrenRect.width
        anchors.centerIn: parent

        Label {
            text: millisToTimeString(milliseconds)
            font.pixelSize: units.dp(42)
            color: UbuntuColors.midAubergine
        }

        Label {
            text: millisToString(milliseconds)
            font.pixelSize: units.dp(22)
            color: UbuntuColors.midAubergine
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
