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
import Ubuntu.Components 1.2
import Stopwatch 1.0 as Stopwatch

ListView {
    id: lapListView

    clip: true

    Stopwatch.StopwatchUtils {
        id: stopwatchUtils
    }

    header: ListItem {
        visible: count !== 0
        Row {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: units.gu(2)
            }

            Label {
                // #TRANSLATORS: This refers to the stopwatch lap and is shown as a header where space is limited. Constrain
                // translation length to a few characters.
                text: i18n.tr("Lap")
                width: parent.width / 7
                elide: Text.ElideRight
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                width: 3 * parent.width / 7
                elide: Text.ElideRight
                text: i18n.tr("Lap Time")
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                width: 3 * parent.width / 7
                elide: Text.ElideRight
                text: i18n.tr("Total Time")
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
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
        leadingActions: ListItemActions {
            actions: [
                Action {
                    iconName: "delete"
                    onTriggered: {
                        lapHistory.removeLap(index)
                    }
                }
            ]
        }

        Row {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: units.gu(2)
            }

            Label {
                color: UbuntuColors.midAubergine
                text: "#%1".arg(Number(count - index).toLocaleString(Qt.locale(), "f", 0))
                width: parent.width / 7
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                width: 3 * parent.width / 7
                height: childrenRect.height
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: stopwatchUtils.lapTimeToString(model.laptime) + "."
                    }
                    Label {
                        fontSize: "x-small"
                        text: stopwatchUtils.millisToString(model.laptime)
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: units.dp(1)
                    }
                }
            }

            Item {
                width: 3 * parent.width / 7
                height: childrenRect.height
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        text: stopwatchUtils.lapTimeToString(model.totaltime) + "."
                    }
                    Label {
                        fontSize: "x-small"
                        text: stopwatchUtils.millisToString(model.totaltime)
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: units.dp(1)
                    }
                }
            }
        }
    }
}
