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
import "../components"

Page {
    id: alarmPage

    title: i18n.tr("Alarms")
    objectName: 'AlarmPage'

    Component.onCompleted: console.log("[LOG]: Alarm Page loaded")

    flickable: null

    states: [
        PageHeadState {
            name: "default"
            head: alarmPage.head
            when: !alarmListView.isInSelectionMode

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
            when: alarmListView.isInSelectionMode

            backAction: Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    alarmListView.cancelSelection()
                }
            }

            contents: Loader {
                id: selectionStateLoader
                active: alarmPage.state === "selection"
                sourceComponent: selectionStateComponent
                height: parent ? parent.height : undefined
                anchors.right: parent ? parent.right: undefined
            }
        }
    ]

    Component {
        id: selectionStateComponent
        Item {
            HeaderButton {
                id: selectButton

                anchors {
                    right: deleteButton.left
                    rightMargin: units.gu(1)
                }

                text: {
                    if(alarmListView.selectedItems.count === alarmListView.count) {
                        return i18n.tr("Select None")
                    } else {
                        return i18n.tr("Select All")
                    }
                }

                iconSource: {
                    if(alarmListView.selectedItems.count === alarmListView.count) {
                        return Qt.resolvedUrl("../graphics/select-none.svg")
                    } else {
                        return Qt.resolvedUrl("../graphics/select.svg")
                    }
                }

                onTriggered: {
                    if(alarmListView.selectedItems.count === alarmListView.count) {
                        alarmListView.clearSelection()
                    } else {
                        alarmListView.selectAll()
                    }
                }
            }

            HeaderButton {
                id: deleteButton

                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)

                iconName: "delete"
                text: i18n.tr("Delete")
                enabled: alarmListView.selectedItems.count !== 0

                onTriggered: {
                    var items = alarmListView.selectedItems

                    for(var i=0; i < items.count; i++) {
                        var alarm = alarmModel.get(items.get(i).itemsIndex)
                        alarm.cancel()
                    }

                    alarmListView.endSelection()
                }
            }
        }
    }

    AlarmList {
        id: alarmListView
        listModel: alarmModel
        anchors.fill: parent
        localTime: clockTime
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
