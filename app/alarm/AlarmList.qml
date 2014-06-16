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

                fontSize: "large"
                color: model.enabled ? Theme.palette.normal.baseText : Qt.rgba(1,1,1,0.3)
                text: alarmUtils.convertTime(date.getHours(), date.getMinutes(), 0, "24-hour")
            }

            Column {
                id: alarmDetailsColumn
                anchors {
                    left: alarmTime.right
                    right: alarmStatus.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }

                Label {
                    id: alarmLabel
                    objectName: "listAlarmLabel" + index
                    fontSize: "large";
                    text: message
                    elide: Text.ElideRight
                    color: UbuntuColors.midAubergine
                }

                Label {
                    id: alarmSubtitle
                    objectName: "listAlarmSubtitle" + index
                    fontSize: "small";
                    text: alarmUtils.format_day_string(daysOfWeek, type)
                    color: Theme.palette.normal.backgroundText
                }
            }

            Switch {
                id: alarmStatus
                enabled: model.enabled
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
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
