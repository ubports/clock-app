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
import WorldClock 1.0
import Alarm 1.0
import Ubuntu.Components 1.3
import "../components"

Page {
    id: _alarmSettings

    visible: false

    header: PageHeader {
        title: i18n.tr("Settings")
        flickable: settingsPlugin
    }

    Connections {
        target: rootWindow
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
            // TRANSLATORS: Alarm stops after
            durationModel.append({ "duration": 10, "text": i18n.tr("%1 minute", "%1 minutes", 10).arg(10) })
            durationModel.append({ "duration": 20, "text": i18n.tr("%1 minute", "%1 minutes", 20).arg(20) })
            durationModel.append({ "duration": 30, "text": i18n.tr("%1 minute", "%1 minutes", 30).arg(30) })
            durationModel.append({ "duration": 60, "text": i18n.tr("%1 minute", "%1 minutes", 60).arg(60) })
        }
    }

    ListModel {
        id: snoozeModel
        Component.onCompleted: initialise()

        function initialise() {
            // TRANSLATORS: Snooze for
            snoozeModel.append({ "duration": 2, "text": i18n.tr("%1 minute", "%1 minutes", 2).arg(2) })
            snoozeModel.append({ "duration": 5, "text": i18n.tr("%1 minute", "%1 minutes", 5).arg(5) })
            snoozeModel.append({ "duration": 10, "text": i18n.tr("%1 minute", "%1 minutes", 10).arg(10) })
            snoozeModel.append({ "duration": 15, "text": i18n.tr("%1 minute", "%1 minutes", 15).arg(15) })
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

            ListItem {
                height: alarmVolumeSlot.height + divider.height

                SlotsLayout {
                    id: alarmVolumeSlot

                    mainSlot: Column {
                        Label {
                            text: i18n.tr("Alarm volume")
                        }

                        Slider {
                            minimumValue: 1
                            maximumValue: 100
                            live: true
                            value: alarmSettings.volume
                            function formatValue(v) { return v = "" }
                            onValueChanged: {
                                alarmSettings.volume = value
                            }
                        }
                    }
                }
            }

            ExpandableListItem {
                id: _alarmDuration

                listViewHeight: units.gu(28)
                titleText.text: i18n.tr("Alarm stops after")
                subText.text: i18n.tr("%1 minute", "%1 minutes", alarmSettings.duration).arg(alarmSettings.duration)
                subText.textSize: Label.Medium

                model: durationModel

                delegate: ListItem {
                    ListItemLayout {
                        title.text: model.text

                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            height: width
                            name: "tick"
                            visible: alarmSettings.duration === duration
                        }
                    }

                    onClicked: {
                        alarmSettings.duration = duration
                        _alarmDuration.expansion.expanded = false
                    }
                }
            }

            ExpandableListItem {
                id: _alarmSnooze

                listViewHeight: units.gu(28)
                titleText.text: i18n.tr("Snooze for")
                subText.text: i18n.tr("%1 minute", "%1 minutes", alarmSettings.snoozeDuration).arg(alarmSettings.snoozeDuration)
                subText.textSize: Label.Medium

                model: snoozeModel

                delegate: ListItem {
                    ListItemLayout {
                        title.text: model.text

                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            height: width
                            name: "tick"
                            visible: alarmSettings.snoozeDuration === duration
                        }
                    }

                    onClicked: {
                        alarmSettings.snoozeDuration = duration
                        _alarmSnooze.expansion.expanded = false
                    }
                }
            }

            ListItem {
                height: vibrationLayout.height + divider.height
                ListItemLayout {
                    id: vibrationLayout
                    title.text: i18n.tr("Vibration")

                    Switch {
                        id: vibrateSwitch
                        SlotsLayout.position: SlotsLayout.Trailing
                        checked: alarmSettings.vibration === "pulse"
                        onCheckedChanged: {
                            if(checked) {
                                alarmSettings.vibration = "pulse"
                            } else {
                                alarmSettings.vibration = "none"
                            }
                        }
                    }
                }

                onClicked: {
                    vibrateSwitch.checked = !vibrateSwitch.checked
                }
            }

            ListItem {
                height: timeAndDateLayout.height + divider.height
                ListItemLayout {
                    id: timeAndDateLayout

                    title.text: i18n.tr("Change time and date")
                    subtitle.text: localTimeSource.localizedCurrentDateString + " " + localTimeSource.localizedCurrentTimeString
                    subtitle.textSize: Label.Medium

                    Icon {
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(2)
                        height: width
                        name: "go-next"
                    }
                }

                onClicked: {
                    Qt.openUrlExternally("settings:///system/time-date")
                }
            }

        }
    }
}
