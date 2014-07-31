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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../components/Utils.js" as Utils

Flickable {
    id: alarmListFlickable
    objectName: "alarmListFlickable"

    // Property to set the model of the saved alarm list
    property var model

    /*
      Property to set the minimum drag distance before activating the add
      alarm signal
    */
    property int _minThreshold: addAlarmButton.maxThreshold + units.gu(2)

    clip: true
    anchors.fill: parent
    contentHeight: alarmList.height

    AlarmUtils {
        id: alarmUtils
    }

    PullToAdd {
        id: addAlarmButton

        anchors {
            top: parent.top
            topMargin: -labelHeight - units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }

        leftLabel: i18n.tr("Add")
        rightLabel: i18n.tr("Alarm")
    }

    Column {
        id: alarmList
        anchors.fill: parent

        Repeater {
            id: alarmRepeater

            property var _currentSwipedItem: null

            function _updateSwipeState(item)
            {
                if (item.swipping) {
                    return
                }

                if (item.swipeState !== "Normal") {
                    if (alarmRepeater._currentSwipedItem !== item) {
                        if (alarmRepeater._currentSwipedItem) {
                            alarmRepeater._currentSwipedItem.resetSwipe()
                        }
                        alarmRepeater._currentSwipedItem = item
                    }
                } else if (item.swipeState !== "Normal"
                           && alarmRepeater._currentSwipedItem === item) {
                    alarmRepeater._currentSwipedItem = null
                }
            }

            model: alarmListFlickable.model
            delegate: AlarmDelegate {
                id: alarmDelegate

                property var removalAnimation

                function remove() {
                    removalAnimation.start()
                }

                onSwippingChanged: {
                    alarmRepeater._updateSwipeState(alarmDelegate)
                }

                onSwipeStateChanged: {
                    alarmRepeater._updateSwipeState(alarmDelegate)
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
                        if (alarmRepeater._currentSwipedItem
                                === alarmDelegate) {
                            alarmRepeater._currentSwipedItem = null
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
                        to: 1
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
            }
        }
    }

    onDragEnded: {
        if(contentY < _minThreshold)
            mainStack.push(Qt.resolvedUrl("EditAlarmPage.qml"))
    }

    onContentYChanged: {
        if(contentY < 0 && atYBeginning) {
            addAlarmButton.dragPosition = contentY.toFixed(0)
        }
    }
}

