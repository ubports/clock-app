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

import QtQuick 2.0
import Ubuntu.Components 1.1
import "../upstreamcomponents"

ListItemWithActions {
    id: root

    property bool isCurrentItem: false

    height: units.gu(6)
    width: parent ? parent.width : 0
    color: "Transparent"

    Item {
        id: delegate

        anchors.fill: parent

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

            checked: enabled

            /*
             #TODO: Add the ability to enable/disable alarms using the
             switch. At the moment it only shows the alarm status.
             This was postponed since a similar implementation in the
             old clock app caused it to loop. So if user clicks on the
             switch, it disables and then re-enables the alarm again.
            */
        }
    }
}
