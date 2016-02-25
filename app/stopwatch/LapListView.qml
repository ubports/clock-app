/*
 * Copyright (C) 2015 Canonical Ltd
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
import Stopwatch 1.0

ListView {
    id: lapListView

    clip: true

    StopwatchFormatTime {
        id: stopwatchFormatTime
    }

    header: ListItem {
        visible: count !== 0
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: units.gu(1)
            }

            Label {
                // #TRANSLATORS: This refers to the stopwatch lap and is shown as a header where space is limited. Constrain
                // translation length to a few characters.
                text: i18n.tr("Lap")
                width: parent.width / 5
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                width: 2 * parent.width / 5
                elide: Text.ElideRight
                text: i18n.tr("Lap Time")
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                width: 2 * parent.width / 5
                elide: Text.ElideRight
                text: i18n.tr("Total Time")
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    displaced: Transition {
        UbuntuNumberAnimation {
            property: "y"
            duration: UbuntuAnimation.BriskDuration
        }
    }

    delegate: ListItem {
        divider.visible: true
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter

        leadingActions: ListItemActions {
            actions: [
                Action {
                    iconName: "delete"
                    onTriggered: {
                        stopwatchEngine.removeLap(index)
                    }
                }
            ]
        }

        Row {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: units.gu(1)
            }

            Label {
                text: "#%1".arg(Number(count - index).toLocaleString(Qt.locale(), "f", 0))
                width: parent.width / 5
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                width: 2* parent.width / 5
                height: childrenRect.height
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: stopwatchFormatTime.lapTimeToString(model.laptime) + "."
                    }
                    Label {
                        text: stopwatchFormatTime.millisToString(model.laptime)
                    }
                }
            }

            Item {
                width: 2 * parent.width / 5
                height: childrenRect.height
                Row {
                    anchors.right: parent.right
                    Label {
                        text: stopwatchFormatTime.lapTimeToString(model.totaltime) + "."
                    }
                    Label {
                        text: stopwatchFormatTime.millisToString(model.totaltime)
                    }
                }
            }
        }
    }
}
