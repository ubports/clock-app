/*
 * Copyright (C) 2014-2015 Canonical Ltd
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
import Ubuntu.Test 1.0
import Ubuntu.Components 1.3
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)

    Alarm {
        id: _alarm
    }

    AlarmUtils {
        id: _alarmUtils
    }

    Component {
        id: alarmRepeatPage
        AlarmRepeat {
            alarm: _alarm
            alarmUtils: _alarmUtils
        }
    }

    Loader {
        id: alarmRepeatPageLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    UbuntuTestCase {
        id: alarmRepeatPageTest
        name: "AlarmRepeatPage"

        when: windowShown

        property var header
        property var backButton
        property var saveButton
        property var repeater
        property var today: Qt.locale().standaloneDayName(
                                new Date().getDay(), Locale.LongFormat)

        function init() {
            alarmRepeatPageLoader.sourceComponent = alarmRepeatPage
            alarmRepeatPageLoader.item.visible = true
            spy.target = alarmRepeatPageLoader.item.Component
            header = findChild(mainView, "MainView_Header")
            backButton = findChild(header, "customBackButton")
            saveButton = findChild(header, "saveAction_header_button")
            repeater = findChild(alarmRepeatPageLoader.item, "alarmDays")
        }

        function cleanup() {
            alarmRepeatPageLoader.sourceComponent = undefined
            spy.wait()
            tryCompare(spy, "count", 1)
            _alarm.reset()
            tryCompare(_alarm, "status", Alarm.Ready)
            spy.clear()
            spy.target = undefined
        }

        SignalSpy {
            id: spy
            signalName: "destruction"
        }

        /*
         Test to check if none of the switches are checked by default since by
         default an alarm is an one-time alarm and in the repeat page none of
         the days must be checked
        */
        function test_01_allSwitchesAreUncheckedByDefault() {
            waitForRendering(alarmRepeatPageLoader.item);

            tryCompare(_alarm, "daysOfWeek", 0, 3000, "Alarm days of weeks is not 0 by default")

            for(var i=0; i<repeater.count; i++) {
                var currentDayLabel = findChild(alarmRepeatPageLoader.item, "alarmDay"+i)
                var currentDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+i)

                compare(currentDaySwitch.checked, false, "All switches are not disabled by default")
            }
        }

        /*
         Test to check if the save button is disabled when no changes have been made
         and enabled when changes are made.
        */
        function test_saveButtonIsDisabledOnNoChanges() {
            waitForRendering(alarmRepeatPageLoader.item);

            tryCompare(_alarm, "daysOfWeek", 0, 3000, "Alarm days of weeks is not 0 by default")
            compare(saveButton.enabled, false, "save header button is not disabled despite no alarm frequency change")

            var randomDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+3)
            mouseClick(randomDaySwitch, centerOf(randomDaySwitch).x, centerOf(randomDaySwitch).y)
            compare(saveButton.enabled, true, "save header button is not disabled despite no alarm frequency change")
        }

        /*
         Test to check if the alarm types are being correctly changed when
         toggling some of the swtiches. So if a switch is toggle, the alarm
         should become a repeating alarm. if no switches are enabled then
         it should be a one time alarm.
        */
        function test_alarmTypeSwitch() {
            waitForRendering(alarmRepeatPageLoader.item);

            tryCompare(_alarm, "type", Alarm.OneTime, 3000, "Alarm type is not OneTime by default")

            var randomDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+3)

            mouseClick(randomDaySwitch, centerOf(randomDaySwitch).x, centerOf(randomDaySwitch).y)
            tryCompare(_alarm, "type", Alarm.Repeating, 3000, "Alarm type did not change to Repeating despite enabling a switch")

            mouseClick(randomDaySwitch, centerOf(randomDaySwitch).x, centerOf(randomDaySwitch).y)
            tryCompare(_alarm, "type", Alarm.OneTime, 3000, "Alarm type is not OneTime despite all switches disabled")
        }

        /*
         Test to enable all switches and check if the alarm object has been
         updated correctly
        */
        function test_switchStatusUpdatesAlarmObject() {
            waitForRendering(alarmRepeatPageLoader.item);

            for(var i=0; i<repeater.count; i++) {
                var currentDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+i)

                if(!currentDaySwitch.checked) {
                    mouseClick(currentDaySwitch, centerOf(currentDaySwitch).x, centerOf(currentDaySwitch).y)
                }
            }

            var dailyDaysOfWeek = Alarm.Monday | Alarm.Tuesday | Alarm.Wednesday | Alarm.Thursday | Alarm.Friday | Alarm.Saturday | Alarm.Sunday

            compare(alarmRepeatPageLoader.item.alarm.daysOfWeek, dailyDaysOfWeek, "Alarm Object daysOfWeek value is incorrect w.r.t to the UI")
        }

        /*
         Test to check if the switches are properly toggled based on the alarm
         days of week. This is required when editing an alarm where the switch
         should properly show the days previously selected by the user.
        */
        function test_alarmObjectSetsSwitchStatus() {
            _alarm.type = Alarm.Repeating
            _alarm.daysOfWeek = Alarm.Saturday | Alarm.Sunday

            for(var i=0; i<repeater.count; i++) {
                var currentDayLabel = findChild(alarmRepeatPageLoader.item, "alarmDay"+i)
                var currentDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+i)

                if(currentDayLabel.text === Qt.locale().standaloneDayName(6, Locale.LongFormat) ||
                        currentDayLabel.text === Qt.locale().standaloneDayName(0, Locale.LongFormat)) {
                    compare(currentDaySwitch.checked, true, "Switches in the alarm daysOfWeek are not enabled!")
                }

                else {
                    compare(currentDaySwitch.checked, false, "Switches other than those set in the alarm dayOfWeek are enabled")
                }
            }
        }
    }
}
