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
import "../components"
import "../upstreamcomponents"
import "../components/Utils.js" as Utils

MultipleSelectionListView {
    id: alarmListView
    objectName: "alarmListView"

    property var _currentSwipedItem: null

    function _updateSwipeState(item)
    {
        if (item.swipping) {
            return
        }

        if (item.swipeState !== "Normal") {
            if (alarmListView._currentSwipedItem !== item) {
                if (alarmListView._currentSwipedItem) {
                    alarmListView._currentSwipedItem.resetSwipe()
                }
                alarmListView._currentSwipedItem = item
            }
        } else if (item.swipeState !== "Normal"
                   && alarmListView._currentSwipedItem === item) {
            alarmListView._currentSwipedItem = null
        }
    }

    clip: true
    anchors.fill: parent

    AlarmUtils {
        id: alarmUtils
    }

    listDelegate: AlarmDelegate {
        id: alarmDelegate
        objectName: "alarm" + index

        property var removalAnimation

        function remove() {
            removalAnimation.start()
        }

        selectionMode: alarmListView.isInSelectionMode
        selected: alarmListView.isSelected(alarmDelegate)

        onSwippingChanged: {
            _updateSwipeState(alarmDelegate)
        }

        onSwipeStateChanged: {
            _updateSwipeState(alarmDelegate)
        }

        leftSideAction: Action {
            iconName: "delete"
            text: i18n.tr("Delete")
            onTriggered: {
                alarmDelegate.remove()
            }
        }

        ListView.onRemove: ScriptAction {
            script: {
                if (_currentSwipedItem
                        === alarmDelegate) {
                    _currentSwipedItem = null
                }
            }
        }

        removalAnimation: SequentialAnimation {
            alwaysRunToEnd: true

            PropertyAction {
                target: alarmDelegate
                property: "ListView.delayRemove"
                value: true
            }

            UbuntuNumberAnimation {
                target: alarmDelegate
                property: "height"
                to: 0
            }

            PropertyAction {
                target: alarmDelegate
                property: "ListView.delayRemove"
                value: false
            }

            ScriptAction {
                script: {
                    var alarm = alarmModel.get(index)
                    alarm.cancel()
                }
            }
        }

        onItemClicked: {
            if(alarmListView.isInSelectionMode) {
                if(!alarmListView.selectItem(alarmDelegate)) {
                    alarmListView.deselectItem(alarmDelegate)
                }
                return
            }

            else {
                mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"),
                               {"isNewAlarm": false, "alarmIndex": index})
            }
        }

        onItemPressAndHold: {
            if (!alarmListView.isInSelectionMode) {
                alarmListView.startSelection()
                alarmListView.selectItem(alarmDelegate)
            }
        }
    }
}

