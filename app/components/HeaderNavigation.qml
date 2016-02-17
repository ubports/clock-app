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
import Ubuntu.Components 1.3

Item {
    id: headerRow
    
    height: units.gu(6)

    Row {
        id: iconContainer
        
        anchors.centerIn: parent
        spacing: units.gu(2)

        ActionIcon {
            iconName: "clock"
            iconColor: listview.currentIndex == 0 ? "#19b6ee" : "#5d5d5d"
            onClicked: listview.currentIndex = 0
        }
        
        ActionIcon {
            iconName: "stopwatch"
            iconColor: listview.currentIndex == 1 ? "#19b6ee" : "#5d5d5d"
            onClicked: listview.currentIndex = 1
        }
    }
    

    ActionIcon {
        id: settingsIcon
        objectName: "settingsIcon"
        
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: units.gu(1)
        }

        iconName: "settings"
        
        onClicked: {
            mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettingsPage.qml"))
        }
    }
}
