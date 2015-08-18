/*
 * Copyright (C) 2014-2015 Canonical Ltd
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
import Timezone 1.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.2

ListView {
    id: worldCityColumn
    objectName: "userWorldCityRepeater"

    clip: true
    anchors.fill: parent

    onFlickStarted:  {
        forceActiveFocus()
    }

    // U1db Index to index all documents storing the world city details
    U1db.Index {
        id: by_worldcity
        database: clockDB
        expression: [
            "worldlocation.city",
            "worldlocation.country",
            "worldlocation.timezone"
        ]
    }

    // U1db Query to create a model of the world cities saved by the user
    U1db.Query {
        id: worldCityQuery
        index: by_worldcity
        query: ["*","*","*"]
    }

    GenericTimeZoneModel {
        id: u1dbModel
        updateInterval: 1000
        results: worldCityQuery.results
    }

    property var _currentSwipedItem: null

    function _updateSwipeState(item)
    {
        if (item.swipping) {
            return
        }

        if (item.swipeState !== "Normal") {
            if (worldCityColumn._currentSwipedItem !== item) {
                if (worldCityColumn._currentSwipedItem) {
                    worldCityColumn._currentSwipedItem.resetSwipe()
                }
                worldCityColumn._currentSwipedItem = item
            }
        } else if (item.swipeState !== "Normal"
                   && worldCityColumn._currentSwipedItem === item) {
            worldCityColumn._currentSwipedItem = null
        }
    }

    model: u1dbModel

    delegate: UserWorldCityDelegate {
        id: userWorldCityDelegate
        objectName: "userWorldCityItem" + index

        property var removalAnimation

        function remove() {
            removalAnimation.start()
        }

        onSwippingChanged: {
            worldCityColumn._updateSwipeState(userWorldCityDelegate)
        }

        onSwipeStateChanged: {
            worldCityColumn._updateSwipeState(userWorldCityDelegate)
        }

        leftSideAction: Action {
            iconName: "delete"
            text: i18n.tr("Delete")
            onTriggered: {
                userWorldCityDelegate.remove()
            }
        }

        ListView.onRemove: ScriptAction {
            script: {
                if (worldCityColumn._currentSwipedItem
                        === userWorldCityDelegate) {
                    worldCityColumn._currentSwipedItem = null
                }
            }
        }

        removalAnimation: SequentialAnimation {
            alwaysRunToEnd: true

            PropertyAction {
                target: userWorldCityDelegate
                property: "ListView.delayRemove"
                value: true
            }

            UbuntuNumberAnimation {
                target: userWorldCityDelegate
                property: "height"
                to: 0
            }

            PropertyAction {
                target: userWorldCityDelegate
                property: "ListView.delayRemove"
                value: false
            }

            ScriptAction {
                script: clockDB.deleteDoc(worldCityQuery.documents[index])
            }
        }
    }

}
