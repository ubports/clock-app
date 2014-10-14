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
import DateTime 1.0
import Ubuntu.Components 1.1
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)
    useDeprecatedToolbar: false

    property var clockTime: new Date
                            (
                                localTimeSource.localDateString.split(":")[0],
                                localTimeSource.localDateString.split(":")[1]-1,
                                localTimeSource.localDateString.split(":")[2],
                                localTimeSource.localTimeString.split(":")[0],
                                localTimeSource.localTimeString.split(":")[1],
                                localTimeSource.localTimeString.split(":")[2],
                                localTimeSource.localTimeString.split(":")[3]
                            )

    AlarmModel {
        id: alarmModel
    }

    AlarmUtils {
        id: alarmUtils
    }

    DateTime {
        id: localTimeSource
        updateInterval: 1000
    }

    PageStack {
        id: pageStack
        Component.onCompleted: push(alarmPage)
    }

    AlarmPage {
        id: alarmPage
    }

    ClockTestCase {
        id: alarmTest
        name: "AlarmTest"

        when: windowShown

        property var header
        property var backButton

        function initTestCase() {
            header = findChild(mainView, "MainView_Header")
            backButton = findChild(alarmTest.header, "customBackButton")
        }

        // *************  Helper Functions ************

        function _pressListItem(page, objectName) {
            var listitem = findChild(page, objectName)
            mouseClick(listitem, centerOf(listitem).x, centerOf(listitem).y)
        }

        function _waitForPickerToStopMoving(picker) {
            waitForRendering(picker);
            tryCompareFunction(function(){return picker.moving}, false);
        }

        function _setAlarmTime(picker, time) {
            picker.date = time
            _waitForPickerToStopMoving(picker)
        }

        function _setAlarmRepeatDays(alarmRepeatPage, days) {
            var repeater = findChild(alarmRepeatPage, "alarmDays")
            var daySwitch

            for (var j=0; j<repeater.count; j++) {
                daySwitch = findChild(alarmRepeatPage, "daySwitch"+j)
                if(daySwitch.checked) {
                    mouseClick(daySwitch, centerOf(daySwitch).x, centerOf(daySwitch).y)
                }
            }

            for (var i=0; i<days.length; i++) {
                daySwitch = findChild(alarmRepeatPage, "daySwitch"+days[i])
                if(!daySwitch.checked) {
                    mouseClick(daySwitch, centerOf(daySwitch).x, centerOf(daySwitch).y)
                }
            }
        }

        function _setAlarmLabel(alarmLabelPage, label) {
            var alarmLabel = findChild(alarmLabelPage, "labelEntry")
            clearTextField(alarmLabel)
            typeString(label)
        }

        function _setAlarmSound(alarmSoundPage) {
            var secondSwitch = findChild(alarmSoundPage, "soundStatus"+2)
            mouseClick(secondSwitch, centerOf(secondSwitch).x, centerOf(secondSwitch).y)
        }

        function findAlarm(label, repeat, time, status) {
            var alarmsList = findChild(alarmPage, "alarmListView")

            for (var i=0; i<alarmsList.count; i++) {
                var alarmLabel = findChild(alarmsList, "listAlarmLabel"+i)
                var alarmRepeat = findChild(alarmsList, "listAlarmSubtitle"+i)
                var alarmTime = findChild(alarmsList, "listAlarmTime"+i)
                var alarmStatus = findChild(alarmsList, "listAlarmStatus"+i)

                if (label === alarmLabel.text
                        && time === alarmTime.text
                        && repeat === alarmRepeat.text
                        && status === alarmStatus.checked)
                {
                    return i;
                }
            }

            return -1;
        }

        function _assertAlarmCreation(label, repeat, time, status) {
            if (findAlarm(label, repeat, time, status) === -1) {
                fail("No Alarm found with the specified characteristics")
            }
        }

        function _assertListItemValue(page, objectName, expectedValue, message) {
            var listitem = findChild(page, objectName)
            compare(listitem.subText, expectedValue, message)
        }

        function _deleteAlarm(label, repeat, time, status) {
            var alarmsList = findChild(alarmPage, "alarmListView")
            var oldCount = alarmsList.count

            var index  = findAlarm(label, repeat, time, status)
            var alarmObject = findChild(alarmsList, "alarm"+index)

            if (index !== -1) {
                swipeToDeleteItem(alarmObject)
            }

            tryCompare(alarmsList, "count", oldCount-1, 10000, "Alarm count did not decrease after deleting the alarm")
        }

        function _setAlarm(label, repeat, time) {
            pressHeaderButton(header, "addAlarmAction")

            var addAlarmPage = findChild(pageStack, "AddAlarmPage")
            waitForRendering(addAlarmPage)

            // Set the alarm time
            var alarmTimePicker = findChild(pageStack, "alarmTime")
            _setAlarmTime(alarmTimePicker, time)

            // Set the alarm repeat options
            _pressListItem(addAlarmPage, "alarmRepeat")
            var alarmRepeatPage = getPage(pageStack, "alarmRepeatPage")
            _setAlarmRepeatDays(alarmRepeatPage, repeat)
            pressButton(backButton)

            waitForRendering(addAlarmPage)

            // Set the alarm label
            _pressListItem(addAlarmPage, "alarmLabel")
            var alarmLabelPage = getPage(pageStack, "alarmLabelPage")
            _setAlarmLabel(alarmLabelPage, label)
            pressButton(backButton)

            waitForRendering(addAlarmPage)

            // Set the alarm sound
            _pressListItem(addAlarmPage, "alarmSound")
            var alarmSoundPage = getPage(pageStack, "alarmSoundPage")
            _setAlarmSound(alarmSoundPage)
            pressButton(backButton)

            waitForRendering(addAlarmPage)

            pressHeaderButton(header, "saveAlarmAction")

            waitForRendering(alarmPage)
        }

        function _editAlarm(oldlabel, oldrepeat, oldtime, status, newlabel, newrepeat, newtime) {
            // Find the index of the alarm which needs to be edited
            var alarmIndex = findAlarm(oldlabel, oldrepeat, oldtime, status)

            if (alarmIndex === -1) {
                fail("Cannot find saved alarm to edit")
            }

            // Press the alarm to be edited
            var alarmsList = findChild(alarmPage, "alarmListView")
            var alarmObject = findChild(alarmsList, "alarm"+alarmIndex)
            mouseClick(alarmObject, centerOf(alarmObject).x, centerOf(alarmObject).y)

            /*
             Proceed to verify the alarm read is correct and then set new values.
             The values are verified after the alarm is read from the alarm model
             to prevent regressions like http://pad.lv/1338697 in the future.
            */
            var addAlarmPage = findChild(pageStack, "AddAlarmPage")
            waitForRendering(addAlarmPage)

            var alarmTimePicker = findChild(pageStack, "alarmTime")
            compare(Qt.formatTime(alarmTimePicker.date), oldtime, "Time read from the saved alarm is incorrect")
            _setAlarmTime(alarmTimePicker, newtime)

            _assertListItemValue(addAlarmPage, "alarmRepeat", oldrepeat, "Alarm repeat options read from the saved alarm is incorrect")
            _pressListItem(addAlarmPage, "alarmRepeat")
            var alarmRepeatPage = getPage(pageStack, "alarmRepeatPage")
            _setAlarmRepeatDays(alarmRepeatPage, newrepeat)
            pressButton(backButton)

            waitForRendering(addAlarmPage)

            _assertListItemValue(addAlarmPage, "alarmLabel", oldlabel, "Alarm name read from the saved alarm is incorrect")
            _pressListItem(addAlarmPage, "alarmLabel")
            var alarmLabelPage = getPage(pageStack, "alarmLabelPage")
            _setAlarmLabel(alarmLabelPage, newlabel)
            pressButton(backButton)

            waitForRendering(addAlarmPage)

            _assertListItemValue(addAlarmPage, "alarmSound", "Celestial", "Alarm sound read from the saved alarm is incorrect")
            _pressListItem(addAlarmPage, "alarmSound")
            var alarmSoundPage = getPage(pageStack, "alarmSoundPage")
            _setAlarmSound(alarmSoundPage)
            pressButton(backButton)

            waitForRendering(addAlarmPage)

            pressHeaderButton(header, "saveAlarmAction")

            waitForRendering(alarmPage)
        }

        // *************  Test Functions ************

        function test_01_createAlarm_data() {
            return [
                        {tag: "Weekday Alarms",   name: "Weekday Alarm",    repeat: [0,1,2,3,4], repeatLabel: "Weekdays"},
                        {tag: "Weekend Alarms",   name: "Weekend Alarm",    repeat: [5,6],       repeatLabel: "Weekends"},
                        {tag: "Random Day Alarm", name: "Random Day Alarm", repeat: [1,3],       repeatLabel: String("%1, %2").arg(Qt.locale().standaloneDayName(2, Locale.LongFormat)).arg(Qt.locale().standaloneDayName(4, Locale.LongFormat))}
                    ]
        }

        // Test to check if creating an alarm works as expected
        function test_01_createAlarm(data) {
            var date = new Date()
            date.setHours((date.getHours() + 10) % 24)
            date.setMinutes((date.getMinutes() + 40) % 60)
            date.setSeconds(0)

            _setAlarm(data.name, data.repeat, date)
            _assertAlarmCreation(data.name, data.repeatLabel, Qt.formatTime(date), true)

            /*
             #FIXME: This won't be required once we mock up alarm data. Until
             then we need to delete alarms to cleanup after the tests.
            */
            _deleteAlarm(data.name, data.repeatLabel, Qt.formatTime(date), true)
        }

        // Test to check if editing an alarm and saving it works as expected
        function test_02_editAlarm() {
            var date = new Date()
            date.setHours((date.getHours() + 10) % 24)
            date.setMinutes((date.getMinutes() + 40) % 60)
            date.setSeconds(0)

            _setAlarm("Test Edit Alarm", [0,1,2,3,4], date)

            var newDate = new Date()
            newDate.setHours((newDate.getHours() + 5) % 24)
            newDate.setMinutes((newDate.getMinutes() + 15) % 60)
            newDate.setSeconds(0)

            _editAlarm("Test Edit Alarm", "Weekdays", Qt.formatTime(date), true, "Alarm Edited", [5,6], newDate)

            /*
             #NOTE: This wait is required since as per the design after an alarm is edited and saved
             it shows the remaining time to that alarm and then after 5 secs shows the alarm
             frequency. Hence we need to wait for 5 seconds before confirming alarm creation.
            */
            wait(6000)

            _assertAlarmCreation("Alarm Edited", "Weekends", Qt.formatTime(newDate), true)

            /*
             #FIXME: This won't be required once we mock up alarm data. Until
             then we need to delete alarms to cleanup after the tests.
            */
            _deleteAlarm("Alarm Edited", "Weekends", Qt.formatTime(newDate), true)
        }
    }
}
