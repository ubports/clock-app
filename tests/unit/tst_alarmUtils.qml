/*
 * Copyright (C) 2014 Canonical Ltd
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

import QtQuick 2.3
import QtTest 1.0
import Ubuntu.Components 1.1
import "../../app/alarm"

TestCase {
    id: alarmUtilsTest
    name: "AlarmUtilsLibrary"

    property var futureTime: new Date()
    property var currentTime: new Date()

    AlarmUtils {
        id: alarmUtils
    }

    ListModel {
        id: mockAlarmDatabase
    }

    function initTestCase() {
        /*
         Here the alarm database is mocked by creating 2 alarms in the future.
         The alarm list is as follows,

         Alarm1, currentTime+2hrs, not enabled
         Alarm2, currentTime+7hrs, enabled
        */
        futureTime.setHours((futureTime.getHours() + 2))
        mockAlarmDatabase.append({"name": "Alarm1", "date": futureTime, "enabled": false})
        futureTime.setHours((futureTime.getHours() + 5))
        mockAlarmDatabase.append({"name": "Alarm2", "date": futureTime, "enabled": true})
    }

    /*
     This test checks if the the bottom edge title is set correctly according
     to the active alarms amongst other disabled alarms.
    */
    function test_bottomEdgeTitleMustDisplayActiveAlarm() {
        var result = alarmUtils.set_bottom_edge_title(mockAlarmDatabase, currentTime)
        compare(result, "Next Alarm in 7h 1m", "Bottom edge title is incorrect")
    }

    /*
     This test checks if the bottom edge title is correctly set to "No Active
     Alarms" where there are no enabled alarms"
    */
    function test_bottomEdgeTitleMustDisplayNoActiveAlarm() {
        mockAlarmDatabase.set(1, {"enabled": false})
        var result = alarmUtils.set_bottom_edge_title(mockAlarmDatabase, currentTime)
        compare(result, "No active alarms", "Bottom edge title is not correctly set when there are no enabled alarms")
        mockAlarmDatabase.set(1, {"enabled": true})
    }

    /*
     This test checks if the bottom edge title is correctly set with the next
     immediate active alarm amongst several active alarms"
    */
    function test_bottomEdgeTitleMustDisplayNextActiveAlarm() {
        mockAlarmDatabase.set(0, {"enabled": true})
        var result = alarmUtils.set_bottom_edge_title(mockAlarmDatabase, currentTime)
        compare(result, "Next Alarm in 2h 1m", "Bottom edge title is not correctly set to the next immediate active alarm where there are multiple active alarms.")
        mockAlarmDatabase.set(0, {"enabled": false})
    }

    /*
     This test checks if the _split_time() function takes a time in milliseconds
     and is able to split it into days, hours and minutes correctly.
    */
    function test_splitTime() {
        var timeInMilliseconds = 440100000 // 5 days, 2 hrs, 16 mins
        var result = alarmUtils._split_time(timeInMilliseconds)
        compare(result.days, 5, "Days calculated is incorrect.")
        compare(result.hours, 2, "Hours calculated is incorrect")
        compare(result.minutes, 16, "Minutes calculated is incorrect")
    }

    /*
     This test checks if the get_time_to_next_alarm() function takes a time in
     milliseconds and writtens a user readable string e.g "in 2d 15h 10m" after
     correct calculation.
    */
    function test_timeStringNextAlarm() {
        var timeInMilliseconds, result

        timeInMilliseconds = 440100000; // 5 days, 2 hrs, 16 mins
        result = alarmUtils.get_time_to_next_alarm(timeInMilliseconds)
        compare(result, "in 5d 2h 16m", "Time to next alarm string is incorrect")

        timeInMilliseconds = 36000000 // 10 hours, 1 min
        result = alarmUtils.get_time_to_next_alarm(timeInMilliseconds)
        compare(result, "in 10h 1m", "Time to next alarm string is incorrect")

        timeInMilliseconds = 1080000 // 19 mins
        result = alarmUtils.get_time_to_next_alarm(timeInMilliseconds)
        compare(result, "in 19m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the _get_day() function takes in the daysOfWeek value
     and returns the correct alarm day names.
    */
    function test_alarmDayString() {
        var value = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Sunday
        var result = alarmUtils._get_day(value)
        compare(result, "Monday, Tuesday, Wednesday, Sunday", "Alarm Day not properly formatted")
    }

    /*
     This test checks if the format_day_string() function which is used to display
     a formatted string of the days the alarm rings on works as expected.
    */
    function test_alarmRecurrenceString() {
        var alarmType, alarmDaysOfWeek, result

        alarmType = Alarm.OneTime
        alarmDaysOfWeek = Alarm.AutoDetect
        result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Never", "OneTime Alarm is shown as a repeating alarm")

        alarmType = Alarm.Repeating
        alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday
        result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Monday, Tuesday", "Repeating alarm days of week is not formatted correctly")

        alarmType = Alarm.Repeating
        alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday
        result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Weekdays", "Repeating alarm days of week is not formatted correctly")

        alarmType = Alarm.Repeating
        alarmDaysOfWeek = Alarm.Saturday | Alarm.Sunday
        result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Weekends", "Repeating alarm days of week is not formatted correctly")

        alarmType = Alarm.Repeating
        alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday | Alarm.Saturday | Alarm.Sunday
        result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Daily", "Repeating alarm days of week is not formatted correctly")
    }
}
