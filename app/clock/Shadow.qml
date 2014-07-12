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

Item {
    id: _shadowContainer

    clip: true
    width: units.gu(22.5)
    height: width/2

    opacity: 0

    Rectangle {
        id: _shadow

        width: _shadowContainer.width
        height: width
        radius: width/2

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        color: Qt.rgba(0,0,0,0.2)
    }
}
