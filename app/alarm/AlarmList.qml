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
        anchors { left: parent.left; right: parent.right }
        height: 2 * units.gu(6)
        currentIndex: -1

        delegate: ListItem.Base {
            objectName: "alarm" + index
            height: alarmTimeContainer.height + units.gu(2)

            Column {
                id: alarmDetailsColumn
                anchors {
                    left: parent.left
                    right: alarmTimeContainer.left
                    verticalCenter: alarmTimeContainer.verticalCenter
                    leftMargin: units.gu(1)
                    rightMargin: units.gu(2)
                }

                Label {
                    id: alarmLabel
                    objectName: "listAlarmLabel" + index
                    fontSize: "large";
                    text: message
                    elide: Text.ElideRight
                    color: Theme.palette.normal.baseText
                }

                Label {
                    id: alarmSubtitle
                    objectName: "listAlarmSubtitle" + index
                    fontSize: "small";
                    text: alarmUtils.format_day_string(daysOfWeek, type)
                    color: Theme.palette.normal.backgroundText
                }
            }

            UbuntuShape {
                id: alarmTimeContainer
                radius: "medium"
                width: units.gu(12)
                height: alarmTime.contentHeight + units.gu(2)
                color: model.enabled ? "#37C837" : Qt.rgba(0,0,0,0.3)
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: units.gu(1)
                }

                Label {
                    id: alarmTime
                    objectName: "listAlarmTime" + index
                    fontSize: "large";
                    anchors.centerIn: parent
                    color: model.enabled ? Theme.palette.normal.baseText : Qt.rgba(1,1,1,0.3)
                    text: alarmUtils.convertTime(date.getHours(), date.getMinutes(), 0, "12-hour")
                }
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
