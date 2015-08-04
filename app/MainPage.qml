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
import "upstreamcomponents"
import "alarm"
import "clock"
import "stopwatch"

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
    bottomEdgeTitle: alarmUtils.set_bottom_edge_title(alarmModel, clockTime)

    Component.onCompleted: {
        console.log("[LOG]: Main Page loaded")
        _mainPage.setBottomEdgePage(Qt.resolvedUrl("alarm/AlarmPage.qml"), {})
    }

    AlarmUtils {
        id: alarmUtils
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

    // #TODO: Preferable this header should hide while scrolling up/down similar to ubuntu browser.
    Item {
        id: headerRow

        height: units.gu(7)
        opacity: 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
        }

        Row {
            id: iconContainer

            anchors.centerIn: parent

            // Boundary Space Creator
            Item {
                width: units.gu(1)
                height: units.gu(3)
            }

            Icon {
                name: "alarm-clock"
                width: units.gu(3)
                height: width
                color: UbuntuColors.coolGrey
            }

            // Middle Space Creator
            Item {
                width: units.gu(3)
                height: units.gu(3)
            }

            Icon {
                name: "stopwatch-lap"
                width: units.gu(3)
                height: width
                color: UbuntuColors.coolGrey
            }

            // Boundary Space Creator
            Item {
                width: units.gu(1)
                height: units.gu(3)
            }
        }

        Rectangle {
            id: outerProgressRectangle
            anchors {
                left: iconContainer.left
                right: iconContainer.right
                top: iconContainer.bottom
                topMargin: units.gu(0.5)
            }
            height: units.gu(0.3)
            color: UbuntuColors.lightGrey

            Rectangle {
                height: parent.height
                x: listview.currentIndex == 0 ? 0 : parent.width-width
                width: units.gu(5)
                color: UbuntuColors.orange
                Behavior on x {
                    UbuntuNumberAnimation {}
                }
            }
        }

        AbstractButton {
            id: settingsIcon
            objectName: "settingsIcon"

            onClicked: {
                mainStack.push(Qt.resolvedUrl("alarm/AlarmSettingsPage.qml"))
            }

            width: units.gu(5)
            height: width

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: units.gu(2)
            }

            Rectangle {
                visible: settingsIcon.pressed
                anchors.fill: parent
                color: Theme.palette.selected.background
            }

            Icon {
                width: units.gu(3)
                height: width
                anchors.centerIn: parent
                name: "settings"
                color: UbuntuColors.coolGrey
            }
        }
    }

    ListView {
        id: listview

        anchors {
            top: headerRow.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: navigationModel
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
    }
}
