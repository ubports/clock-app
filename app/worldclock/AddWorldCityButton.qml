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
import "../components"

AbstractButton {
    id: addWorldCityButton

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    width: parent.width
    height: _addButton.height + units.gu(4)

    Label {
        text: i18n.tr("Add")
        anchors {
            right: _addButton.left
            rightMargin: units.gu(1)
            verticalCenter: _addButton.verticalCenter
        }
    }

    ClockCircle {
        id: _addButton

        isFoldVisible: false
        width: units.gu(5)
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: units.gu(1)
        }

        Icon {
            anchors.centerIn: parent
            color: theme.palette.normal.backgroundSecondaryText
            name: "add"
            height: units.gu(2)
            width: height
            asynchronous: true
        }
    }


    Label {
        text: i18n.tr("City")
        anchors {
            left: _addButton.right
            leftMargin: units.gu(1)
            verticalCenter: _addButton.verticalCenter
        }
    }

    onClicked: {
        pageStack.push(Qt.resolvedUrl("WorldCityList.qml"))
    }
}
