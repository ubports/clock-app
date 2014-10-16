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
import DateTime 1.0
import Alarm.Settings 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"

Page {
    id: _alarmSettings

    title: i18n.tr("Settings")
    visible: false
    flickable: settingsPlugin

    Connections {
        target: clockApp
        onApplicationStateChanged: {
            localTimeSource.update()
        }
    }

    DateTime {
        id: localTimeSource
    }

    AlarmSettings {
        id: alarmSettings
    }

    ListModel {
        id: durationModel
        Component.onCompleted: initialise()

        function initialise() {
            durationModel.append({ "duration": 10, "text": i18n.tr("%1 minutes").arg(10) })
            durationModel.append({ "duration": 20, "text": i18n.tr("%1 minutes").arg(20) })
            durationModel.append({ "duration": 30, "text": i18n.tr("%1 minutes").arg(30) })
            durationModel.append({ "duration": 60, "text": i18n.tr("%1 minutes").arg(60) })
        }
    }

    ListModel {
        id: snoozeModel
        Component.onCompleted: initialise()

        function initialise() {
            snoozeModel.append({ "duration": 2, "text": i18n.tr("%1 minutes").arg(2) })
            snoozeModel.append({ "duration": 4, "text": i18n.tr("%1 minutes").arg(4) })
            snoozeModel.append({ "duration": 5, "text": i18n.tr("%1 minutes").arg(5) })
            snoozeModel.append({ "duration": 10, "text": i18n.tr("%1 minutes").arg(10) })
        }
    }

    Flickable {
        id: settingsPlugin

        contentHeight: _settingsColumn.height
        anchors.fill: parent

        Column {
            id: _settingsColumn

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ListItem.Empty {
                height: 2 * implicitHeight

                Label {
                    color: UbuntuColors.midAubergine
                    text: i18n.tr("Alarm volume")
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        top: parent.top
                        topMargin: units.gu(1)
                    }
                }

                Slider {
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }

                    minimumValue: 1
                    maximumValue: 100
                    value: alarmSettings.volume

                    onValueChanged: {
                        alarmSettings.volume = formatValue(value)
                    }
                }
            }

            ListItem.Expandable {
                id: _alarmDuration

                anchors {
                    left: parent.left
                    right: parent.right
                }

                collapseOnClick: true
                expandedHeight: _contentColumn.height + units.gu(1)

                Column {
                    id: _contentColumn

                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: units.gu(-2)
                    }

                    Item {
                        width: parent.width
                        height: _alarmDuration.collapsedHeight

                        SubtitledListItem {
                            id: _header
                            text: i18n.tr("Silence after")
                            subText: i18n.tr("%1 minutes").arg(alarmSettings.duration)
                            onClicked: _alarmDuration.expanded = true

                            Icon {
                                id: _upArrow

                                width: units.gu(2)
                                height: width
                                anchors.right: parent.right
                                anchors.rightMargin: units.gu(2)
                                anchors.verticalCenter: parent.verticalCenter

                                name: "go-down"
                                color: "Grey"
                                rotation: _alarmDuration.expanded ? 180 : 0

                                Behavior on rotation {
                                    UbuntuNumberAnimation {}
                                }
                            }
                        }
                    }

                    ListView {
                        id: _resultsList

                        interactive: false
                        model: durationModel
                        width: parent.width
                        height: units.gu(24)

                        delegate: ListItem.Standard {
                            text: model.text
                            onClicked: {
                                alarmSettings.duration = duration
                                _alarmDuration.expanded = false
                            }
                        }
                    }
                }
            }

            ListItem.Expandable {
                id: _alarmSnooze

                anchors {
                    left: parent.left
                    right: parent.right
                }

                collapseOnClick: true
                expandedHeight: _snoozeContentColumn.height + units.gu(1)

                Column {
                    id: _snoozeContentColumn

                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: units.gu(-2)
                    }

                    Item {
                        width: parent.width
                        height: _alarmSnooze.collapsedHeight

                        SubtitledListItem {
                            id: _snoozeHeader
                            text: i18n.tr("Snooze for")
                            subText: i18n.tr("%1 minutes").arg(alarmSettings.snoozeDuration)
                            onClicked: _alarmSnooze.expanded = true

                            Icon {
                                id: _snoozeUpArrow

                                width: units.gu(2)
                                height: width
                                anchors.right: parent.right
                                anchors.rightMargin: units.gu(2)
                                anchors.verticalCenter: parent.verticalCenter

                                name: "go-down"
                                color: "Grey"
                                rotation: _alarmSnooze.expanded ? 180 : 0

                                Behavior on rotation {
                                    UbuntuNumberAnimation {}
                                }
                            }
                        }
                    }

                    ListView {
                        id: _snoozeResultsList

                        interactive: false
                        model: snoozeModel
                        width: parent.width
                        height: units.gu(24)

                        delegate: ListItem.Standard {
                            text: model.text
                            onClicked: {
                                alarmSettings.snoozeDuration = duration
                                _alarmSnooze.expanded = false
                            }
                        }
                    }
                }
            }

            ListItem.Empty {
                Label {
                    text: i18n.tr("Vibration")
                    color: UbuntuColors.midAubergine
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }
                }

                Switch {
                    id: vibrateSwitch

                    anchors {
                        right: parent.right
                        rightMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }

                    checked: alarmSettings.vibration === "pulse"
                    onCheckedChanged: {
                        if(checked) {
                            alarmSettings.vibration = "pulse"
                        } else {
                            alarmSettings.vibration = "none"
                        }
                    }
                }

                onClicked: {
                    vibrateSwitch.checked = !vibrateSwitch.checked
                }
            }

            SubtitledListItem {
                text: i18n.tr("Change time and date")
                subText: {
                    /*
                  FIXME: When the upstream QT bug at
                  https://bugreports.qt-project.org/browse/QTBUG-40275 is fixed
                  it will be possible to receive a datetime object directly
                  instead of using this hack.
                */
                    var localTime = new Date
                            (
                                localTimeSource.localDateString.split(":")[0],
                                localTimeSource.localDateString.split(":")[1]-1,
                                localTimeSource.localDateString.split(":")[2],
                                localTimeSource.localTimeString.split(":")[0],
                                localTimeSource.localTimeString.split(":")[1],
                                localTimeSource.localTimeString.split(":")[2],
                                localTimeSource.localTimeString.split(":")[3]
                                )
                    return localTime.toLocaleString()
                }

                onClicked: {
                    Qt.openUrlExternally("settings:///system/time-date")
                }
            }
        }
    }
}
