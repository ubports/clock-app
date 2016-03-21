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

Item {
    id: headerRow
    
    height: units.gu(6)

    Row {
        id: iconContainer
        
        anchors.centerIn: parent
        spacing: units.gu(2)

        ActionIcon {
            id: clockNavigationButton
            objectName: "clockNavigationButton"

            icon.name: "clock"
            icon.color: listview.currentIndex === 0 ? UbuntuColors.blue : UbuntuColors.slate
            onClicked: listview.moveToClockPage()
        }
        
        ActionIcon {
            id: stopwatchNavigationButton
            objectName: "stopwatchNavigationButton"

            icon.name: "stopwatch"
            icon.color: listview.currentIndex === 1 ? UbuntuColors.blue : UbuntuColors.slate
            onClicked:  listview.moveToStopwatchPage()
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

        icon.name: "settings"
        
        onClicked: {
            mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettingsPage.qml"))
        }
    }
}
