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
import "clock"
import "components"

MainView {
    id: clockApp

    // Property to store the state of an application (active or suspended)
    property bool applicationState: Qt.application.active

    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "clock"

    //applicationName for click packages (used as an unique app identifier)
    applicationName: "com.ubuntu.clock"

    /*
      This property enables the application to change orientation when the
      device is rotated. This has been set to false since we are currently
      only focussing on the phone interface.
     */
    automaticOrientation: false

    /* The width and height defined below are the same dimension used by the
       designers in the clock visual spec.
     */
    width: units.gu(40)
    height: units.gu(70)

    backgroundColor: "#F5F5F5"

    useDeprecatedToolbar: false

    onApplicationStateChanged: {
        /*
          Update Clock time immediately when the clock app is brought from suspend
          instead of waiting for the next minute to update.
         */
        if(applicationState)
            updateTime()
    }

    function updateTime() {
        clock.time = Qt.formatTime(new Date(), "hh:mm")
    }

    Background {}

    Timer {
        id: clockTimer

        interval: 60000
        repeat: true
        running: true
        onTriggered: updateTime()
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: clock.height + date.height + locationRow.height

        /*
          Property to set the maximum drag distance before freezing the add
          city button resize
         */
        property int _maxThreshold: -50

        /*
          Property to set the minimum drag distance before activating the add
          city signal
         */
        property int _minThreshold: -40

        AddCityButton {
            id: addCityButton
            anchors.top: parent.top
            anchors.topMargin: -labelHeight
            anchors.horizontalCenter: parent.horizontalCenter
            maxThreshold: flickable._maxThreshold
        }

        Clock {
            id: clock
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: units.gu(16) + clockApp.height/8
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: date

            Component.onCompleted: anchors.topMargin = units.gu(44)

            anchors.top: parent.top
            anchors.topMargin: units.gu(40)
            anchors.horizontalCenter: parent.horizontalCenter

            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
            fontSize: "medium"

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
                source: "graphics/Location_Pin.png"
                width: units.gu(1.2)
                height: units.gu(2.2)
            }

            Label {
                id: location
                text: "Location"
                fontSize: "large"
                anchors.verticalCenter: locationIcon.verticalCenter
                color: UbuntuColors.midAubergine
            }
        }

        onDragEnded: {
            if(contentY < _minThreshold)
                console.log("[LOG]: Activate add city signal")
        }

        onContentYChanged: {
            if(contentY < 0 && flickable.atYBeginning) {
                addCityButton.dragPosition = contentY.toFixed(0)
            }
        }
    }
}
