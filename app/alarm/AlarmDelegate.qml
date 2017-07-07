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

ListItem {
    id: root

    property var localTime
    property bool showAlarmFrequency
    property string alarmOccurrence: type === Alarm.Repeating ? alarmUtils.format_day_string(daysOfWeek, type)
                                                              : model.enabled ? alarmUtils.get_time_to_alarm(model.date, localTime)
                                                                              : ""

    onShowAlarmFrequencyChanged: {
        if (type === Alarm.Repeating && model.enabled) {
            animateTextChange()
        }
    }

    function animateTextChange() {
        textChangeAnimation.start()
    }

    height: mainLayout.height + divider.height

    SequentialAnimation {
        id: textChangeAnimation

        PropertyAnimation {
            target: mainLayout.summary
            property: "opacity"
            to: 0
            duration: UbuntuAnimation.BriskDuration
        }

        ScriptAction {
            script: alarmOccurrence = showAlarmFrequency ? alarmUtils.format_day_string(daysOfWeek, type)
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
        padding.trailing: units.gu(0)
        id: mainLayout

        title.text: Qt.formatTime(model.date) // Alarm time
        title.font.weight: Font.Normal
        title.objectName: "alarmTime"

        subtitle.text: message // Alarm name
        subtitle.textSize: Label.Medium
        subtitle.objectName: "alarmName"

        summary.text:  alarmOccurrence
        summary.textSize: Label.Medium
        summary.objectName: "alarmOccurrence"

        MouseArea {
            /**
              Provide a larger click area then the actual alaram status switch
             */
            width: units.gu(9)
            height: units.gu(9)

            preventStealing: true

            onClicked: {
                alarmStatus.checked = !alarmStatus.checked;
            }
            Switch {
                id: alarmStatus
                objectName: "listAlarmStatus"
                anchors.rightMargin: units.gu(1)
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                checked: model.enabled && (model.status === Alarm.Ready)
                onCheckedChanged: {
                    if (checked !== model.enabled) {
                        /*
                         Calculate the alarm time if it is a one-time alarm.
                         Repeating alarms do this automatically.
                        */
                        if(type === Alarm.OneTime) {
                            var date = new Date()
                            date.setHours(model.date.getHours(), model.date.getMinutes(), 0)

                            model.daysOfWeek = Alarm.AutoDetect
                            if (date < new Date()) {
                                var tomorrow = new Date()
                                tomorrow.setDate(tomorrow.getDate() + 1)
                                model.daysOfWeek = alarmUtils.get_alarm_day(tomorrow.getDay())
                            }
                            model.date = date

                        }
                        model.enabled = checked
                        model.save()
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

}
