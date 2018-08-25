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
import Alarm 1.0
import "../timer"

Page {
    id: alarmPage
    objectName: 'AlarmPage'

    header: alarmListView.ViewItems.selectMode ? selectionHeader : standardHeader

    property var model: null
    property var pageStack: null
    readonly property bool isAlarmPage: true

    signal bottomEdgeClosed()

    Component.onCompleted: console.log("[LOG]: Alarm Page loaded")

    ActiveTimers {
        id: activeTimers
        alarmModel: alarmPage.model
    }

    PageHeader {
        id: standardHeader
        title: i18n.tr("Alarms")
        leadingActionBar.actions: [
            Action {
                objectName: "closeAlarmList"
                text: "close"
                iconName: "go-down"
                onTriggered: {
                    bottomEdgeClosed()
                }
            }
        ]
        trailingActionBar.actions: [
            Action {
                objectName: "addAlarmAction"
                iconName: "add"
                text: i18n.tr("Alarm")
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
                }
            }
        ]
    }

    PageHeader {
        id: selectionHeader
        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    alarmListView.ViewItems.selectMode = false
                }
            }
        ]

        trailingActionBar.actions: [
            Action {
                text: {
                    if(alarmListView.ViewItems.selectedIndices.length === alarmListView.count) {
                        return i18n.tr("Select None")
                    } else {
                        return i18n.tr("Select All")
                    }
                }

                iconName: {
                    if(alarmListView.ViewItems.selectedIndices.length === alarmListView.count) {
                        return "select-none"
                    } else {
                        return "select"
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

    SortedAlarmsModel {
        id:sortedAlarmsModel
        model: alarmPage.model
        sortOrder: Qt.AscendingOrder
        //Component.onCompleted: sortedAlarmsModel.sortOrder= Qt.AscendingOrder;
    }

    AlarmList {
        id: alarmListView
        model: sortedAlarmsModel
        anchors {
            top: alarmPage.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        localTime: {
            return new Date
                (
                    notLocalizedDateTimeString.split(":")[0],
                    notLocalizedDateTimeString.split(":")[1] - 1,
                    notLocalizedDateTimeString.split(":")[2],
                    notLocalizedDateTimeString.split(":")[3],
                    notLocalizedDateTimeString.split(":")[4],
                    notLocalizedDateTimeString.split(":")[5],
                    0
                )
        }
    }

    Loader {
        id: emptyStateLoader
        anchors {
            top: alarmPage.header.bottom
            topMargin: units.gu(5)
            left: parent.left
            right: parent.right
            margins: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
        active: alarmPage.model && (alarmPage.model.count === 0 || alarmPage.model.count === activeTimers.count()-1)
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
