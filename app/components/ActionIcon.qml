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

AbstractButton {
    id: abstractButton

    property alias icon: _icon
    property alias label : _label

    width: units.gu(6)
    height: width

    Rectangle {
        visible: abstractButton.pressed
        anchors.fill: parent
        color: UbuntuColors.silk
    }

    Icon {
        id: _icon
        width: parent.width - units.gu(4)
        height: width
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: units.gu(0.5)
        color: UbuntuColors.slate
        asynchronous: true
    }
    Label {
        id: _label
        width:  parent.width
        height: units.gu(1)
        anchors.top: _icon.bottom
        color: _icon.color
        visible: this.text != ""
        text: ""
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: units.dp(11)

    }
}
