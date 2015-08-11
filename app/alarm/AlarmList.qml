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

import QtQuick 2.4
import Ubuntu.Components 1.2

UbuntuListView {
    id: alarmListView
    objectName: "alarmListView"

    property var localTime

    signal clearSelection()
    signal closeSelection()
    signal selectAll()

    clip: true
    anchors.fill: parent

    displaced: Transition {
        UbuntuNumberAnimation { property: "y"; duration: UbuntuAnimation.BriskDuration }
    }

    delegate: AlarmDelegate {
        id: alarmDelegate
        objectName: "alarm" + index

        localTime: alarmListView.localTime

        leadingActions: ListItemActions {
            actions: [
                Action {
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    onTriggered: {
                        var alarm = alarmModel.get(index)
                        alarm.cancel()
                    }
                }
            ]
        }

        onClicked: {
            if (selectMode) {
                selected = !selected
            } else {
                pageStack.push(Qt.resolvedUrl("EditAlarmPage.qml"), {isNewAlarm: false, tempAlarm: model})
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

