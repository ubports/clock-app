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

import QtQuick 2.0
import DateTime 1.0
import Alarm.Settings 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"

Page {
    id: _alarmSettings

    title: i18n.tr("Settings")
    visible: false

    DateTime {
        id: localTimeSource
    }

    AlarmSettings {
        id: alarmSettings
    }

    ListModel {
        id: durationModel
        ListElement {
            duration: 10
        }

        ListElement {
            duration: 20
        }

        ListElement {
            duration: 30
        }

        ListElement {
            duration: 60
        }

        function title(index) {
            if (title["text"] === undefined) {
                title.text =
                        [
                            i18n.tr("%1 minutes").arg(10),
                            i18n.tr("%1 minutes").arg(20),
                            i18n.tr("%1 minutes").arg(30),
                            i18n.tr("%1 minutes").arg(60)
                        ]
            }
            return title.text[index]
        }
    }

    Column {
        id: _settingsColumn

        anchors.fill: parent

        ListItem.Expandable {
            id: _alarmDuration

            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(-2)
            }

            collapseOnClick: true
            expandedHeight: _contentColumn.height + units.gu(1)

            Column {
                id: _contentColumn
                width: parent.width

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
                    clip: true
                    model: durationModel
                    width: parent.width
                    height: units.gu(24)
                    delegate: ListItem.Standard {
                        text: _resultsList.model.title(index)
                        onClicked: {
                            alarmSettings.duration = duration
                            _alarmDuration.expanded = false
                        }
                    }
                }
            }
        }

        ListItem.Base {
            Column {
                width: parent.width
                height: childrenRect.height
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    color: UbuntuColors.midAubergine
                    text: i18n.tr("Alarm volume")
                }

                Slider {
                    id: _volumeSlider

                    height: units.gu(2)
                    width: parent.width

                    minimumValue: 1
                    maximumValue: 100
                    value: alarmSettings.volume

                    onValueChanged: {
                        alarmSettings.volume = formatValue(value)
                    }
                }
            }
        }

        SubtitledListItem {
            text: i18n.tr("Change time and date")
            subText: {
                var localTime = new Date
                        (
                            localTimeSource.localDateString.split(":")[0],
                            localTimeSource.localDateString.split(":")[1]-1,
                            localTimeSource.localDateString.split(":")[2],
                            localTimeSource.localTimeString.split(":")[0],
                            localTimeSource.localTimeString.split(":")[1],
                            localTimeSource.localTimeString.split(":")[2],
                            0
                        )
                return Qt.formatDateTime(localTime, "dddd, d MMMM yyyy hh:mm:ss t")
            }

            onClicked: {
                Qt.openUrlExternally("settings:///system/time-date")
            }
        }
    }
}
