/*
 * Copyright (C) 2015-2016 Canonical Ltd
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
import Ubuntu.Components 1.3

UbuntuListView {
    id: timersListView

    clip: true
//    pressDelay: 75
    currentIndex: -1

    headerPositioning: ListView.PullBackHeader

    header: ListItem {
        z:2 //TODO for some reason this is needed as the items default to being above the header
        visible: count !== 0
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            color:theme.palette.normal.background
        }

        Row {

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: units.gu(1)
            }

            Label {
                width:  parent.width
                elide: Text.ElideRight
                text: i18n.tr("Saved Timers")
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

    delegate: TimerListDelegate {
        id: savedTimersListItem
        objectName: "savedTimersListItem" + index
        enabled: !_timerPage.isRunning

        divider.anchors.leftMargin: units.gu(2)
        divider.anchors.rightMargin: units.gu(2)

        leadingActions: ListItemActions {
            actions: [
                Action {
                    id: swipeDeleteAction
                    objectName: "swipeDeleteAction"
                    text: i18n.tr("Delete")
                    iconName: "delete"
                    onTriggered: {
                        clockDB.deleteDoc( model.docId )
                        timerNestedListViewHack.release();
                    }
                }
            ]
        }

        onClicked: {
            timerFace.getCircle().setTime(new Date(model.contents.time))
            timerNameField.text = model.contents.message
            timerNestedListViewHack.release();
        }

        timerTime:  new Date(model.contents.time)
        timerMessage: model.contents.message
        activeAlarm: activeTimers.findTimerAlarmByMessage(activeTimers.addPrefixToMessage(model.contents.message)) !== null && _timerPage.isRunning;
    }
}
