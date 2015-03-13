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

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

/*
 Component which extends the SDK Expandable list item and provides a easy
 to use component where the title, subtitle and a listview can be displayed. It
 matches the design specification provided for clock.
*/

ListItem.Expandable {
    id: expandableListItem

    // Public APIs
    property ListModel model
    property Component delegate
    property alias text: expandableHeader.text
    property alias subText: expandableHeader.subText
    property alias listViewHeight: expandableList.height

    anchors {
        left: parent.left
        right: parent.right
        margins: units.gu(-2)
    }

    collapseOnClick: true
    expandedHeight: contentColumn.height + units.gu(1)

    Column {
        id: contentColumn

        anchors {
            left: parent.left
            right: parent.right
        }

        Item {
            width: parent.width
            height: expandableListItem.collapsedHeight

            SubtitledListItem {
                id: expandableHeader
                onClicked: expandableListItem.expanded = true

                Icon {
                    id: arrow

                    width: units.gu(2)
                    height: width
                    anchors.right: parent.right
                    anchors.rightMargin: units.gu(2)
                    anchors.verticalCenter: parent.verticalCenter

                    name: "go-down"
                    color: "Grey"
                    rotation: expandableListItem.expanded ? 180 : 0

                    Behavior on rotation {
                        UbuntuNumberAnimation {}
                    }
                }
            }
        }

        ListView {
            id: expandableList
            width: parent.width
            interactive: false
            model: expandableListItem.model
            delegate: expandableListItem.delegate
        }
    }
}

