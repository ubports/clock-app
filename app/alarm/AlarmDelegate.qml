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
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: alarmUtils.format_day_string(daysOfWeek)
        }
    }

    Switch {
        id: alarmStatus
        objectName: "listAlarmStatus" + index

        property bool tempStatus: false

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        checked: enabled

        Timer {
            id: waitTimer
            interval: 5000
            repeat: false
            onTriggered: {
                console.log("binding to alarm status")
                alarmStatus.checked = Qt.binding(function() { return enabled })
            }
        }

        onClicked: {
            console.log("Binding to temp variable.")
            checked = Qt.binding(function() { return tempStatus })

            waitTimer.restart()

            var _tempAlarm = alarmModel.get(index)
            _tempAlarm.enabled = checked
            _tempAlarm.save()
        }
    }
}
