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
    property alias listViewHeight: expandableList.height

    height: expandableHeader.height + divider.height
    expansion.height: contentColumn.height
    onClicked: expansion.expanded = !expansion.expanded

    Column {
        id: contentColumn

        anchors {
            left: parent.left
            right: parent.right
        }

        ListItem {
            height: expandableHeader.height + divider.height
            ListItemLayout {
                id: expandableHeader

                Icon {
                    id: arrow

                    width: units.gu(2)
                    height: width
                    SlotsLayout.position: SlotsLayout.Trailing
                    SlotsLayout.overrideVerticalPositioning: true
                    anchors.verticalCenter: parent.verticalCenter
                    name: "go-down"
                    rotation: expandableListItem.expansion.expanded ? 180 : 0

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

