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
import Ubuntu.Components 1.2

ListItem {
    id: root

    property var localTime
    property bool showAlarmFrequency

    width: parent ? parent.width : 0
    height: units.gu(9)
    divider.visible: true

    onShowAlarmFrequencyChanged: {
        if (type === Alarm.Repeating && model.enabled) {
            alarmSubtitle.animateTextChange()
        }
    }

    Column {
        id: alarmDetailsColumn

        spacing: units.gu(1)
        opacity: model.enabled ? 1.0 : 0.8

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            right: alarmStatus.left
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: alarmTime
            objectName: "listAlarmTime" + index

            color: UbuntuColors.midAubergine
            fontSize: "x-large"
            text: Qt.formatTime(date)
        }

        RowLayout {
            width: parent.width
            spacing: units.gu(1)

            Label {
                id: alarmLabel
                objectName: "listAlarmLabel" + index

                text: message
                fontSize: "small"
                elide: Text.ElideRight
                Layout.maximumWidth: parent.width > alarmLabel.contentWidth + alarmSubtitle.contentWidth ? (parent.width - alarmSubtitle.contentWidth - units.gu(4))
                                                                                                         : contentWidth
            }

            Label {
                text: "|"
                visible: alarmSubtitle.visible
            }

            Label {
                id: alarmSubtitle
                objectName: "listAlarmSubtitle" + index

                fontSize: "small"
                Layout.fillWidth: true
                visible: !(type === Alarm.OneTime && !model.enabled)
                elide: Text.ElideRight
                text: type === Alarm.Repeating ? alarmUtils.format_day_string(daysOfWeek, type)
                                               : model.enabled ? alarmUtils.get_time_to_next_alarm(model.date - localTime)
                                                               : "Alarm Disabled"

                function animateTextChange() {
                    textChangeAnimation.start()
                }


                SequentialAnimation {
                    id: textChangeAnimation
                    PropertyAnimation {
                        target: alarmSubtitle
                        property: "opacity"
                        to: 0
                        duration: UbuntuAnimation.BriskDuration
                    }

                    ScriptAction {
                        script: alarmSubtitle.text = showAlarmFrequency ? alarmUtils.format_day_string(daysOfWeek, type)
                                                                        : alarmUtils.get_time_to_next_alarm(model.date - localTime)
                    }

                    PropertyAnimation {
                        target: alarmSubtitle
                        property: "opacity"
                        to: 1.0
                        duration: UbuntuAnimation.BriskDuration
                    }
                }
            }
        }
    }

    Switch {
        id: alarmStatus
        objectName: "listAlarmStatus" + index

        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }

        onCheckedChanged: {
            if (checked !== model.enabled) {
                var alarmData = model
                alarmData.enabled = checked

                /*
                 Calculate the alarm time if it is a one-time alarm.
                 It is important to keep the alarm list in order of occurrence (also for disabled alarms).
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
                        alarmSubtitle.text = alarmUtils.format_day_string(daysOfWeek, type)
                    }
                }
            }
        }

        /*
         Assign switch value only once at startup. After this, the switch will
         be updated after the alarm save() operations only.
        */
        Component.onCompleted: alarmStatus.checked = model.enabled
    }
}
