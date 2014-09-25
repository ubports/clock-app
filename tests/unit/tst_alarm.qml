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
import Ubuntu.Test 1.0
import Ubuntu.Components 1.1
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)
    useDeprecatedToolbar: false

    AlarmModel {
        id: alarmModel
    }

    PageStack {
        id: pageStack
        Component.onCompleted: push(alarmPage)
    }

    AlarmPage {
        id: alarmPage
    }

    UbuntuTestCase {
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

        function _pressAddAlarmHeaderButton() {
            var addButton = findChild(header, "addAlarmAction" + "_header_button")
            mouseClick(addButton, centerOf(addButton).x, centerOf(addButton).y)
        }

        function _pressSaveAlarmHeaderButton() {
            var saveButton = findChild(alarmTest.header, "saveAlarmAction" + "_header_button")
            mouseClick(saveButton, centerOf(saveButton).x, centerOf(saveButton).y)
        }

        function _pressBackButton() {
            mouseClick(backButton, centerOf(backButton).x, centerOf(backButton).y)
        }

        function _pressAlarmRepeatOption(addAlarmPage) {
            var repeatListItem = findChild(addAlarmPage, "alarmRepeat")
            mouseClick(repeatListItem, centerOf(repeatListItem).x, centerOf(repeatListItem).y)
        }

        function _pressAlarmLabelOption(addAlarmPage) {
            var labelListItem = findChild(addAlarmPage, "alarmLabel")
            mouseClick(labelListItem, centerOf(labelListItem).x, centerOf(labelListItem).y)
        }

        function _pressAlarmSoundOption(addAlarmPage) {
            var soundList = findChild(addAlarmPage, "alarmSound")
            mouseClick(soundList, centerOf(soundList).x, centerOf(soundList).y)
        }

        function _getPage(objectName) {
            var page = findChild(pageStack, objectName)
            waitForRendering(page)
            return page
        }

        function _waitPickerMoving(picker) {
            waitForRendering(picker);
            tryCompareFunction(function(){return picker.moving}, false);
        }

        function _setAlarmTime(picker, time) {
            picker.date = time
            _waitPickerMoving(picker)
            return picker.date
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
            mouseClick(alarmLabel, alarmLabel.width - units.gu(2), centerOf(alarmLabel).y)
            mouseClick(alarmLabel, alarmLabel.width - units.gu(2), centerOf(alarmLabel).y)
            typeString(label)
        }

        function _setAlarmSound(alarmSoundPage) {
            var secondSwitch = findChild(alarmSoundPage, "soundStatus"+2)
            mouseClick(secondSwitch, secondSwitch.width/2, secondSwitch.height/2)
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

        function _confirmAlarmCreation(label, repeat, time, status) {
            if (findAlarm(label, repeat, time, status) === -1) {
                fail("No Alarm found with the specified characteristics")
            }
        }

        function _deleteAlarm(label, repeat, time, status) {
            var alarmsList = findChild(alarmPage, "alarmListView")
            var oldCount = alarmsList.count

            var index  = findAlarm(label, repeat, time, status)
            var alarmObject = findChild(alarmsList, "alarm"+index)

            if (index !== -1) {
                mouseDrag(alarmObject, alarmObject.width/4, alarmObject.height/2, units.gu(10), 0)
                mouseRelease(alarmObject, alarmObject.width/4+units.gu(10), alarmObject.height/2)
                mouseClick(alarmObject, units.gu(5), alarmObject.height/2)
            }

            tryCompare(alarmsList, "count", oldCount-1, 10000, "Alarm count did not decrease after deleting the alarm")
        }

        function _setAlarm(label, repeat, time) {
            _pressAddAlarmHeaderButton()

            var addAlarmPage = findChild(pageStack, "AddAlarmPage")
            waitForRendering(addAlarmPage)

            var alarmTimePicker = findChild(pageStack, "alarmTime")
            var date = _setAlarmTime(alarmTimePicker, time)

            _pressAlarmRepeatOption(addAlarmPage)
            var alarmRepeatPage = _getPage("alarmRepeatPage")
            _setAlarmRepeatDays(alarmRepeatPage, repeat)
            _pressBackButton()

            waitForRendering(addAlarmPage)

            _pressAlarmLabelOption(addAlarmPage)
            var alarmLabelPage = _getPage("alarmLabelPage")
            _setAlarmLabel(alarmLabelPage, label)
            _pressBackButton()

            waitForRendering(addAlarmPage)

            _pressAlarmSoundOption(addAlarmPage)
            var alarmSoundPage = _getPage("alarmSoundPage")
            _setAlarmSound(alarmSoundPage)
            _pressBackButton()

            waitForRendering(addAlarmPage)

            _pressSaveAlarmHeaderButton()

            waitForRendering(alarmPage)
        }

        // *************  Test Functions ************

        function test_createAlarm_data() {
            return [
                        {tag: "Weekday Alarms",   name: "Weekday Alarm",    repeat: [0,1,2,3,4], repeatLabel: "Weekdays"},
                        {tag: "Weekend Alarms",   name: "Weekend Alarm",    repeat: [5,6],       repeatLabel: "Weekends"},
                        {tag: "Random Day Alarm", name: "Random Day Alarm", repeat: [1,3],       repeatLabel: String("%1, %2").arg(Qt.locale().standaloneDayName(2, Locale.LongFormat)).arg(Qt.locale().standaloneDayName(4, Locale.LongFormat))}
                    ]
        }

        // Test to check if creating an alarm works as expected
        function test_createAlarm(data) {
            var date = new Date()
            date.setHours((date.getHours() + 10) % 24)
            date.setMinutes((date.getMinutes() + 40) % 60)
            date.setSeconds(0)

            _setAlarm(data.name, data.repeat, date)
            _confirmAlarmCreation(data.name, data.repeatLabel, Qt.formatTime(date), true)

            /*
             #FIXME: This won't be required once we mock up alarm data. Until
             then we need to delete alarms to cleanup after the tests.
            */
            _deleteAlarm(data.name, data.repeatLabel, Qt.formatTime(date), true)
        }
    }
}
