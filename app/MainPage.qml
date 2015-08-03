/*
 * Copyright (C) 2014-2015 Canonical Ltd
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

PageWithBottomEdge {
    id: _mainPage
    objectName: "mainPage"

    // Property to keep track of the clock time
    property var clockTime: new Date()

    // Property to keep track of an app cold start status
    property alias isColdStart: clockPage.isColdStart

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

        // #FIXME: Demo Purposes Only! Replace with working version
        Rectangle {
            color: "LightBlue"
            height: listview.height
            width: clockApp.width
            Label {
                anchors.centerIn: parent
                text: "Stopwatch!"
            }
        }

        // #FIXME: Demo Purposes Only! Replace with working version
        Rectangle {
            color: "LightGreen"
            height: listview.height
            width: clockApp.width
            Label {
                anchors.centerIn: parent
                text: "Timer!"
            }
        }
    }

    // #TODO: Preferable this header should hide while scrolling up/down similar to ubuntu browser.
    Rectangle {
        id: headerRow

        color: "LightBlue"
        height: units.gu(8)
        opacity: 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
        }

        // #FIXME: Remove Later!
        Label {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: units.gu(2)
            }
            text: "Header Container"
            fontSize: "large"
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
                color: "Grey"
            }
        }
    }

    ListView {
        id: listview
        anchors { top: headerRow.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        model: navigationModel
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
    }
}
