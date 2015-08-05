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

import QtQuick 2.4
import Ubuntu.Components 1.2

Item {
    id: headerRow
    
    height: units.gu(7)

    Row {
        id: iconContainer
        
        anchors.centerIn: parent

        ActionIcon {
            width: units.gu(5.5)
            height: units.gu(4)
            iconName: "alarm-clock"
            onClicked: listview.currentIndex = 0
        }
        
        ActionIcon {
            width: units.gu(5.5)
            height: units.gu(4)
            iconName: "stopwatch-lap"
            onClicked: listview.currentIndex = 1
        }
    }
    
    Rectangle {
        id: outerProgressRectangle
        anchors {
            left: iconContainer.left
            right: iconContainer.right
            top: iconContainer.bottom
        }
        height: units.gu(0.3)
        color: UbuntuColors.lightGrey
        
        Rectangle {
            height: parent.height
            x: listview.currentIndex == 0 ? 0 : parent.width-width
            width: units.gu(5.5)
            color: UbuntuColors.orange
            Behavior on x {
                UbuntuNumberAnimation {}
            }
        }
    }
    
    ActionIcon {
        id: settingsIcon
        objectName: "settingsIcon"
        
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: units.gu(2)
        }

        iconName: "settings"
        
        onClicked: {
            mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettingsPage.qml"))
        }
    }
}
