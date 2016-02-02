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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

ListItem {
    id: root

    property var localTime
    property bool showAlarmFrequency

    width: parent ? parent.width : 0
    height: units.gu(9)
    divider.visible: true

    onShowAlarmFrequencyChanged: {
        if (type === Alarm.Repeating && model.enabled) {
            alarmSubtitle.animateTextChange()
        }
    }

    Column {
        id: alarmDetailsColumn

        spacing: units.gu(1)
        opacity: model.enabled ? 1.0 : 0.8

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            right: alarmStatus.left
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: alarmTime
            objectName: "listAlarmTime" + index

            color: UbuntuColors.midAubergine
            fontSize: "x-large"
            text: Qt.formatTime(model.date)
        }

        RowLayout {
            width: parent.width
            spacing: units.gu(1)

            Label {
                id: alarmLabel
                objectName: "listAlarmLabel" + index

                text: message
                fontSize: "small"
                elide: Text.ElideRight
                Layout.maximumWidth: parent.width > alarmLabel.contentWidth + alarmSubtitle.contentWidth ? (parent.width - alarmSubtitle.contentWidth - units.gu(4))
                                                                                                         : contentWidth
            }

            Label {
                text: "|"
                visible: alarmSubtitle.visible
            }

            Label {
                id: alarmSubtitle
                objectName: "listAlarmSubtitle" + index

                fontSize: "small"
                Layout.fillWidth: true
                visible: ((type === Alarm.Repeating) || model.enabled) && (model.status === Alarm.Ready)
                elide: Text.ElideRight
                text: type === Alarm.Repeating ? alarmUtils.format_day_string(daysOfWeek, type) :
                                                 alarmUtils.get_time_to_alarm(model.date, localTime)

                function animateTextChange() {
                    textChangeAnimation.start()
                }


                SequentialAnimation {
                    id: textChangeAnimation
                    PropertyAnimation {
                        target: alarmSubtitle
                        property: "opacity"
                        to: 0
                        duration: UbuntuAnimation.BriskDuration
                    }

                    ScriptAction {
                        script: alarmSubtitle.text = showAlarmFrequency ? alarmUtils.format_day_string(daysOfWeek, type)
                                                                        : alarmUtils.get_time_to_alarm(model.date, localTime)
                    }

                    PropertyAnimation {
                        target: alarmSubtitle
                        property: "opacity"
                        to: 1.0
                        duration: UbuntuAnimation.BriskDuration
                    }
                }
            }
        }
    }

    Switch {
        id: alarmStatus
        objectName: "listAlarmStatus" + index
        checked: model.enabled && (model.status === Alarm.Ready)

        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }

        onCheckedChanged: {
            if (checked !== model.enabled) {
                /*
                 Calculate the alarm time if it is a one-time alarm.
                 Repeating alarms do this automatically.
                */
                if(type === Alarm.OneTime) {
                    var date = new Date()
                    date.setHours(model.date.getHours(), model.date.getMinutes(), 0)

                    model.daysOfWeek = Alarm.AutoDetect
                    if (date < new Date()) {
                        var tomorrow = new Date()
                        tomorrow.setDate(tomorrow.getDate() + 1)
                        model.daysOfWeek = alarmUtils.get_alarm_day(tomorrow.getDay())
                    }
                    model.date = date

                }
                model.enabled = checked
                model.save()
            }
        }
    }
}
