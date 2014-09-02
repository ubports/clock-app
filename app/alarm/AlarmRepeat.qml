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
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: _alarmRepeatPage
    objectName: "alarmRepeatPage"

    // Property to set the alarm days of the week in the edit alarm page
    property var alarm

    visible: false
    title: i18n.tr("Repeat")

    head.actions: [
        Action {
            text: i18n.tr("Select All")
            iconName: "select"
            onTriggered: {
                if (alarm.daysOfWeek !== 127) {
                    for (var i=0; i<_alarmDays.count; i++) {
                        _alarmDays.itemAt(i).isChecked = true
                    }
                }

                else {
                    for (var i=0; i<_alarmDays.count; i++) {
                        _alarmDays.itemAt(i).isChecked = false
                    }
                }
            }
        }
    ]

    ListModel {
        id: daysModel

        ListElement {
            day: "1"
            flag: Alarm.Monday
        }

        ListElement {
            day: "2"
            flag: Alarm.Tuesday
        }

        ListElement {
            day: "3"
            flag: Alarm.Wednesday
        }

        ListElement {
            day: "4"
            flag: Alarm.Thursday
        }

        ListElement {
            day: "5"
            flag: Alarm.Friday
        }

        ListElement {
            day: "6"
            flag: Alarm.Saturday
        }

        ListElement {
            day: "0"
            flag: Alarm.Sunday
        }
    }

    Column {
        id: _alarmDayColumn

        anchors.fill: parent

        Repeater {
            id: _alarmDays
            objectName: 'alarmDays'

            model: daysModel

            ListItem.Standard {
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
                    text: Qt.locale().standaloneDayName(day, Locale.LongFormat)
                }

                control: CheckBox {
                    id: daySwitch
                    objectName: 'daySwitch' + index
                    checked: (alarm.daysOfWeek & flag) == flag
                    onCheckedChanged: {
                        if (checked) {
                            alarm.daysOfWeek |= flag
                        }

                        else {
                            alarm.daysOfWeek &= ~flag
                        }
                    }
                }
            }
        }
    }
}
