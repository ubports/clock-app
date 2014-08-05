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
import "../components/Utils.js" as Utils

Page {
    title: "Alarms"
    objectName: 'AlarmPage'

    flickable: null

    head.actions: Action {
        objectName: "addAlarmAction"
        iconName: "add"
        text: i18n.tr("Alarm")
        onTriggered: {
            mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
        }
    }

    Component.onCompleted: Utils.log(debugMode, "Alarm Page loaded")

    AlarmList{
        id: listAlarm
        model: alarmModel
        anchors.fill: parent
    }
}
