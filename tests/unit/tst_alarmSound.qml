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
import Qt.labs.folderlistmodel 2.1
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)
    useDeprecatedToolbar: false

    Alarm {
        id: _alarm
    }

    FolderListModel {
        id: _soundModel

        showDirs: false
        nameFilters: [ "*.ogg", "*.mp3" ]
        folder: "/usr/share/sounds/ubuntu/ringtones"
    }

    AlarmSound {
        id: alarmSoundPage
        alarm: _alarm
        soundModel: _soundModel
        alarmSound: { "subText": "Bliss" }
    }

    UbuntuTestCase {
        id: alarmSoundPageTest
        name: "AlarmSoundPage"

        when: windowShown

        property var repeater

        function initTestCase() {
            alarmSoundPage.visible = true
            repeater = findChild(alarmSoundPage, "alarmSounds")
        }

        function cleanup() {
            alarmSoundPage.alarmSound.subText = "Bliss"
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundSwitch = findChild(alarmSoundPage, "soundStatus"+i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName"+i)

                if(alarmSoundPage.alarmSound.subText === alarmSoundLabel.text) {
                    alarmSoundSwitch.checked = true
                }

                else {
                    alarmSoundSwitch.checked = false
                }
            }
        }

        /*
         Test to check if the default alarm sound is checked while the rest are not.
        */
        function test_defaultAlarmSoundIsChecked() {
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundSwitch = findChild(alarmSoundPage, "soundStatus"+i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName"+i)

                if(alarmSoundPage.alarmSound.subText === alarmSoundLabel.text) {
                    compare(alarmSoundSwitch.checked, true, "Default alarm sound is not checked by default")
                }

                else {
                    compare(alarmSoundSwitch.checked, false, "Switch for alarm sounds not default is enabled incorrectly")
                }
            }
        }

        /*
         Test to check if only one alarm sound is checked at all times
        */
        function test_onlyOneAlarmSoundIsSelected() {

            // Click on some random alarm sounds
            var secondSwitch = findChild(alarmSoundPage, "soundStatus"+2)
            mouseClick(secondSwitch, secondSwitch.width/2, secondSwitch.height/2)

            var fourthSwitch = findChild(alarmSoundPage, "soundStatus"+2)
            mouseClick(fourthSwitch, fourthSwitch.width/2, fourthSwitch.height/2)

            // Check if only that alarm sound is check while the rest is disabled
            for(var i=0; i<repeater.count; i++) {
                var alarmSoundSwitch = findChild(alarmSoundPage, "soundStatus"+i)
                var alarmSoundLabel = findChild(alarmSoundPage, "soundName"+i)

                if(i !== 2) {
                    compare(alarmSoundSwitch.checked, false, "More than one alarm sound selected")
                }
            }
        }

        /*
         Test to check if clicking on the only selected alarm sound does not disable
         it which would other wise leave no alarm sound being selected.
        */
        function test_soundListHasNoEmptySelection() {

            for(var i=0; i<repeater.count; i++) {
                var alarmSoundSwitch = findChild(alarmSoundPage, "soundStatus"+i)

                if(alarmSoundSwitch.checked) {
                    mouseClick(alarmSoundSwitch, alarmSoundSwitch.width/2, alarmSoundSwitch.height/2)
                    compare(alarmSoundSwitch.checked, true, "Clicking on the only selected alarm sound disabled it")
                    break;
                }
            }
        }
    }
}
