/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1
import "../components"
import "../components/Utils.js" as Utils

PageWithBottomEdge {
    id: _clockPage

    /*
      Property to set the minimum drag distance before activating the add
      city signal
    */
    property int _minThreshold: addCityButton.maxThreshold + units.gu(2)

    // Property to keep track of the clock mode
    property alias isDigital: clock.clockMode

    flickable: null

    Component.onCompleted: Utils.log(debugMode, "Clock Page loaded")

    function updateTime() {
        clock.analogTime = new Date()
        clock.time = Qt.formatTime(clock.analogTime)
    }

    Flickable {
        id: _flickable

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: clock.height + date.height + locationRow.height

        PullToAdd {
            id: addCityButton

            anchors.top: parent.top
            anchors.topMargin: -labelHeight - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter

            leftLabel: i18n.tr("Add")
            rightLabel: i18n.tr("City")
        }

        Icon {
            id: settingsIcon

            Component.onCompleted: anchors.topMargin = units.gu(2)

            width: units.gu(3)
            height: width

            anchors {
                top: parent.top
                topMargin: units.gu(6)
                right: parent.right
                rightMargin: units.gu(2)
            }

            name: "settings"
            color: "Grey"

            Behavior on anchors.topMargin {
                UbuntuNumberAnimation { duration: 900 }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettings.qml"))
            }
        }

        Clock {
            id: clock
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: units.gu(20)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: date

            Component.onCompleted: anchors.topMargin = units.gu(40)

            anchors.top: parent.top
            anchors.topMargin: units.gu(36)
            anchors.horizontalCenter: parent.horizontalCenter

            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
            fontSize: "xx-small"

            Behavior on anchors.topMargin {
                UbuntuNumberAnimation { duration: 900 }
            }
        }

        Row {
            id: locationRow

            spacing: units.gu(1)

            anchors.top: date.bottom
            anchors.topMargin: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: locationIcon
                source: "../graphics/Location_Pin.png"
                width: units.gu(1.2)
                height: units.gu(2.2)
            }

            Label {
                id: location
                text: "Location"
                fontSize: "medium"
                anchors.verticalCenter: locationIcon.verticalCenter
                color: UbuntuColors.midAubergine
            }
        }

        onDragEnded: {
            if(contentY < _minThreshold) {
                mainStack.push(Qt.resolvedUrl("../worldclock/WorldCityList.qml"))
            }
        }

        onContentYChanged: {
            if(contentY < 0 && atYBeginning) {
                addCityButton.dragPosition = contentY.toFixed(0)
            }
        }
    }
}
