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
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import "upstreamcomponents"
import "alarm"
import "clock"
import "stopwatch"
import "components"

Page {
    id: _mainPage
    objectName: "mainPage"

    // String with not localized date and time in format "yyyy:MM:dd:hh:mm:ss", eg.: "2016:10:05:16:10:15"
    property string notLocalizedDateTimeString

    // String with localized time, eg.: "4:10 PM"
    property string localizedTimeString

    // String with localized date, eg.: "Thursday, 17 September 2016"
    property string localizedDateString

    // Property to keep track of an app cold start status
    property alias isColdStart: clockPage.isColdStart

    // Property to check if the clock page is currently visible
    property bool isClockPage: listview.currentIndex === 0

    // Clock App Alarm Model Reference Variable
    property var alarmModel

    Timer {
        id: hideBottomEdgeHintTimer
        interval: 3000
        onTriggered: bottomEdgeLoader.item.hint.status = BottomEdgeHint.Inactive
    }

    Loader {
        id: bottomEdgeLoader
        asynchronous: true
        onLoaded: hideBottomEdgeHintTimer.start()
        Component.onCompleted: setSource("components/AlarmBottomEdge.qml", {
                                             "objectName": "bottomEdge",
                                             "parent": _mainPage,
                                             "pageStack": mainStack,
                                             "alarmModel": Qt.binding( function () { return  _mainPage.alarmModel } ),
                                             "hint.visible": Qt.binding( function () { return _mainPage.isClockPage } ),
                                             "hint.objectName": "bottomEdgeHint"
                                         })
    }

    AlarmUtils {
        id: alarmUtils
    }

    ScreenSaver {
        // Disable screen dimming/off when stopwatch is running
        screenSaverEnabled: !stopwatchPage.isRunning
    }

    VisualItemModel {
        id: navigationModel
        ClockPage {
            id: clockPage
            notLocalizedClockTimeString: _mainPage.notLocalizedDateTimeString
            localizedClockTimeString: _mainPage.localizedTimeString
            localizedClockDateString: _mainPage.localizedDateString
            width: clockApp.width
            height: listview.height
        }

        StopwatchPage {
            id: stopwatchPage
            width: clockApp.width
            height: listview.height
        }
    }

    header: PageHeader {
        visible: false
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
        objectName: "pageListView"

        // Property required only in autopilot to check if listitem has finished moving
        property alias isMoving: moveAnimation.running

        function moveToStopwatchPage() {
            moveAnimation.moveTo(listview.originX + listview.width)
            listview.currentIndex = 1
        }

        function moveToClockPage() {
            moveAnimation.moveTo(listview.originX)
            listview.currentIndex = 0
        }

        UbuntuNumberAnimation {
            id: moveAnimation
            objectName: "pageListViewAnimation"

            target: listview
            property: "contentX"
            function moveTo(contentX) {
                from = listview.contentX
                to = contentX
                start()
            }
        }

        // Show the stopwatch page on app startup if it is running
        Component.onCompleted: {
            if (stopwatchPage.isRunning) {
                moveToStopwatchPage()
            }
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
        interactive: false
    }
}
