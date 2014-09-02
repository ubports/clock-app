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
import Ubuntu.Components 1.1
import "../upstreamcomponents"

ListItemWithActions {
    id: root

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
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: alarmUtils.format_day_string(daysOfWeek)
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
                model.enabled = checked
                model.save()
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

                    if(alarmStatus.checked) {
                        var timeObject = alarmUtils.get_time_to_next_alarm(model.date - new Date())
                        var alarmETA

                        // TRANSLATORS: the first argument is the number of days,
                        // followed by hour and minute
                        if(timeObject.days) {
                            alarmETA = i18n.tr("in %1d %1h %2m")
                            .arg(timeObject.days)
                            .arg(timeObject.hours)
                            .arg(timeObject.minutes)
                        }

                        // TRANSLATORS: the first argument is the number of
                        // hours followed by the minutes
                        else {
                            alarmETA = i18n.tr("in %1h %2m")
                            .arg(timeObject.hours)
                            .arg(timeObject.minutes)
                        }

                        alarmSubtitle.text = alarmETA
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
