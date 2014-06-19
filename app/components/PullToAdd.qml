/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1

Row {
    id: _pullToAdd

    // Property to get the position of the button from the top
    property int dragPosition: 0

    // Property to store the height of the label
    property alias labelHeight: _leftLabel.height

    // Property to set the label on the left side of the add button
    property alias leftLabel: _leftLabel.text

    // Property to set the label on the right side of the add button
    property alias rightLabel: _rightLabel.text

    // Property to set the maximum threshold beyond which the button shouldn't resize
    property int maxThreshold

    spacing: units.gu(1)

    Label {
        id: _leftLabel

        text: "pull"
        fontSize: "medium"
        color: UbuntuColors.midAubergine
        anchors.verticalCenter: parent.verticalCenter
    }

    ClockCircle {
        id: _addButton

        isOuter: true
        width: dragPosition >= maxThreshold ? dragPosition * units.gu(6.5)/maxThreshold : units.gu(6.5)

        ClockCircle {
            width: dragPosition >= maxThreshold ? dragPosition * units.gu(4.5)/maxThreshold : units.gu(4.5)
            anchors.centerIn: parent

            Label {
                id: plusLabel

                anchors.centerIn: parent
                font.pixelSize: dragPosition >= maxThreshold ? dragPosition * units.dp(30)/maxThreshold : units.dp(30)
                text: "+"
            }
        }
    }

    Label {
        id: _rightLabel

        text: "down"
        fontSize: "medium"
        color: UbuntuColors.midAubergine
        anchors.verticalCenter: parent.verticalCenter
    }
}
