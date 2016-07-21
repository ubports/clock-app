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
import Ubuntu.Components 1.3

/*
 Component which displays an empty state (approved by design). It offers an
 icon, title and subtitle to describe the empty state.
*/

Item {
    id: emptyState

    // Public APIs
    property alias iconName: emptyIcon.name
    property alias title: emptyLabel.text
    property alias subTitle: emptySublabel.text

    height: childrenRect.height

    Icon {
        id: emptyIcon
        anchors.horizontalCenter: parent.horizontalCenter
        height: units.gu(10)
        width: height
        color: "#BBBBBB"
        asynchronous: true
    }

    Label {
        id: emptyLabel
        textSize: Label.Large
        font.weight: Font.Normal
        width: parent.width
        wrapMode: Text.WordWrap
        anchors.top: emptyIcon.bottom
        anchors.topMargin: units.gu(4)
        horizontalAlignment: Text.AlignHCenter
        color: UbuntuColors.slate
    }

    Label {
        id: emptySublabel
        width: parent.width
        wrapMode: Text.WordWrap
        anchors.top: emptyLabel.bottom
        horizontalAlignment: Text.AlignHCenter
        color: UbuntuColors.ash
    }
}
