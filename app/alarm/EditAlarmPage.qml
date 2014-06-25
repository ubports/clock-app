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

    Component.onCompleted: {
        if(!isNewAlarm) {
            readAlarm()
        }
    }

    // Function to save a new alarm
    function saveNewAlarm() {
        var alarmTime = new Date()
        alarmTime.setHours(_timePicker.hours, _timePicker.minutes, 0)

        _alarm.message = _alarmLabel.subText
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

        /*
          #FIXME: Sometimes the clock app crashes due to this code. Cause not
          known yet!
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

    AlarmUtils {
        id: alarmUtils
    }

    Column {
        id: _alarmColumn

        anchors.fill: parent

        DatePicker {
            id: _timePicker

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(-2)

            clip: true
            mode: "Hours|Minutes"
        }

        SubtitledListItem {
            id: _alarmRepeat

            text: "Repeat"
            subText: alarmUtils.format_day_string(_alarm.daysOfWeek)
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmRepeat.qml"),
                                      {"alarm": _alarm})
        }

        SubtitledListItem {
            id: _alarmLabel

            text: "Label"
            subText: _alarm.message
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmLabel.qml"),
                                      {"alarm": _alarm})
        }

        SubtitledListItem {
            id: _alarmSound
            /*
              #TODO: Add support for choosing new alarm sound when indicator-
              datetime supports custom alarm sounds
            */
            text: "Sound (disabled)"
            subText: "Suru arpeggio"
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmSound.qml"),
                                      {"alarmSound": _alarmSound})
        }
    }

    tools: ToolbarItems {
        back: Button {
            action: Action {
                iconName: "close"
                onTriggered: {
                    mainStack.pop()
                }
            }
        }

        ToolbarButton {
            action: Action {
                iconName: "save"
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
    }
}
