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
            visible: type === Alarm.Repeating
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: alarmUtils.format_day_string(daysOfWeek, type)
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

        Connections {
            target: model
            onStatusChanged: {
                /*
                 Update switch value only when the alarm save() operation
                 is complete to avoid switching it back.
                */
                if (model.status === Alarm.Ready) {
                    alarmStatus.checked = model.enabled;
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
