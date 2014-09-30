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

AbstractButton {
    id: headerButton

    property alias iconSource: _icon.source
    property alias iconName: _icon.name
    property alias text: _label.text

    width: units.gu(6)
    height: parent ? parent.height : undefined

    Rectangle {
        anchors.fill: parent
        visible: headerButton.pressed
        color: Theme.palette.selected.background
    }

    Column {
        id: buttonHolder

        width: _label.width
        height: childrenRect.height

        spacing: units.gu(0.2)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: units.gu(0.3)

        Icon {
            id: _icon
            color: UbuntuColors.darkGrey
            width: units.gu(2.5)
            height: width
            opacity: headerButton.enabled ? 1.0 : 0.3
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: _label
            color: UbuntuColors.darkGrey
            fontSize: "xx-small"
            opacity: headerButton.enabled ? 1.0 : 0.3
            anchors.horizontalCenter: _icon.horizontalCenter
        }
    }
}
