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
import QtTest 1.0
import Stopwatch 1.0
import Ubuntu.Components 1.2
import "../../app/stopwatch"

TestCase {
    id: stopwatchUtilsTest
    name: "StopwatchUtilsLibrary"

    StopwatchUtils {
        id: stopwatchUtils
    }

    /*
     This test checks if the milliseconds is returned correctly in the format
     mmm (string length 3)
    */
    function test_returnMillisecond() {
        var result
        result = stopwatchUtils.millisToString(400)
        compare(result, "400", "Milliseconds not properly converted to the format required")
        result = stopwatchUtils.millisToString(4)
        compare(result, "004", "Milliseconds not properly converted to the format required")
    }

    /*
     This test checks if the time (in milliseconds) to converted to hh:mm:ss
     correctly.
    */
    function test_convertTimeInMillisecondsToString() {
        var timeInMilliseconds = 1123000
        var result = stopwatchUtils.millisToTimeString(timeInMilliseconds, false, true)
        compare(result, "00:18:43", "Time not properly converted from milliseconds to hh:mm:ss")
    }

    /*
     This test checks if the zero prefix is added correctly to ensure that a
     string is always of the specified string length.
    */
    function test_zeroPrefixAddedCorrectly() {
        var str = "32", result
        result = stopwatchUtils.addZeroPrefix(str, 2)
        compare(result, "32", "Zero prefix not added correctly")
        result = stopwatchUtils.addZeroPrefix(str, 3)
        compare(result, "032", "Zero prefix not added correctly")
        result = stopwatchUtils.addZeroPrefix(str, 4)
        compare(result, "0032", "Zero prefix not added correctly")
    }

    /*
     This test checks if the lap time correctly shows or hides the hours
     as requires and returns it as a string.
    */
    function test_lapTimeIncludesHoursCorrectly() {
        var result
        result = stopwatchUtils.lapTimeToString(1123000)
        compare(result, "18:43", "Lap time shows hours despite it not being greater than 0")
        result = stopwatchUtils.lapTimeToString(8323000)
        compare(result, "02:18:43", "Lap time not showing hours despite it being greater than 0")
    }
}
