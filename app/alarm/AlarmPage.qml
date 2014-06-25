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
import "../components/Utils.js" as Utils

Page {
    title: "Alarms"

    flickable: null

    Component.onCompleted: Utils.log(debugMode, "Alarm Page loaded")

    AlarmList{
        id: listAlarm
        model: alarmModel
        anchors.fill: parent
    }

    tools: ToolbarItems {
        back: Button {
            action: Action {
                iconName: "back"
                onTriggered: {
                    mainStack.pop()
                }
            }
        }

        ToolbarButton {
            action: Action {
                iconName: "add"
                onTriggered: {
                    mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
                }
            }
        }
    }
}
