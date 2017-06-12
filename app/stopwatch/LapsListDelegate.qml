/*
 * Copyright (C) 2016 Canonical Ltd
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

ListItem {
    id: lapsListItem

    property string indexLabel
    property string lapTimeLabel
    property string lapMilliTimeLabel
    property string totalTimeLabel
    property string totalMilliTimeLabel




    Row {
        id:listItemRow
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: units.gu(3)
            rightMargin: units.gu(2)
        }

        Label {
            id: _indexLabel
            text: indexLabel
            width: parent.width / 5
            horizontalAlignment: Text.AlignLeft
        }

        Item {
            id: lapTimeContainer
            width: 2* parent.width / 5
            height: childrenRect.height
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    id: _lapTimeLabel
                    text: lapTimeLabel
                }
                Label {
                    id: _lapMilliTimeLabel
                    text: lapMilliTimeLabel
                }
            }
        }

        Item {
            width: 2 * parent.width / 5
            height: childrenRect.height
            Row {
                anchors.right: parent.right
                Label {
                    id: _totalTimeLabel
                    text: totalTimeLabel
                }
                Label {
                    id: _totalMilliTimeLabel
                    text: totalMilliTimeLabel
                }
            }
        }
    }
}
