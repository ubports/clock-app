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
import Ubuntu.Components.ListItems 1.0 as ListItem

Column {
    id: listAlarm

    // Property to set the model of the saved alarm list
    property alias model: listSavedAlarm.model

    AlarmUtils {
        id: alarmUtils
    }

    ListView {
        id: listSavedAlarm
        objectName: "listSavedAlarm"

        clip: true
        height: parent.height
        anchors.left: parent.left
        anchors.right: parent.right

        currentIndex: -1

        delegate: ListItem.Base {
            objectName: "alarm" + index

            Label {
                id: alarmTime
                objectName: "listAlarmTime" + index

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: units.gu(0)

                fontSize: "medium"
                text: alarmUtils.convertTime(date.getHours(), date.getMinutes(), 0, "24-hour")
            }

            Column {
                id: alarmDetailsColumn

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
                    elide: Text.ElideRight
                    color: UbuntuColors.midAubergine
                }

                Label {
                    id: alarmSubtitle
                    objectName: "listAlarmSubtitle" + index

                    fontSize: "xx-small"
                    text: alarmUtils.format_day_string(daysOfWeek, type)
                }
            }

            Switch {
                id: alarmStatus

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                enabled: model.enabled
            }

            selected: listSavedAlarm.currentIndex == index
            removable: true
            confirmRemoval: true

            onItemRemoved: {
                var alarm = alarmModel.get(index)
                alarm.cancel()
            }
        }
    }
}
