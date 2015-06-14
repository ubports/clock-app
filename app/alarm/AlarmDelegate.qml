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

import QtQuick 2.3
import Ubuntu.Components 1.1
import "../upstreamcomponents"

ListItemWithActions {
    id: root

    property var localTime

    width: parent ? parent.width : 0
    height: units.gu(6)
    color: "Transparent"
    selectedColor: "Transparent"

    Label {
        id: alarmTime
        objectName: "listAlarmTime" + index

        anchors {
            top: alarmDetailsColumn.top
            left: parent.left
        }

        fontSize: "medium"
        text: Qt.formatTime(date)
        opacity: model.enabled ? 1.0 : 0.8
    }

    Column {
        id: alarmDetailsColumn

        opacity: model.enabled ? 1.0 : 0.8

        anchors {
            left: alarmTime.right
            right: alarmStatus.left
            verticalCenter: parent.verticalCenter
            margins: units.gu(1)
        }

        Label {
            id: alarmLabel
            objectName: "listAlarmLabel" + index

            text: message
            fontSize: "medium"
            width: parent.width
            elide: Text.ElideRight
            color: UbuntuColors.midAubergine
        }

        Label {
            id: alarmSubtitle
            objectName: "listAlarmSubtitle" + index

            fontSize: "xx-small"
            width: parent.width
            visible: !(type === Alarm.OneTime && !model.enabled)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: type === Alarm.Repeating ? alarmUtils.format_day_string(daysOfWeek, type)
                                           : model.enabled ? alarmUtils.get_time_to_next_alarm(model.date - localTime)
                                                           : "Alarm Disabled"
        }
    }

    Switch {
        id: alarmStatus
        objectName: "listAlarmStatus" + index

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        onCheckedChanged: {
            if (checked !== model.enabled) {
                var alarmData = model
                alarmData.enabled = checked

                /*
                 Calculate the new alarm time if it is a one-time alarm and has
                 gone-off and the user is re-enabling the alarm. Repeating
                 alarms do this automatically.
                */
                if(checked && type === Alarm.OneTime) {
                    var currentTime = new Date()
                    alarmData.daysOfWeek = Alarm.AutoDetect
                    var now=new Date()
                    if (alarmData.date.getHours()*60+alarmData.date.getMinutes() <= currentTime.getHours()*60+currentTime.getMinutes()) {
                        alarmData.date = new Date(now.getFullYear(),now.getMonth(),now.getDate()+1,alarmData.date.getHours(),alarmData.date.getMinutes(),0,0)
                    } else {
                        alarmData.date = new Date(now.getFullYear(),now.getMonth(),now.getDate(),alarmData.date.getHours(),alarmData.date.getMinutes(),0,0)
                    }
                }

                alarmData.save()
            }
        }

        Component {
            id: _internalTimerComponent
            Timer {
                running: false
                interval: 5000
                repeat: false
                onTriggered: {
                    alarmSubtitle.text = alarmUtils.format_day_string(daysOfWeek)
                    _internalTimerLoader.sourceComponent = undefined
                }
            }
        }

        Loader {
            id: _internalTimerLoader
            asynchronous: true

            onStatusChanged: {
                if(status === Loader.Ready) {
                    _internalTimerLoader.item.restart()
                }
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

                    if(alarmStatus.checked && type === Alarm.Repeating) {
                        alarmSubtitle.text = alarmUtils.get_time_to_next_alarm(model.date - localTime)
                        _internalTimerLoader.sourceComponent = _internalTimerComponent
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
