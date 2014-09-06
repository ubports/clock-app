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
import "../components/Utils.js" as Utils

Page {
    id: alarmPage

    title: i18n.tr("Alarms")
    objectName: 'AlarmPage'

    Component.onCompleted: Utils.log(debugMode, "Alarm Page loaded")

    flickable: null

    states: [
        PageHeadState {
            name: "default"
            head: alarmPage.head
            when: !alarmListView.isInSelectionMode
            actions: [
                Action {
                    objectName: "addAlarmAction"
                    iconName: "add"
                    text: i18n.tr("Alarm")
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
                    }
                }
            ]
        },

        PageHeadState {
            name: "selection"
            head: alarmPage.head
            when: alarmListView.isInSelectionMode
            backAction: Action {
                text: i18n.tr("Cancel selection")
                iconName: "close"
                onTriggered: {
                    alarmListView.cancelSelection()
                }
            }

            actions: [
                Action {
                    text: i18n.tr("Select All")
                    iconName: "select"
                    onTriggered: {
                        if(alarmListView.selectedItems.count
                                === alarmListView.count) {
                            alarmListView.clearSelection()
                        }
                        else {
                            alarmListView.selectAll()
                        }
                    }
                },

                Action {
                    text: i18n.tr("Delete")
                    iconName: "delete"
                    onTriggered: {
                        var items = alarmListView.selectedItems

                        for(var i=0; i < items.count; i++) {
                            var alarm = alarmModel.get(items.get(i).itemsIndex)
                            alarm.cancel()
                        }

                        alarmListView.endSelection()
                    }
                }
            ]

            contents: Label {
                text: ""
            }
        }
    ]

    AlarmList {
        id: alarmListView
        listModel: alarmModel
        anchors.fill: parent
    }

    Item {
        visible: alarmModel.count === 0
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: childrenRect.height

        Icon {
            id: noAlarmIcon
            name: "alarm-clock"
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(10)
            width: height
            color: UbuntuColors.warmGrey
        }

        Label {
            id: noAlarmLabel
            text: i18n.tr("No saved alarms")
            anchors.top: noAlarmIcon.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: "x-large"
			font.bold: true
        }

        Label {
            text: i18n.tr("Tap the plus icon to add an alarm.")
            anchors.top: noAlarmLabel.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: "large"
        }
    }
}
