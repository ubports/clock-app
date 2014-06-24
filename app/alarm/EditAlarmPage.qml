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

    // Property to store the total number of alarms in the model
    property int alarmCount

    title: i18n.tr("New Alarm")
    visible: false

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
            subText: i18n.tr("Alarm") + " #%1".arg(alarmCount + 1)
            onClicked: mainStack.push(Qt.resolvedUrl("AlarmLabel.qml"),
                                      {"alarmLabel": _alarmLabel})
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
                    saveNewAlarm()
                }
            }
        }
    }
}
