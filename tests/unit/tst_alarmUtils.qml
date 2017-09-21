/*
 * Copyright (C) 2014-2016 Canonical Ltd
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
import Ubuntu.Components 1.3
import "../../app/alarm"

TestCase {
    id: alarmUtilsTest
    name: "AlarmUtilsLibrary"

    property string mock_notLocalizedDateTimeString: ""

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

        var currentTime = new Date()
        var futureTime = new Date()
        futureTime.setHours((futureTime.getHours() + 2))
        mockAlarmDatabase.append({"name": "Alarm1", "date": futureTime, "enabled": false})
        futureTime.setHours((futureTime.getHours() + 5))
        mockAlarmDatabase.append({"name": "Alarm2", "date": futureTime, "enabled": true})
        mock_notLocalizedDateTimeString = currentTime.getFullYear().toString() + ":" + (currentTime.getMonth() + 1).toString() + ":" + currentTime.getDate().toString() + ":" + currentTime.getHours().toString() + ":" + currentTime.getMinutes().toString() + ":" +currentTime.getSeconds().toString()
    }

// TODO : set_bottom_edge_title : This feture was never implemented. To enable the tests commented out below once it is implemented
//    /*
//     This test checks if the the bottom edge title is set correctly according
//     to the active alarms amongst other disabled alarms.
//    */
//    function test_bottomEdgeTitleMustDisplayActiveAlarm() {
//        var result = alarmUtils.set_bottom_edge_title(mockAlarmDatabase, mock_notLocalizedDateTimeString)
//        compare(result, "Next Alarm in 7h 1m", "Bottom edge title is incorrect")
//    }
//    /*
//     This test checks if the bottom edge title is correctly set to "No Active
//     Alarms" where there are no enabled alarms"
//    */
//    function test_bottomEdgeTitleMustDisplayNoActiveAlarm() {
//        mockAlarmDatabase.set(1, {"enabled": false})
//        var result = alarmUtils.set_bottom_edge_title(mockAlarmDatabase, mock_notLocalizedDateTimeString)
//        compare(result, "No active alarms", "Bottom edge title is not correctly set when there are no enabled alarms")
//        mockAlarmDatabase.set(1, {"enabled": true})
//    }

//    /*
//     This test checks if the bottom edge title is correctly set with the next
//     immediate active alarm amongst several active alarms"
//    */
//    function test_bottomEdgeTitleMustDisplayNextActiveAlarm() {
//        mockAlarmDatabase.set(0, {"enabled": true})
//        var result = alarmUtils.set_bottom_edge_title(mockAlarmDatabase, mock_notLocalizedDateTimeString)
//        compare(result, "Next Alarm in 2h 1m", "Bottom edge title is not correctly set to the next immediate active alarm where there are multiple active alarms.")
//        mockAlarmDatabase.set(0, {"enabled": false})
//    }
//  End of TODO set_bottom_edge_title

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
     This test checks if the get_time_to_alarm() function takes a time in
     milliseconds and writtens a user readable string e.g "in 2d 15h 10m" after
     correct calculation.
    */
    function test_timeToNextAlarmStringMustShowAll() {
        var currentDateTime = new Date()
        var timeInMilliseconds = ((5 * 24 + 2)* 60 + 15) * 60 * 1000; // 5 days, 2 hrs, 15 mins

        var alarmDate = new Date(currentDateTime.getTime() + timeInMilliseconds);
        var result = alarmUtils.get_time_to_alarm(alarmDate, currentDateTime)
        //one minute is added to make the  display nicer see AlarmUtils:_split_time:129
        compare(result, "in 5d 2h 16m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the get_time_to_alarm() function takes a time in
     milliseconds and writtens a user readable string without days e.g "in 15h 10m"
     after correct calculation.
    */
    function test_timeToNextAlarmStringMustNotShowDays() {
        var timeInMilliseconds = 10 * 60 * 60 * 1000 // 10 hours, 1 min
        var currentDateTime = new Date()
        var alarmDate = new Date(currentDateTime.getTime() + timeInMilliseconds);
        var result = alarmUtils.get_time_to_alarm(alarmDate, currentDateTime)
        compare(result, "in 10h 1m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the get_time_to_alarm() function takes a time in
     milliseconds and writtens a user readable string with only mins e.g "in 10m"
     after correct calculation.
    */
    function test_timeToNextAlarmStringMustOnlyShowMinutes() {
        var timeInMilliseconds = 18 * 60 * 1000 // 19 mins
        var currentDateTime = new Date()
        var alarmDate = new Date(currentDateTime.getTime() + timeInMilliseconds);
        var result = alarmUtils.get_time_to_alarm(alarmDate, currentDateTime)
        compare(result, "in 19m", "Time to next alarm string is incorrect")
    }

    /*
     This test checks if the _get_day() function takes in the daysOfWeek value
     and returns the correct alarm day names.
    */
    function test_alarmDayString() {
        var value = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Sunday
        var result = alarmUtils._get_day(value)
        var expectedResult = "%1, %2, %3, %4".arg(Qt.locale().standaloneDayName(1, Locale.ShortFormat)).arg(Qt.locale().standaloneDayName(2, Locale.ShortFormat)).arg(Qt.locale().standaloneDayName(3, Locale.ShortFormat)).arg(Qt.locale().standaloneDayName(0, Locale.ShortFormat))
        compare(result, expectedResult, "Alarm Day not properly formatted")
    }

    /*
     This test checks if the format_day_string() returns "Never" if a one-time
     alarm is passed to it for the alarm recurrence string.
    */
    function test_alarmRecurrenceStringMustShowNever() {
        var alarmType = Alarm.OneTime
        var alarmDaysOfWeek = Alarm.AutoDetect
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Never", "OneTime Alarm is shown as a repeating alarm")
    }

    /*
     This test checks if the format_day_string() returns the alarm days if the
     alarms days passed if it doesn't fit other formats like Weekdays, Weekends etc.
    */
    function test_alarmRecurrenceStringMustShowAlarmDays() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        var expectedResult = "%1, %2".arg(Qt.locale().standaloneDayName(1, Locale.ShortFormat)).arg(Qt.locale().standaloneDayName(2, Locale.ShortFormat))
        compare(result, expectedResult, "Repeating alarm days of week is not formatted correctly")
    }

    /*
     This test checks if the format_day_string() returns "Weekdays" if all week days (Mon-Fri)
     of a week are selected.
    */
    function test_alarmRecurrenceStringMustShowWeekdays() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Weekdays", "Repeating alarm days of week is not formatted correctly")
    }

    /*
     This test checks if the format_day_string() returns "Weekends" (Sat-Sun) if the
     weekends of a week are selected.
    */
    function test_alarmRecurrenceStringMustShowWeekends() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Saturday | Alarm.Sunday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Weekends", "Repeating alarm days of week is not formatted correctly")
    }

    /*
     This test checks if the format_day_string() returns "Days" if all days
     of a week are selected.
    */
    function test_alarmRecurrenceStringMustShowDaily() {
        var alarmType = Alarm.Repeating
        var alarmDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday | Alarm.Saturday | Alarm.Sunday
        var result = alarmUtils.format_day_string(alarmDaysOfWeek, alarmType)
        compare(result, "Daily", "Repeating alarm days of week is not formatted correctly")
    }
}
