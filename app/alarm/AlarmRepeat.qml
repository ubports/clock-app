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
    id: _alarmRepeatPage
    objectName: "alarmRepeatPage"

    // Property to set the alarm days of the week in the edit alarm page
    property var alarm

    // Property to hold the alarm utils functions passed from edit alarm page
    property var alarmUtils

    // Property to store the previously set alarm frequency to detect user changes
    property int oldAlarmDaysOfWeek

    visible: false
    title: i18n.tr("Repeat")

    // Function to detect if alarm is OneTime or Repeating
    function detectAlarmType() {
        if (alarm.daysOfWeek > 0) {
            alarm.type = Alarm.Repeating
        } else {
            alarm.type = Alarm.OneTime
        }
    }

    head.backAction: Action {
        iconName: "back"
        onTriggered: {
            // Restore alarm frequency and type if user presses the back button
            alarm.daysOfWeek = oldAlarmDaysOfWeek
            detectAlarmType()
            pop()
        }
    }

    head.actions: [
        Action {
            text: i18n.tr("Select All")

            iconSource: {
                if(alarm.daysOfWeek === 127)
                    return Qt.resolvedUrl("../graphics/select-none.svg")
                else
                    return Qt.resolvedUrl("../graphics/select.svg")
            }

            onTriggered: {
                if (alarm.daysOfWeek === 127) {
                    for (var i=0; i<_alarmDays.count; i++) {
                        _alarmDays.itemAt(i).isChecked = false
                    }
                }

                else {
                    for (var i=0; i<_alarmDays.count; i++) {
                        _alarmDays.itemAt(i).isChecked = true
                    }
                }
            }
        },

        Action {
            id: saveAction
            objectName: "saveAction"
            iconName: "tick"
            enabled: oldAlarmDaysOfWeek !== alarm.daysOfWeek
            onTriggered: {
                pop()
            }
        }
    ]

    /*
     By Default, the alarm is set to Today. However if it is a one-time alarm,
     this should be set to none, since this page shows the days the alarm
     repeats on and a one-time alarm shoudn't repeat on any day. While exiting
     the page, if the alarm is still a one-time alarm, then the alarm is set
     back to its original value (Today).
    */
    Component.onCompleted: {
        if (alarm.type === Alarm.OneTime)
            alarm.daysOfWeek = 0

        // Record the current alarm repeat values (frequency)
        oldAlarmDaysOfWeek = alarm.daysOfWeek
    }

    Component.onDestruction: {
        if (alarm.type === Alarm.OneTime)
            alarm.daysOfWeek = Alarm.AutoDetect
    }

    ListModel {
        id: daysModel
        Component.onCompleted: initialise()

        // Function to generate the days of the week based on the user locale
        function initialise() {
            // Get the first day of the week based on the user locale
            var j = Qt.locale().firstDayOfWeek

            // Set first item on the list to be the first day of the week
            daysModel.append({ "day": Qt.locale().standaloneDayName(j, Locale.LongFormat),
                                 "flag": alarmUtils.get_alarm_day(j) })

            // Retrieve the rest of the alarms days of the week
            for (var i=1; i<=6; i++) {
                daysModel.append({ "day": Qt.locale().standaloneDayName((j+i)%7, Locale.LongFormat),
                                     "flag": alarmUtils.get_alarm_day((j+i)%7) })
            }
        }
    }

    Column {
        id: _alarmDayColumn

        anchors.fill: parent

        Repeater {
            id: _alarmDays
            objectName: 'alarmDays'

            model: daysModel

            ListItem {
                id: _alarmDayHolder
                objectName: "alarmDayHolder" + index

                property alias isChecked: daySwitch.checked

                Label {
                    id: _alarmDay
                    objectName: 'alarmDay' + index

                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }

                    color: UbuntuColors.midAubergine
                    text: day
                }

                CheckBox {
                    id: daySwitch
                    objectName: 'daySwitch' + index

                    anchors {
                        right: parent.right
                        rightMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }

                    checked: (alarm.daysOfWeek & flag) == flag
                             && alarm.type === Alarm.Repeating
                    onCheckedChanged: {
                        if (checked) {
                            alarm.daysOfWeek |= flag
                        } else {
                            alarm.daysOfWeek &= ~flag
                        }

                        detectAlarmType()
                    }
                }

                onClicked: {
                    daySwitch.checked = !daySwitch.checked
                }
            }
        }
    }
}
