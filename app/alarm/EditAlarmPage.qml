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
import DateTime 1.0
import Clock.Utility 1.0
import Ubuntu.Components 1.2
import Qt.labs.folderlistmodel 2.1
import Ubuntu.Components.Pickers 1.0
import "../components"

Page {
    id: _addAlarmPage
    objectName: "AddAlarmPage"

    // Property to determine if this is a new/saved alarm
    property bool isNewAlarm: true

    // Temporary alarm used to read saved alarm and modify them
    property var tempAlarm

    title: isNewAlarm ? i18n.tr("New alarm") : i18n.tr("Edit alarm")
    visible: false

    head.actions: Action {
        id: saveAlarmButton
        iconName: "ok"
        objectName: "saveAlarmAction"
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

    Component.onCompleted: {
        if(!isNewAlarm) {
            readAlarm()
        }
    }

    // Function to save a new alarm
    function saveNewAlarm() {
        var alarmTime = new Date()
        alarmTime.setHours(_timePicker.hours, _timePicker.minutes, 0)

        validateDate(alarmTime)

        /*
          _alarm.sound, _alarm.daysOfWeek and _alarm.message have been set in
          the respective individual pages already.
        */
        _alarm.date = alarmTime
        _alarm.enabled = true
        _alarm.save()
    }

    // Function to read a saved alarm
    function readAlarm() {
        _alarm.message = tempAlarm.message
        _alarm.type = tempAlarm.type
        _alarm.daysOfWeek = tempAlarm.daysOfWeek
        _alarm.enabled = tempAlarm.enabled
        _alarm.date = tempAlarm.date
        _alarm.sound = tempAlarm.sound
    }

    // Function to delete a saved alarm
    function deleteAlarm() {
        tempAlarm.cancel()

        if(validateAlarm(tempAlarm)) {
            pageStack.pop()
        }
    }

    // Function to update a saved alarm
    function updateAlarm() {
        var alarmTime = new Date()
        alarmTime.setHours(_timePicker.hours, _timePicker.minutes, 0)

        validateDate(alarmTime)

        tempAlarm.message = _alarm.message
        tempAlarm.date = alarmTime
        tempAlarm.type = _alarm.type
        tempAlarm.enabled = true
        tempAlarm.sound = _alarm.sound
        tempAlarm.daysOfWeek = _alarm.daysOfWeek

        tempAlarm.save()

        if(validateAlarm(tempAlarm)) {
            pageStack.pop()
        }
    }

    // Function to validate if the alarm was saved properly
    function validateAlarm(alarmObject) {
        if (alarmObject.error !== Alarm.NoError) {
            console.log("[ERROR]: Error saving alarm, code: " + alarmObject.error)
            return false
        }
        else {
            return true
        }
    }

    function getSoundName(chosenSoundPath) {
        for(var i=0; i<defaultSoundModel.count; i++) {
            if(chosenSoundPath === Qt.resolvedUrl(defaultSoundModel.get(i, "filePath"))) {
                return defaultSoundModel.get(i, "fileBaseName")
            }
        }

        for(var j=0; j<customSoundModel.count; j++) {
            if(chosenSoundPath === Qt.resolvedUrl(customSoundModel.get(j, "filePath"))) {
                return customSoundModel.get(j, "fileBaseName")
            }
        }

        return ""
    }

    function getSoundPath(chosenSoundName) {
        for(var i=0; i<defaultSoundModel.count; i++) {
            if(chosenSoundName === defaultSoundModel.get(i, "fileBaseName")) {
                return defaultSoundModel.get(i, "filePath")
            }
        }

        for(var j=0; j<customSoundModel.count; j++) {
            if(chosenSoundName === customSoundModel.get(i, "fileBaseName")) {
                return customSoundModel.get(i, "filePath")
            }
        }
    }

    /*
     #TODO: The default alarm sound was changed to "Alarm clock" which only lands
     in OTA-6. This function is need to maintain backwards compatibility with
     OTA-5 users.
    */
    function fallbacktoOldDefaultAlarmSound() {
        _alarm.sound = getSoundPath("Suru arpeggio")
        _alarmSound.subText = "Suru arpeggio"
    }

    function setDefaultAlarmSound() {
        _alarm.sound = getSoundPath(_alarmSound.defaultAlarmSound)
        _alarmSound.subText = _alarmSound.defaultAlarmSound
    }

    function setAlarmSound() {
        if(isNewAlarm) {
            if (!getSoundPath(_alarmSound.defaultAlarmSound)) {
                fallbacktoOldDefaultAlarmSound()
            } else {
                setDefaultAlarmSound()
            }
        }
        else {
            _alarmSound.subText = getSoundName(_alarm.sound.toString())
            /*
             If the custom alarm sound of an alarm was deleted by the user,
             then fall back to the default alarm sound instead of showing an
             empty string.
            */
            if (_alarmSound.subText === "") {
                if (!getSoundPath(_alarmSound.defaultAlarmSound)) {
                    fallbacktoOldDefaultAlarmSound()
                } else {
                    setDefaultAlarmSound()
                }
            }
        }
    }

    function validateDate(date) {
        if (_alarm.type === Alarm.OneTime) {
            _alarm.daysOfWeek = Alarm.AutoDetect

            if (date < new Date()) {
                var tomorrow = new Date()
                tomorrow.setDate(tomorrow.getDate() + 1)
                _alarm.daysOfWeek = alarmUtils.get_alarm_day(tomorrow.getDay())
            }
        }
    }

    Alarm {
        id: _alarm

        Component.onCompleted: {
            /*
             Sets the alarm name manually to "Alarm" to ensure that it is
             translatable instead of using the default name set by the SDK
             Alarms API.
            */
            if (isNewAlarm) {
                _alarm.message = i18n.tr("Alarm")
            }
        }

        onErrorChanged: {
            if (error !== Alarm.NoError) {
                console.log("[LOG]: Error saving alarm, code: " + error)
            }
        }

        onStatusChanged: {
            if (status !== Alarm.Ready)
                return;
            if ((operation > Alarm.NoOperation) &&
                    (operation < Alarm.Reseting)) {
                pageStack.pop();
            }
        }

        onTypeChanged: {
            _alarmRepeat.subText = alarmUtils.format_day_string(_alarm.daysOfWeek, type)
        }

        onDaysOfWeekChanged: {
            _alarmRepeat.subText = alarmUtils.format_day_string(_alarm.daysOfWeek, type)
        }

        onDateChanged: {
            _timePicker.date = _alarm.date
        }
    }

    FolderListModel {
        id: defaultSoundModel

        showDirs: false
        nameFilters: [ "*.ogg", "*.mp3" ]
        folder: "/usr/share/sounds/ubuntu/ringtones"

        onCountChanged: {
            if(count > 0) {
                // When folder model is completely loaded set the alarm sound.
                if(!pageStack.currentPage.isAlarmSoundPage) {
                    setAlarmSound()
                }
            }
        }
    }

    FolderListModel {
        id: customSoundModel

        showDirs: false
        folder: customSound.alarmSoundDirectory

        onCountChanged: {
            if(count > 0) {
                // When folder model is completely loaded set the alarm sound.
                if(!pageStack.currentPage.isAlarmSoundPage) {
                    setAlarmSound()
                }
            }
        }
    }

    // Custom C++ Component that returns the clock app directory /home/phablet/.local/share/com.ubuntu.clock
    CustomAlarmSound {
        id: customSound
    }

    AlarmUtils {
        id: alarmUtils
    }

    Column {
        id: _alarmColumn

        width: parent.width
        anchors.top: parent.top

        DatePicker {
            id: _timePicker
            objectName: "alarmTime"

            /*
              #FIXME: DatePicker does not respect the user's locale. The bug
              has been reported at http://pad.lv/1338138
            */

            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(-2)
            }

            mode: "Hours|Minutes"
            date: {
                if(isNewAlarm) {
                    return new Date
                            (
                                currentTime.localDateString.split(":")[0],
                                currentTime.localDateString.split(":")[1] - 1,
                                currentTime.localDateString.split(":")[2],
                                currentTime.localTimeString.split(":")[0],
                                Math.ceil((parseInt(currentTime.localTimeString
                                                   .split(":")[1]) + 1) / 5) * 5,
                                0,
                                0
                                )
                }
            }

            DateTime {
                id: currentTime
                updateInterval: 0
            }
        }

        SubtitledListItem {
            id: _alarmRepeat
            objectName: "alarmRepeat"

            text: i18n.tr("Repeat")
            subText: alarmUtils.format_day_string(_alarm.daysOfWeek, _alarm.type)
            onClicked: pageStack.push(Qt.resolvedUrl("AlarmRepeat.qml"),
                                      {"alarm": _alarm, "alarmUtils": alarmUtils})
        }

        SubtitledListItem {
            id: _alarmLabel
            objectName: "alarmLabel"

            text: i18n.tr("Label")
            subText: _alarm.message
            onClicked: pageStack.push(Qt.resolvedUrl("AlarmLabel.qml"),
                                      {"alarm": _alarm})
        }

        SubtitledListItem {
            id: _alarmSound
            objectName: "alarmSound"

            // Default Alarm Sound for new alarms
            property string defaultAlarmSound: "Alarm clock"

            text: i18n.tr("Sound")
            onClicked: pageStack.push(Qt.resolvedUrl("AlarmSound.qml"), {
                                          "alarmSound": _alarmSound,
                                          "alarm": _alarm,
                                          "defaultSoundModel": defaultSoundModel,
                                          "customSoundModel": customSoundModel
                                      })
        }
    }

    Button {
        id: _deleteAlarmButton

        anchors {
            top: _alarmColumn.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }

        visible: !isNewAlarm

        color: "Red"
        text: i18n.tr("Delete alarm")

        onClicked: {
            _addAlarmPage.deleteAlarm()
        }
    }
}
