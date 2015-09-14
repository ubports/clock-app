/*
 * Copyright (C) 2014-2015 Canonical Ltd
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

Page {
    id: alarmPage

    readonly property bool isAlarmPage: true

    title: i18n.tr("Alarms")
    objectName: 'AlarmPage'
    flickable: null

    Component.onCompleted: console.log("[LOG]: Alarm Page loaded")

    states: [
        PageHeadState {
            name: "default"
            head: alarmPage.head
            when: !alarmListView.ViewItems.selectMode

            backAction: Action {
                iconName: "down"
                text: i18n.tr("Back")
                onTriggered: {
                    pageStack.pop()
                }
            }

            actions: [
                Action {
                    objectName: "addAlarmAction"
                    iconName: "add"
                    text: i18n.tr("Alarm")
                    onTriggered: {
                        pageStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
                    }
                }
            ]
        },

        PageHeadState {
            name: "selection"
            head: alarmPage.head
            when: alarmListView.ViewItems.selectMode

            backAction: Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    alarmListView.ViewItems.selectMode = false
                }
            }

            actions: [
                Action {
                    text: {
                        if(alarmListView.ViewItems.selectedIndices.length === alarmListView.count) {
                            return i18n.tr("Select None")
                        } else {
                            return i18n.tr("Select All")
                        }
                    }

                    iconSource: {
                        if(alarmListView.ViewItems.selectedIndices.length === alarmListView.count) {
                            return Qt.resolvedUrl("../graphics/select-none.svg")
                        } else {
                            return Qt.resolvedUrl("../graphics/select.svg")
                        }
                    }

                    onTriggered: {
                        if(alarmListView.ViewItems.selectedIndices.length === alarmListView.count) {
                            alarmListView.clearSelection()
                        } else {
                            alarmListView.selectAll()
                        }
                    }
                },

                Action {
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    enabled: alarmListView.ViewItems.selectedIndices.length !== 0

                    onTriggered: {
                        var items = alarmListView.ViewItems.selectedIndices

                        for(var i=0; i < alarmListView.ViewItems.selectedIndices.length; i++) {
                            var alarm = alarmModel.get(alarmListView.ViewItems.selectedIndices[i])
                            alarm.cancel()
                        }

                        alarmListView.closeSelection()
                    }
                }
            ]
        }
    ]

    AlarmList {
        id: alarmListView
        model: alarmModel
        anchors.fill: parent
        localTime: new Date //FIXME clockTimeInMain
    }

    Loader {
        id: emptyStateLoader
        anchors {
            top: parent.top
            topMargin: units.gu(5)
            left: parent.left
            right: parent.right
            margins: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
        active: alarmModel ? alarmModel.count === 0 : true
        Component.onCompleted: {
            setSource(Qt.resolvedUrl("../components/EmptyState.qml"),
                      {
                          "iconName": "alarm-clock",
                          "title": i18n.tr("No saved alarms"),
                          "subTitle": i18n.tr("Tap the + icon to add an alarm")
                      })
        }
    }
}
