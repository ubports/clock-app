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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

ListItem {
    id: root

    property var localTime
    property bool showAlarmFrequency
    property string  alarmOccurrence: type === Alarm.Repeating ? alarmUtils.format_day_string(daysOfWeek, type)
                                                            : model.enabled ? alarmUtils.get_time_to_alarm(model.date, localTime)
                                                                            : "Alarm Disabled"

    height: mainLayout.height + divider.height

    onShowAlarmFrequencyChanged: {
        if (type === Alarm.Repeating && model.enabled) {
            animateTextChange()
        }
    }

    function animateTextChange() {
        textChangeAnimation.start()
    }

    SequentialAnimation {
        id: textChangeAnimation
        PropertyAnimation {
            target: mainLayout.summary
            property: "opacity"
            to: 0
            duration: UbuntuAnimation.BriskDuration
        }
        ScriptAction {
            script:  alarmOccurrence = showAlarmFrequency ? alarmUtils.format_day_string(daysOfWeek, type)
                                                       : alarmUtils.get_time_to_alarm(model.date, localTime)
        }
        PropertyAnimation {
            target: mainLayout.summary
            property: "opacity"
            to: 1.0
            duration: UbuntuAnimation.BriskDuration
        }
    }

    ListItemLayout {
        id: mainLayout

        title.text: Qt.formatTime(date) // Alarm time
        subtitle.text: message // Alarm name
        summary.text:  alarmOccurrence

        Switch {
            id: alarmStatus

            anchors.verticalCenter: parent.verticalCenter
            SlotsLayout.position: SlotsLayout.Trailing
            SlotsLayout.overrideVerticalPositioning: true
            checked: model.enabled
            onCheckedChanged: {
                if (checked !== model.enabled) {
                    var alarmData = model
                    alarmData.enabled = checked

                    /*
                     Calculate the alarm time if it is a one-time alarm.
                     Repeating alarms do this automatically.
                    */
                    if(type === Alarm.OneTime) {
                        alarmData.daysOfWeek = Alarm.AutoDetect
                        var now = new Date()
                        if (alarmData.date.getHours()*60+alarmData.date.getMinutes() <= now.getHours()*60+now.getMinutes()) {
                            alarmData.date = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, alarmData.date.getHours(), alarmData.date.getMinutes(), 0, 0)
                        } else {
                            alarmData.date = new Date(now.getFullYear(), now.getMonth(), now.getDate(), alarmData.date.getHours(), alarmData.date.getMinutes(), 0, 0)
                        }
                    }

                    alarmData.save()
                }
            }

            Connections {
                target: model
                onStatusChanged: {
                    /*
                                 Update switch value only when the alarm save() operation
                                 is complete to avoid switching it back.
                                */
                    if (model.status === Alarm.Ready) {
                        alarmStatus.checked = model.enabled;

                        if (!alarmStatus.checked && type === Alarm.Repeating) {
                             alarmOccurrence = alarmUtils.format_day_string(daysOfWeek, type)
                        }
                    }
                }
            }
        }
    }
}
