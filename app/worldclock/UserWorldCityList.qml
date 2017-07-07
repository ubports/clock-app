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
import U1db 1.0 as U1db
import Ubuntu.Components 1.3

ListView {
    id: worldCityColumn
    objectName: "userWorldCityRepeater"

    clip: true
    pressDelay: 66

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

    model: u1dbModel

    delegate: UserWorldCityDelegate {
        id: userWorldCityDelegate
        objectName: "userWorldCityItem" + index

        leadingActions: ListItemActions {
            actions: [
                Action {
                    id: swipeDeleteAction
                    objectName: "swipeDeleteAction"
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    onTriggered: {
                        /*
                         This if loop check is required due to a bug where the listitem
                         is not deleted when the listview count is 1. This should fix
                         http://pad.lv/1368393
                        */
                        if (worldCityColumn.count === 1) {
                            clockDB.deleteDoc(worldCityQuery.documents[index])
                            u1dbModel.clear()
                        } else {
                            clockDB.deleteDoc(worldCityQuery.documents[index])
                        }
                    }
                }
            ]
        }
    }
}
