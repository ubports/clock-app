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
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../components/Utils.js" as Utils

Flickable {
    id: alarmListFlickable
    objectName: "alarmListFlickable"

    // Property to set the model of the saved alarm list
    property var model

    /*
      Property to set the minimum drag distance before activating the add
      alarm signal
    */
    property int _minThreshold: addAlarmButton.maxThreshold + units.gu(5)

    clip: true
    anchors.fill: parent
    contentHeight: alarmList.height

    AlarmUtils {
        id: alarmUtils
    }

    PullToAdd {
        id: addAlarmButton

        anchors {
            top: parent.top
            topMargin: -labelHeight - units.gu(6)
            horizontalCenter: parent.horizontalCenter
        }

        leftLabel: i18n.tr("Add")
        rightLabel: i18n.tr("Alarm")
    }

    Column {
        id: alarmList
        anchors.fill: parent

        Repeater {
            model: alarmListFlickable.model
            ListItem.Base {

                height: units.gu(7)

                Label {
                    id: alarmTime

                    anchors {
                        top: alarmDetailsColumn.top
                        left: parent.left
                        leftMargin: units.gu(0)
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

                        text: message
                        fontSize: "medium"
                        elide: Text.ElideRight
                        color: UbuntuColors.midAubergine
                    }

                    Label {
                        id: alarmSubtitle

                        fontSize: "xx-small"
                        width: parent.width
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: alarmUtils.format_day_string(daysOfWeek)
                    }
                }

                Switch {
                    id: alarmStatus

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

                removable: true
                confirmRemoval: true

                onItemRemoved: {
                    var alarm = alarmModel.get(index)
                    alarm.cancel()
                }

                onClicked: mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"),
                                          {"isNewAlarm": false,
                                              "alarmIndex": index})
            }
        }
    }

    onDragEnded: {
        if(contentY < _minThreshold)
            mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
    }

    onContentYChanged: {
        if(contentY < 0 && atYBeginning) {
            addAlarmButton.dragPosition = contentY.toFixed(0)
        }
    }
}

