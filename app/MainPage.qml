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
import QtGraphicalEffects 1.0
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
        onLoaded: {
            item.alarmModel = Qt.binding( function () { return  _mainPage.alarmModel } );
            item.hint.visible = Qt.binding( function () { return _mainPage.isClockPage } );
            hideBottomEdgeHintTimer.start();
        }
        Component.onCompleted: setSource("components/AlarmBottomEdge.qml", {
                                             "objectName": "bottomEdge",
                                             "parent": _mainPage,
                                             "pageStack": mainStack,
                                             "hint.objectName": "bottomEdgeHint"
                                         });
    }

    AlarmUtils {
        id: alarmUtils
    }

    ScreenSaver {
        // Disable screen dimming/off when stopwatch is running
        screenSaverEnabled: stopwatchPageLoader.item && !stopwatchPageLoader.item.isRunning
    }

    VisualItemModel {
        id: navigationModel
        ClockPage {
            id: clockPage
            anchors.bottomMargin: units.gu(4)
            notLocalizedClockTimeString: _mainPage.notLocalizedDateTimeString
            localizedClockTimeString: _mainPage.localizedTimeString
            localizedClockDateString: _mainPage.localizedDateString
            width: clockApp.width
            height: listview.height -units.gu(4)
            onStartupAnimationEnd: {
                stopwatchPageLoader.setSource("stopwatch/StopwatchPage.qml" ,{
                                                                     "notLocalizedClockTimeString": _mainPage.notLocalizedDateTimeString,
                                                                     "localizedClockTimeString": _mainPage.localizedTimeString,
                                                                     "localizedClockDateString": _mainPage.localizedDateString,
                                                                     "width": clockApp.width,
                                                                     "height": listview.height});
                timerPageLoader.setSource("timer/TimerPage.qml" ,{
                                                                 "width": clockApp.width,
                                                                 "height": listview.height });
            }

        }

        Loader {
            id:stopwatchPageLoader
            asynchronous: true
            width: clockApp.width
            height: listview.height -units.gu(4)
            anchors.bottomMargin: units.gu(4)
            onLoaded: {
                if (this.item.isRunning) {
                    listview.moveToStopwatchPage()
                }
            }
        }

        Loader {
            id:timerPageLoader
            asynchronous: true
            active: alarmModel !== null || timerPageLoader.item;
            width: clockApp.width
            height: listview.height- units.gu(4)
            anchors.bottomMargin: units.gu(4)
            onLoaded: {
                item.alarmModel = Qt.binding( function () { return  _mainPage.alarmModel } )
                if (this.item.isRunning) {
                    listview.moveToTimerPage()
                }
            }
        }
    }

    header: PageHeader {
        visible:true
        StyleHints {
            backgroundColor: "transparent"
            dividerColor: "transparent"
        }
        contents: NavigationRow {
            id: headerNavRow
            anchors {
               fill:parent
               leftMargin: mainTrailingActions.width
            }
        }

        trailingActionBar {
            id:mainTrailingActions
            actions : [
                Action {
                    id: settingsIcon
                    objectName: "settingsIcon"
                    text: i18n.tr("Settings")
                    iconName: "settings"
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("./alarm/AlarmSettingsPage.qml"))
                    }
                },
                Action {
                    id: infoIcon
                    objectName: "infoIcon"
                    text: i18n.tr("About")
                    iconName: "info"
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("./components/Information.qml"))
                    }
                }
            ]
            numberOfSlots: 1
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

        function moveToTimerPage() {
            moveAnimation.moveTo(listview.originX + listview.width*2)
            listview.currentIndex = 2
        }

        function moveToClockPage() {
            moveAnimation.moveTo(listview.originX)
            listview.currentIndex = 0
        }

        function updateListViewCurrentIndex() {
               listview.currentIndex = listview.indexAt(listview.contentX,0);
        }

        onMovementEnded: updateListViewCurrentIndex();
        onCurrentIndexChanged: listview.interactive = true

        UbuntuNumberAnimation {
            id: moveAnimation
            objectName: "pageListViewAnimation"

            target: listview
            property: "contentX"
            function moveTo(newContentX) {
                from = listview.contentX
                to = newContentX
                start()
            }
            onStopped: {
                listview.positionViewAtIndex(listview.currentIndex,ListView.Contain);
            }
        }

        // Show the stopwatch page on app startup if it is running
        Component.onCompleted: {
            if (stopwatchPageLoader.item && stopwatchPageLoader.item.isRunning) {
                moveToStopwatchPage()
            }
        }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: units.gu(4)
        }

        model: navigationModel
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        flickDeceleration:width/4
        maximumFlickVelocity: width*5
        interactive: true
    }
    //Bottom swipe area
    DropShadow {
       anchors.fill: bottomSwipeRect
       verticalOffset: 0
       radius:3
       samples: 7
       color: Qt.rgba(0,0,0,0.2)
       source:bottomSwipeRect
       transparentBorder :true
   }
    MouseArea {
        z:10
        anchors.fill:bottomSwipeRect
        onPressed: { listview.interactive = true ; mouse.accepted = false }
    }
    Rectangle {
        id:bottomSwipeRect
        anchors {
            left:parent.left
            right:parent.right
            bottom: parent.bottom
        }
        color:theme.palette.normal.background
        height:units.gu(4)
    }
}
