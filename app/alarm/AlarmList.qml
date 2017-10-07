/*
 * Copyright (C) 2014-2016 Canonical Ltd
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

import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db

UbuntuListView {
    id: alarmListView
    objectName: "alarmListView"

    property var localTime
    property bool showAlarmFrequency: true

    signal clearSelection()
    signal closeSelection()
    signal selectAll()

    clip: true
    pressDelay: 75
    currentIndex: -1


    U1db.Index {
        id: active_timers_index
        database: clockDB
        expression: [
            "active_timers.message",
        ]
    }
    U1db.Query {
        id: dbActiveTimers
        index: active_timers_index
        query: ["*"]
    }

    Timer {
        id: alarmTimer
        running: alarmListView.visible && alarmModel.count !== 0
        interval: 5000
        repeat: true
        onTriggered: {
            showAlarmFrequency = !showAlarmFrequency
        }
    }

    function isAlarmATimerAlarm(alarmToCheck) {
        if(dbActiveTimers.results && alarmToCheck ){
            for(var i in dbActiveTimers.results) {
                if(alarmToCheck.message === dbActiveTimers.results[i].message) {
                    return true;
                }
            }
        }
        return false
    }

    displaced: Transition {
        UbuntuNumberAnimation { property: "y"; duration: UbuntuAnimation.BriskDuration }
    }

    delegate: AlarmDelegate {
        id: alarmDelegate
        objectName: "alarm" + index

        localTime: alarmListView.localTime
        showAlarmFrequency: alarmListView.showAlarmFrequency

        leadingActions: ListItemActions {
            actions: [
                Action {
                    id: deleteAction
                    objectName: "deleteAction"
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    onTriggered: {
                        var alarm = alarmModel.get(index)
                        alarm.cancel()
                    }
                }
            ]
        }

        visible: !isAlarmATimerAlarm(model)

        onClicked: {
            if (selectMode) {
                selected = !selected
            } else {
                mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"), {isNewAlarm: false, tempAlarm: model, alarmModel: alarmModel})
            }
        }

        onPressAndHold: {
            ListView.view.ViewItems.selectMode = !ListView.view.ViewItems.selectMode
        }
    }

    onClearSelection: {
        ViewItems.selectedIndices = []
    }

    onSelectAll: {
        var tmp = []

        for (var i=0; i < model.count; i++) {
            tmp.push(i)
        }

        ViewItems.selectedIndices = tmp
    }

    onCloseSelection: {
        clearSelection()
        ViewItems.selectMode = false
    }
}

