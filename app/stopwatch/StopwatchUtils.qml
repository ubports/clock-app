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

/*
  Qt Object containing a collection of useful stopwatch functions
*/
QtObject {
    id: stopwatchUtils

    // Function to return only the milliseconds
    function millisToString(millis) {
        return addZeroPrefix(millis % 1000, 3)
    }

    // Function to break down time (milliseconds) to hours, minutes and seconds
    function millisToTimeString(millis, showMilliseconds) {
        var hours, minutes, seconds

        // Break down total time (milliseconds) to hours, minutes and seconds
        seconds = Math.floor(millis / 1000) % 60;
        minutes = Math.floor(millis / 1000 / 60) % 60
        hours = Math.floor(millis / 1000 / 60 / 60)

        // Build the time string without milliseconds
        var timeString = ""
        timeString += addZeroPrefix(hours, 2) + ":"
        timeString += addZeroPrefix(minutes, 2) + ":"
        timeString += addZeroPrefix(seconds, 2)

        if (showMilliseconds) {
            timeString += "." + millisToString(millis)
        }

        return timeString
    }

    // Function to add zero prefix if necessary.
    function addZeroPrefix (str, totalLength) {
        return ("00000" + str).slice(-totalLength)
    }
}
