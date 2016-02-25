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
import Ubuntu.Test 1.0
import Ubuntu.Components 1.3
import Qt.labs.folderlistmodel 2.1
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)

    Alarm {
        id: _alarm
        sound: "file:///usr/share/sounds/ubuntu/ringtones/Bliss.ogg"
    }

    AlarmSound {
        id: alarmSoundPage
        alarm: _alarm
        alarmSound: { "subText": "Bliss" }
    }

    UbuntuTestCase {
        id: alarmSoundPageTest
        name: "AlarmSoundPage"

        when: windowShown

        property var repeater
        property var saveButton

        function initTestCase() {
            alarmSoundPage.visible = true
            repeater = findChild(alarmSoundPage, "alarmSounds")
            saveButton = findChild(header, "saveAction_header_button")
        }

        function cleanup() {
            alarmSoundPage.alarmSound.subText = "Bliss"
            _alarm.sound = "file:///usr/share/sounds/ubuntu/ringtones/Bliss.ogg"
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundListItem = findChild(alarmSoundPage, "alarmSoundDelegate" + i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName" + i)

                if(alarmSoundPage.alarmSound.subText === alarmSoundLabel.text) {
                    alarmSoundListItem.isChecked = true
                }

                else {
                    alarmSoundListItem.isChecked = false
                }
            }
        }

        /*
         Test to check if the default alarm sound is checked while the rest are not.
        */
        function test_defaultAlarmSoundIsChecked() {
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundListItem = findChild(alarmSoundPage, "alarmSoundDelegate"+i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName"+i)

                if(alarmSoundPage.alarmSound.subText === alarmSoundLabel.text) {
                    compare(alarmSoundListItem.isChecked, true, "Default alarm sound is not checked by default")
                }

                else {
                    compare(alarmSoundListItem.isChecked, false, "Switch for alarm sounds not default is enabled incorrectly")
                }
            }
        }

        /*
         Test to check if only one alarm sound is checked at all times
        */
        function test_onlyOneAlarmSoundIsSelected() {
            // Click on some random alarm sounds
            var secondSwitch = findChild(alarmSoundPage, "alarmSoundDelegate" + 2)
            mouseClick(secondSwitch, centerOf(secondSwitch).x, centerOf(secondSwitch).y)

            var fourthSwitch = findChild(alarmSoundPage, "alarmSoundDelegate" + 4)
            mouseClick(fourthSwitch, centerOf(fourthSwitch).x, centerOf(fourthSwitch).y)

            // Check if only that alarm sound is check while the rest is disabled
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundListItem = findChild(alarmSoundPage, "alarmSoundDelegate" + i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName" + i)

                if(i !== 4) {
                    compare(alarmSoundListItem.isChecked, false, "More than one alarm sound selected")
                }
            }
        }

        /*
         Test to check if clicking on the only selected alarm sound does not disable
         it which would other wise leave no alarm sound being selected.
        */
        function test_soundListHasNoEmptySelection() {

            for(var i=0; i<repeater.count; i++) {
                var alarmSoundListItem = findChild(alarmSoundPage, "alarmSoundDelegate" + i)

                if(alarmSoundListItem.isChecked) {
                    mouseClick(alarmSoundListItem, centerOf(alarmSoundListItem).x, centerOf(alarmSoundListItem.height).y)
                    compare(alarmSoundListItem.isChecked, true, "Clicking on the only selected alarm sound disabled it")
                    break;
                }
            }
        }

        /*
         Test to check if the save button is disabled when no changes have been made
         and enabled when changes are made.
        */
        function test_saveButtonIsDisabledOnNoChanges() {
            compare(saveButton.enabled, false, "save header button is not disabled despite no alarm sound change")

            // Change sound and check if save button is enabled
            var fifthSwitch = findChild(alarmSoundPage, "alarmSoundDelegate" + 5)
            mouseClick(fifthSwitch, centerOf(fifthSwitch).x, centerOf(fifthSwitch).y)
            compare(saveButton.enabled, true, "save header button is not enabled despite alarm sound change")

            // Set sound to old value and check if save button is disabled
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundListItem = findChild(alarmSoundPage, "alarmSoundDelegate" + i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName" + i)

                if(alarmSoundLabel.text === "Bliss") {
                    mouseClick(alarmSoundListItem, centerOf(alarmSoundListItem).x, centerOf(alarmSoundListItem).y)
                    compare(saveButton.enabled, false, "save header button is not disabled despite no alarm sound change")
                }
            }
        }
    }
}
