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
import U1db 1.0 as U1db
import QtPositioning 5.2
import Ubuntu.Components 1.2
import GeoLocation 1.0
import "../components"
import "../worldclock"

Item {
    id: _clockPage
    objectName: "clockPage"

    // Property to keep track of the clock mode
    property alias isDigital: clock.isDigital

    // Property to keep track of the clock time
    property var clockTime: new Date()

    // Property to keep track of app cold start status
    property alias isColdStart: clock.isColdStart

    Component.onCompleted: {
        console.log("[LOG]: Clock Page loaded")
        otherElementsStartUpAnimation.start()
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

                // If this is the first time, then set location as Denied
                // to indicate user denying clock app location access.
                if (userLocationDocument.contents.location === "Null") {
                    var locationData = JSON.parse
                            (JSON.stringify(userLocationDocument.contents))

                    locationData.location = "Denied"
                    userLocationDocument.contents = locationData
                }
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

    GeoLocation {
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

    MainClock {
        id: clock
        objectName: "clock"

        Component.onCompleted: {
            geoposition.lastUpdate = analogTime
        }

        analogTime: clockTime

        anchors {
            verticalCenter: parent.top
            verticalCenterOffset: units.gu(18)
            horizontalCenter: parent.horizontalCenter
        }
    }

    Label {
        id: date

        anchors {
            top: parent.top
            topMargin: units.gu(41)
            horizontalCenter: parent.horizontalCenter
        }

        text: clock.analogTime.toLocaleDateString()

        opacity: 0
        color: locationRow.visible ? Theme.palette.normal.baseText : UbuntuColors.midAubergine
        fontSize: "medium"
    }

    Row {
        id: locationRow
        objectName: "locationRow"

        opacity: date.opacity
        spacing: units.gu(1)
        visible: location.text !== "Null" && location.text !== "Denied"

        anchors {
            top: date.bottom
            topMargin: units.gu(1)
            horizontalCenter: parent.horizontalCenter
        }

        Icon {
            id: locationIcon
            name: "location"
            height: units.gu(2.2)
            color: "Grey"
        }

        Label {
            id: location
            objectName: "location"

            fontSize: "medium"
            anchors.verticalCenter: locationIcon.verticalCenter
            color: UbuntuColors.midAubergine

            text: {
                if (userLocationDocument.contents.location === "Null"
                        || userLocationDocument.contents.location === "Denied"
                        && geoposition.sourceError === PositionSource.NoError) {
                    return i18n.tr("Retrieving location...")
                }

                else {
                    return userLocationDocument.contents.location
                }
            }
        }
    }

    MouseArea {
        id: worldCityListMouseArea

        preventStealing: true

        anchors {
            top: locationRow.bottom
            topMargin: units.gu(2)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        UserWorldCityList {
            id: worldCityColumn
            opacity: date.opacity

            footer: AddWorldCityButton {
                id: addWorldCityButton
                objectName: "addWorldCityButton"
            }
        }
    }

    ParallelAnimation {
        id: otherElementsStartUpAnimation

        PropertyAnimation {
            target: headerRow
            property: "anchors.topMargin"
            from: units.gu(4)
            to: 0
            duration: 900
        }

        PropertyAnimation {
            target: headerRow
            property: "opacity"
            from: 0
            to: 1
            duration: 900
        }

        PropertyAnimation {
            target: date
            property: "opacity"
            from: 0
            to: 1
            duration: 900
        }

        PropertyAnimation {
            target: date
            property: "anchors.topMargin"
            from: units.gu(41)
            to: units.gu(37)
            duration: 900
        }
    }
}
