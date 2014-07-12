/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1
import Qt.labs.folderlistmodel 2.1
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../components/Utils.js" as Utils

Page {
    id: _addAlarmPage

    // Property to determine if this is a new/saved alarm
    property bool isNewAlarm: true

    // Property to store the index of the alarm to be edited
    property int alarmIndex

    property var tempAlarm

    title: isNewAlarm ? i18n.tr("New Alarm") : i18n.tr("Edit Alarm")
    visible: false

    head {
        backAction: Action {
            iconName: "close"
            onTriggered: {
                mainStack.pop()
            }
        }

        actions: Action {
            iconName: "save"
            text: i18n.tr("Alarm")
            onTriggered: {
                if(isNewAlarm) {
                    saveNewAlarm()
                }
                else {
                    updateAlarm()
                }
            }
        }
    }

    Component.onCompleted: {
        if(!isNewAlarm) {
            readAlarm()
        }
    }

    // Function to save a new alarm
    function saveNewAlarm() {
        var alarmTime = new Date()
        alarmTime.setHours(_timePicker.hours, _timePicker.minutes, 0)

        /*
          _alarm.sound, _alarm.message and _alarm.daysOfWeek have been set in
          the respective individual pages already.
        */

        console.log("Alarm sound being saved: " + _alarm.sound)
        _alarm.date = alarmTime
        _alarm.type = Alarm.Repeating
        _alarm.enabled = true
        _alarm.save()
    }

    // Function to read a saved alarm
    function readAlarm() {
        tempAlarm = alarmModel.get(alarmIndex)

        _alarm.message = tempAlarm.message
        _alarm.type = tempAlarm.type
        _alarm.daysOfWeek = tempAlarm.daysOfWeek
        _alarm.enabled = tempAlarm.enabled
        _alarm.date = tempAlarm.date
        _alarm.sound = tempAlarm.sound
        console.log("Saved Alarm Sound: " + _alarm.sound.toString())
    }

    // Function to update a saved alarm
    function updateAlarm() {
        tempAlarm = alarmModel.get(alarmIndex)

        var alarmTime = new Date()
        alarmTime.setHours(_timePicker.hours, _timePicker.minutes, 0)

        tempAlarm.message = _alarm.message
        tempAlarm.date = alarmTime
        tempAlarm.type = Alarm.Repeating
        tempAlarm.enabled = _alarm.enabled
        tempAlarm.sound = _alarm.sound

        /*
          #FIXME: Sometimes the clock app crashes due to this code. Cause not
          known yet! This has been reported at http://pad.lv/1337405.
        */
        tempAlarm.daysOfWeek = _alarm.daysOfWeek

        tempAlarm.save()

        if(validateAlarm(tempAlarm)) {
            mainStack.pop()
        }
    }

    // Function to validate if the alarm was saved properly
    function validateAlarm(alarmObject) {
        if (alarmObject.error !== Alarm.NoError) {
            Utils.log(debugMode, "Error saving alarm, code: " + alarmObject.error)
            return false
        }
        else {
            return true
        }
    }

    function getSoundName(chosenSoundPath) {
        for(var i=0; i<soundModel.count; i++) {
            if(chosenSoundPath === soundModel.get(i, "filePath")) {
                return soundModel.get(i, "fileBaseName")
            }
        }
    }

    function getSoundPath(chosenSoundName) {
        for(var i=0; i<soundModel.count; i++) {
            if(chosenSoundName === soundModel.get(i, "fileBaseName")) {
                return soundModel.get(i, "filePath")
            }
        }
    }

    Alarm {
        id: _alarm
        onStatusChanged: {
            if (status !== Alarm.Ready)
                return;
            if ((operation > Alarm.NoOperation) &&
                    (operation < Alarm.Reseting)) {
                mainStack.pop();
            }
        }
        onDaysOfWeekChanged: {
            _alarmRepeat.subText = alarmUtils.format_day_string(_alarm.daysOfWeek)
        }
        onDateChanged: {
            _timePicker.date = _alarm.date
        }
    }

    FolderListModel {
        id: soundModel

        /*
          #TODO: Add ubuntu-touch-sounds package as a dependency in the debian
          control file. It is not present by default in Trusty 14.04.
        */

        showDirs: false
        nameFilters: [ "*.ogg", "*.mp3" ]
        folder: "/usr/share/sounds/ubuntu/ringtones"

        onCountChanged: {
            if(count > 0) {
                /*
                  When folder model is completely loaded, proceed to perform
                  the following operations,

                  if new alarm, then set the sound name as "Suru arpeggio" and
                  retrieve the sound path from the folder model

                  If it is a saved alarm, the get sound path from the alarm
                  object and retrieve the sound name from the folder model.
                */
                if(isNewAlarm) {
                    _alarm.sound = getSoundPath(_alarmSound._soundName)
                    _alarmSound.subText = _alarmSound._soundName
                }
                else {
                    _alarmSound.subText = getSoundName(_alarm.sound)
                }
            }
        }
    }

    AlarmUtils {
        id: alarmUtils
    }

    Column {
        id: _alarmColumn

        anchors.fill: parent

        DatePicker {
            id: _timePicker

            /*
              #FIXME: DatePicker does not respect the user's locale. The bug
              has been reported at http://pad.lv/1338138
            */

            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(-2)
            }

            clip: true
            mode: "Hours|Minutes"
        }

        SubtitledListItem {
            id: _alarmRepeat

            text: i18n.tr("Repeat")
            subText: alarmUtils.format_day_string(_alarm.daysOfWeek)
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmRepeat.qml"),
                                      {"alarm": _alarm})
        }

        SubtitledListItem {
            id: _alarmLabel

            text: i18n.tr("Label")
            subText: _alarm.message
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmLabel.qml"),
                                      {"alarm": _alarm})
        }

        SubtitledListItem {
            id: _alarmSound

            // Default Alarm Sound for new alarms
            property string _soundName: "Suru arpeggio"

            text: i18n.tr("Sound")
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmSound.qml"), {
                                          "alarmSound": _alarmSound,
                                          "alarm": _alarm,
                                          "_soundModel": soundModel
                                      })
        }
    }
}
