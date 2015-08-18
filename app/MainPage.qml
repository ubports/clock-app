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
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import "upstreamcomponents"
import "alarm"
import "clock"
import "stopwatch"
import "components"

PageWithBottomEdge {
    id: _mainPage
    objectName: "mainPage"

    // Property to keep track of the clock time
    property var clockTime: new Date()

    // Property to keep track of an app cold start status
    property alias isColdStart: clockPage.isColdStart

    // Property to check if the clock page is currently visible
    property bool isClockPage: listview.currentIndex === 0

    // Clock App Alarm Model Reference Variable
    property var alarmModel

    flickable: null
    bottomEdgeTitle: _mainPage.visible ? alarmUtils.set_bottom_edge_title(alarmModel, clockTime)
                                       : i18n.tr("No active alarms")

    Component.onCompleted: {
        console.log("[LOG]: Main Page loaded")
        _mainPage.setBottomEdgePage(Qt.resolvedUrl("alarm/AlarmPage.qml"), {})
    }

    AlarmUtils {
        id: alarmUtils
    }

    ScreenSaver {
        // Disable screen dimming/off when stopwatch is running
        screenSaverEnabled: !stopwatchPage.running
    }

    Settings {
        id: stopwatchState
        property alias stopwatchStartTime: stopwatchPage.startTime
        property alias stopwatchRunning: stopwatchPage.running
        property alias stopwatchOldDiff: stopwatchPage.oldDiff
    }

    VisualItemModel {
        id: navigationModel
        ClockPage {
            id: clockPage
            clockTime: _mainPage.clockTime
            width: clockApp.width
            height: listview.height
        }

        StopwatchPage {
            id: stopwatchPage
            width: clockApp.width
            height: listview.height
        }
    }

    HeaderNavigation {
        id: headerRow

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
        }
    }

    ListView {
        id: listview

        // Show the stopwatch page on app startup if it is running
        Component.onCompleted: {
            if (stopwatchState.stopwatchRunning)
                positionViewAtIndex(1, ListView.SnapPosition)
        }

        anchors {
            top: headerRow.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: navigationModel
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        interactive: true
        highlightMoveDuration: UbuntuAnimation.BriskDuration
        highlightRangeMode: ListView.StrictlyEnforceRange
    }
}
