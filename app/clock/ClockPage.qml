/*
 * Copyright (C) 2014 Canonical Ltd
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

import QtQuick 2.3
import U1db 1.0 as U1db
import QtPositioning 5.2
import Ubuntu.Components 1.1
import Location 1.0 as UserLocation
import "../alarm"
import "../components"
import "../upstreamcomponents"
import "../worldclock"

PageWithBottomEdge {
    id: _clockPage
    objectName: "clockPage"

    // Property to keep track of the clock mode
    property alias isDigital: clock.isDigital

    // Property to keep track of the clock time
    property var clockTime: new Date()

    property var alarmModel

    flickable: null
    bottomEdgeTitle: alarmUtils.set_bottom_edge_title(alarmModel, clockTime)

    Component.onCompleted: {
        console.log("[LOG]: Clock Page loaded")
        _clockPage.setBottomEdgePage(Qt.resolvedUrl("../alarm/AlarmPage.qml"), {})
    }

    AlarmUtils {
        id: alarmUtils
    }

    PositionSource {
        id: geoposition

        // Property to store the time of the last GPS location update
        property var lastUpdate

        readonly property real userLongitude: position.coordinate.longitude

        readonly property real userLatitude: position.coordinate.latitude

        active: true
        updateInterval: 1000

        onSourceErrorChanged: {
            // Stop querying user location if location service is not available
            if (sourceError !== PositionSource.NoError) {
                console.log("[Source Error]: Location Service Error")
                geoposition.stop()
            }
        }

        onPositionChanged: {
            // Do not accept an invalid user location
            if(!position.longitudeValid || !position.latitudeValid) {
                return
            }

            /*
             Stop querying for the user location if it is found to be
             the same as the one stored in the app setting database
            */
            if (userLongitude === userLocationDocument.contents.long ||
                    userLatitude === userLocationDocument.contents.lat) {
                if (geoposition.active) {
                    console.log("[LOG]: Stopping geolocation update service")
                    geoposition.stop()
                }
                return
            }

            else {
                // Retrieve user location online after receiving the user's lat and lng.
                userLocation.setSource(position.coordinate.latitude, position.coordinate.longitude)
            }
        }
    }

    Connections {
        target: clockApp
        onApplicationStateChanged: {
            /*
             If Clock App is brought from background after more than 30 mins,
             query the user location to ensure it is up to date.
            */
            if(applicationState
                    && Math.abs(clock.analogTime - geoposition.lastUpdate) > 1800000) {
                if(!geoposition.active)
                    geoposition.start()
            }

            else if (!applicationState) {
                geoposition.lastUpdate = clock.analogTime
            }
        }
    }

    UserLocation.Location {
        id: userLocation

        function setSource(lat, lng) {
            var url = String("%1%2%3%4%5")
            .arg("http://api.geonames.org/findNearbyPlaceNameJSON?lat=")
            .arg(lat)
            .arg("&lng=")
            .arg(lng)
            .arg("&username=krnekhelesh&style=full")

            console.log("[LOG]: Searching online for user location at " + url)

            userLocation.source =  url;
        }

        onLocationChanged: {
            var locationData = JSON.parse
                    (JSON.stringify(userLocationDocument.contents))

            locationData.lat = geoposition.userLatitude
            locationData.long = geoposition.userLongitude
            locationData.location = userLocation.location

            userLocationDocument.contents = locationData

            /*
             Stop querying the user coordinates once the user location has been
             determined and saved to disk
           */
            if(geoposition.active) {
                console.log("[LOG]: Stopping geolocation update service")
                geoposition.stop()
            }

        }
    }

    Flickable {
        id: _flickable

        Component.onCompleted: otherElementsStartUpAnimation.start()

        onFlickStarted: {
            forceActiveFocus()
        }

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: clock.height + date.height + locationRow.height
                       + worldCityColumn.height + addWorldCityButton.height
                       + units.gu(16)

        AbstractButton {
            id: settingsIcon
            objectName: "settingsIcon"

            onClicked: {
                mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettingsPage.qml"))
            }

            width: units.gu(5)
            height: width
            opacity: 0

            anchors {
                top: parent.top
                topMargin: units.gu(6)
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

        MainClock {
            id: clock
            objectName: "clock"

            Component.onCompleted: {
                geoposition.lastUpdate = analogTime
            }

            analogTime: clockTime

            anchors {
                verticalCenter: parent.top
                verticalCenterOffset: units.gu(20)
                horizontalCenter: parent.horizontalCenter
            }
        }

        Label {
            id: date

            anchors {
                top: parent.top
                topMargin: units.gu(36)
                horizontalCenter: parent.horizontalCenter
            }

            text: clock.analogTime.toLocaleDateString()
            opacity: settingsIcon.opacity
            fontSize: "xx-small"
        }

        Row {
            id: locationRow
            objectName: "locationRow"

            opacity: settingsIcon.opacity
            spacing: units.gu(1)

            anchors {
                top: date.bottom
                topMargin: units.gu(1)
                horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: locationIcon
                source: "../graphics/Location_Pin.png"
                width: units.gu(1.2)
                height: units.gu(2.2)
            }

            Label {
                id: location
                objectName: "location"

                fontSize: "medium"
                anchors.verticalCenter: locationIcon.verticalCenter
                color: UbuntuColors.midAubergine

                text: {
                    if (userLocationDocument.contents.location === "Null") {
                        if(geoposition.sourceError !== PositionSource.NoError) {
                            return i18n.tr("Location Service Error!")
                        } else {
                            return i18n.tr("Retrieving location...")
                        }
                    }

                    else {
                        return userLocationDocument.contents.location
                    }
                }
            }
        }

        UserWorldCityList {
            id: worldCityColumn
            objectName: "worldCityColumn"

            opacity: settingsIcon.opacity
            anchors {
                top: locationRow.bottom
                topMargin: units.gu(4)
            }
        }

        AddWorldCityButton {
            id: addWorldCityButton
            objectName: "addWorldCityButton"

            opacity: settingsIcon.opacity
            anchors {
                top: worldCityColumn.bottom
                topMargin: units.gu(1)
            }
        }

        ParallelAnimation {
            id: otherElementsStartUpAnimation

            PropertyAnimation {
                target: settingsIcon
                property: "anchors.topMargin"
                from: units.gu(6)
                to: units.gu(2)
                duration: 900
            }

            PropertyAnimation {
                target: settingsIcon
                property: "opacity"
                from: 0
                to: 1
                duration: 900
            }

            PropertyAnimation {
                target: date
                property: "anchors.topMargin"
                from: units.gu(36)
                to: units.gu(40)
                duration: 900
            }
        }
    }
}
