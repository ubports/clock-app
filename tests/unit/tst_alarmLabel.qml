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
import Ubuntu.Components 1.3
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)

    Alarm {
        id: _alarm
    }

    AlarmLabel {
        id: alarmLabelPage
        alarm: _alarm
    }

    ClockTestCase {
        id: alarmLabelPageTest
        name: "AlarmLabelPage"

        when: windowShown

        property var header
        property var alarmLabel
        property var backButton
        property var saveButton

        function initTestCase() {
            alarmLabelPage.visible = true
            header = findChild(mainView, "MainView_Header")
            alarmLabel = findChild(alarmLabelPage, "labelEntry")
            backButton = findChild(header, "customBackButton")
            saveButton = findChild(header, "saveAction_button")
        }

        /*
         Test to check if the alarm label has focus true by default to ensure
         that the OSK is shown when the opens the alarm label page.
        */
        function test_01_alarmLabelHasFocus() {
            compare(alarmLabel.focus, true, "Alarm Label does not have focus by default")
        }

        function test_saveButtonEnabled_data() {
            return [
                        {tag: "SameAlarmLabel",        string: "Alarm",      enableStatus: false, error: "Save button is enabled despite no alarm name change!"},
                        {tag: "EmptyAlarmLabel",       string: "",           enableStatus: false, error: "Save button is enabled despite alarm name being empty!" },
                        {tag: "BlankSpacesAlarmLabel", string: "   ",        enableStatus: false, error: "Save button is enabled despite alarm name being empty!" },
                        {tag: "FilledAlarmLabel",      string: "Test Label", enableStatus: true,  error: "Save button is disabled despite alarm name being different!" }
                    ]
        }

        /*
         Test to check if the save header button is enabled/disabled correctly
         for different alarm label scenarios.
        */
        function test_saveButtonEnabled(data) {
            compare(alarmLabel.text, "Alarm", "Default alarm label is not Alarm")
            compare(saveButton.enabled, false, "save header button is not disabled despite no alarm name change")

            clearTextField(alarmLabel)
            typeString(data.string)

            compare(alarmLabel.text, data.string, "Alarm label is not what was type in the textfield")
            compare(saveButton.enabled, data.enableStatus, data.error)

            alarmLabel.text = _alarm.message
        }

        /*
         Test to check if the back button correctly restores the alarm name to
         the old value when the back button is pressed
        */

        function test_backButtonRestoresValues() {
            compare(alarmLabel.text, "Alarm", "Default alarm label is not Alarm")

            clearTextField(alarmLabel)
            typeString("New Alarm Label")
            mouseClick(backButton, centerOf(backButton).x, centerOf(backButton).y)

            compare(_alarm.message, "Alarm", "Alarm name is restored to the old value")

            alarmLabel.text = _alarm.message
        }

        /*
         Test to check if the save button correctly saves the new alarm name to
         the alarm object when the save button is pressed
        */
        function test_saveButtonSavesNewValues() {
            compare(alarmLabel.text, "Alarm", "Default alarm label is not Alarm")
            compare(_alarm.message, "Alarm", "Default alarm message is not Alarm")

            clearTextField(alarmLabel)
            typeString("New Alarm Label")
            pressHeaderButton(header, "saveAction")

            compare(_alarm.message, "New Alarm Label", "Alarm message has not changed despite pressing the save button")
            _alarm.reset()
        }

        /*
         Test to check if the alarm label text is set to the alarm message
         when the page is loaded.
        */
        function test_alarmLabelIsSameAsAlarmMessage() {
            _alarm.message = "Random Alarm Label"
            compare(alarmLabel.text, "Random Alarm Label", "Alarm label set is not the same as alarm message")
            _alarm.reset()
        }
    }
}
