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
    id: navigationRow
    height: units.gu(5)

    Row {
        id: iconContainer

        anchors.centerIn: parent
        spacing: units.gu(1)

        ActionIcon {
            id: clockNavigationButton
            property bool isSelected: listview.currentIndex === 0
            objectName: "clockNavigationButton"
            icon.name: "clock"
            icon.color: isSelected ? UbuntuColors.blue : UbuntuColors.slate
            onClicked: listview.moveToClockPage()
        }

        ActionIcon {
            property bool isSelected: listview.currentIndex === 1
            id: stopwatchNavigationButton
            objectName: "stopwatchNavigationButton"
            icon.name: "stopwatch"
            icon.color: isSelected ? UbuntuColors.blue : UbuntuColors.slate
            onClicked:  listview.moveToStopwatchPage()
        }

        ActionIcon {
            property bool isSelected: listview.currentIndex === 2
            id: timerNavigationButton
            objectName: "timerNavigationButton"
            icon.name: "timer"
            icon.color: isSelected ? UbuntuColors.blue : UbuntuColors.slate
            onClicked:  listview.moveToTimerPage()
        }
    }
}
