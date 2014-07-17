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
import Alarm.Settings 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"

Page {
    id: _alarmSettings

    title: i18n.tr("Settings")
    visible: false

    AlarmSettings {
        id: alarmSettings
    }

    ListModel {
        id: durationModel
        ListElement {
            title: "10 minutes"
            duration: 10
        }

        ListElement {
            title: "20 minutes"
            duration: 20
        }

        ListElement {
            title: "30 minutes"
            duration: 30
        }

        ListElement {
            title: "60 minutes"
            duration: 60
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
                        subText: alarmSettings.duration.toString() + " "
                                 + i18n.tr("minutes")
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
                        text: title
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
    }
}
