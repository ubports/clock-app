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

import QtQuick 2.4
import Ubuntu.Components 1.2
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)
    useDeprecatedToolbar: false

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

        function initTestCase() {
            alarmLabelPage.visible = true
            header = findChild(mainView, "MainView_Header")
            alarmLabel = findChild(alarmLabelPage, "labelEntry")
            backButton = findChild(header, "customBackButton")
        }

        /*
         Test to check if the alarm label has focus true by default to ensure
         that the OSK is shown when the opens the alarm label page.
        */
        function test_01_alarmLabelHasFocus() {
            compare(alarmLabel.focus, true, "Alarm Label does not have focus by default")
        }

        function test_backButtonEnabled_data() {
            return [
                        {tag: "EmptyAlarmLabel",       string: "",           enableStatus: false},
                        {tag: "BlankSpacesAlarmLabel", string: "   ",        enableStatus: false},
                        {tag: "FilledAlarmLabel",      string: "Test Label", enableStatus: true}
                    ]
        }

        /*
         Test to check if the back header button is enabled/disabled correctly
         for different alarm label scenarios.
        */
        function test_backButtonEnabled(data) {
            compare(alarmLabel.text, "Alarm", "Default alarm label is not Alarm")
            compare(backButton.enabled, true, "Back header button is not enabled by default")

            clearTextField(alarmLabel)
            typeString(data.string)

            compare(alarmLabel.text, data.string, "Alarm label is not what was type in the textfield")
            compare(backButton.enabled, data.enableStatus, "Back Button enable status is not as expected")

            alarmLabel.text = _alarm.message
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
