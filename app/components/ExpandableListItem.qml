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

/*
 Component which extends the SDK Expandable list item and provides a easy
 to use component where the title, subtitle and a listview can be displayed. It
 matches the design specification provided for clock.
*/

ListItem {
    id: expandableListItem

    // Public APIs
    property ListModel model
    property Component delegate
    property alias titleText: expandableHeader.title
    property alias subText: expandableHeader.subtitle
    property alias listViewHeight: expandableListLoader.height
    property alias isActivityRunning: activity.running
    property alias isActivityVisible: activity.visible

    height: headerListItem.height
    expansion.height: headerListItem.height + expandableListLoader.height
    onClicked: expansion.expanded = !expansion.expanded

    ListItem {
        id: headerListItem
        height: expandableHeader.height + divider.height

        ListItemLayout {
            id: expandableHeader

            ActivityIndicator {
                id: activity; running: false; visible: false
                SlotsLayout.position: SlotsLayout.Trailing
            }
            Icon {
                id: arrow

                width: units.gu(2)
                height: width
                SlotsLayout.position: SlotsLayout.Last
                name: "go-down"
                rotation: expandableListItem.expansion.expanded ? 180 : 0
                asynchronous: true

                Behavior on rotation {
                    UbuntuNumberAnimation {}
                }
            }
        }
    }

    Loader {
        id: expandableListLoader
        width: parent.width
        asynchronous: true
        anchors.top: headerListItem.bottom
        sourceComponent: expandableListItem.expansion.expanded ? expandableListComponent : undefined
    }

    Component {
        id: expandableListComponent
        ListView {
            id: expandableList
            interactive: false
            model: expandableListItem.model
            delegate: expandableListItem.delegate
        }
    }
}

