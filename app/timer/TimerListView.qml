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
    pressDelay: 70
    currentIndex: -1

    headerPositioning: ListView.PullBackHeader

    header: ListItem {
        z:2 //TODO for some reason this is needed as the items default to being above the header
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
                text: i18n.tr("ID")
                width: parent.width / 5
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                width: 2 * parent.width / 5
                elide: Text.ElideRight
                text: i18n.tr("Time")
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                width: 2 * parent.width / 5
                elide: Text.ElideRight
                text: i18n.tr("Label")
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

    delegate: TimerListDelegate {
        id: lapsListItem
        objectName: "lapsListItem" + index

        divider.anchors.leftMargin: units.gu(2)
        divider.anchors.rightMargin: units.gu(2)

        leadingActions: ListItemActions {
            actions: [
                Action {
                    id: swipeDeleteAction
                    objectName: "swipeDeleteAction"
                    iconName: "delete"
                    onTriggered: {
                        clockDB.deleteDoc( model.docId )
                    }
                }
            ]
        }

        trailingActions: ListItemActions {
            actions: [
                Action {
                    id: setTimerAction
                    objectName: "setTimerAction"
                    iconName: "keyboard-enter"
                    onTriggered: {
                        //TODO
                        console.log(model.contents.time)
                        timerFace.getCircle().setTime(new Date(model.contents.time))
                    }
                }
            ]
        }
        function prinObject(obj) {
            for(var i in obj ) {
                console.log(obj[i]);
                if(typeof obj[i] == "object") {
                    prinObject(obj[i]);
                }
            }
        }
        indexLabel: "#%1".arg(Number(count - index).toLocaleString(Qt.locale(), "f", 0))
        timerTime:  new Date(model.contents.time)
        timerMessage: model.contents.message
    }
}
