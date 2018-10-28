/*
 * Copyright (C) 2014-2016 Canonical Ltd
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
import Ubuntu.Components 1.3
import WorldClock 1.0
import "../components"
import "../worldclock"

Item {
    id: _clockPage
    objectName: "clockPage"

    signal startupAnimationEnd()

    // Property to keep track of the clock mode
    property alias isDigital: clock.isDigital

    // String with not localized date and time in format "yyyy:MM:dd:hh:mm:ss", eg.: "2016:10:05:16:10:15"
    property string notLocalizedClockTimeString

    // String with localized time, eg.: "4:10 PM"
    property string localizedClockTimeString

    // String with localized date, eg.: "Thursday, 17 September 2016"
    property string localizedClockDateString

    // Property to keep track of app cold start status
    property alias isColdStart: clock.isColdStart

    function get_current_utc_time() {
        var localDate = new Date()
        // FIXME Date() is not working correctly in runtime, when timezone is changed.
        // To avoid issues with Date(), clock app needs to be restarted every timezone is changed
        return new Date(localDate.getUTCFullYear(),
                        localDate.getUTCMonth(),
                        localDate.getUTCDate(),
                        localDate.getUTCHours(),
                        localDate.getUTCMinutes(),
                        localDate.getUTCSeconds(),
                        localDate.getUTCMilliseconds())
    }

    Component.onCompleted: {
        console.log("[LOG]: Clock Page loaded")
        otherElementsStartUpAnimation.start()
    }

    // FIXME: workaround necessary because PositionSource blocks for over 1000ms
    // when becoming active the first time. In order not to slowdown startup we
    // delay requesting the location until the clock app is loaded.
    //
    // Ref.: https://bugs.launchpad.net/platform-api/+bug/1606156
    Connections {
        target: otherElementsStartUpAnimation
        onStopped: geoposition.active = true
    }

    PositionSource {
        id: geoposition

        // Property to store the time of the last GPS location update
        property var lastUpdate

        readonly property real userLongitude: position.coordinate.longitude

        readonly property real userLatitude: position.coordinate.latitude

        active: false
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
        target: rootWindow
        onApplicationStateChanged: {
            /*
             If Clock App is brought from background after more than 30 mins,
             query the user location to ensure it is up to date.
            */
            // FIXME Date() is not working correctly in runtime, when timezone is changed.
            // To avoid issues with Date(), clock app needs to be restarted every timezone is changed
            var currentUTCTime = get_current_utc_time()
            if(applicationState
                    && Math.abs(currentUTCTime - geoposition.lastUpdate) > 1800000) {
                if(!geoposition.active) {
                    console.log("[LOG]: Starting geolocation update service at UTC time: " + currentUTCTime)
                    geoposition.start()
                }
            } else if (!applicationState) {
                geoposition.lastUpdate = currentUTCTime
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
            geoposition.lastUpdate = get_current_utc_time()
        }

        notLocalizedDateTimeString: notLocalizedClockTimeString
        localizedTimeString: localizedClockTimeString
        localizedDateString: localizedClockDateString

        anchors {
            verticalCenter: parent.top
            verticalCenterOffset: height/2 + units.gu(4)
            horizontalCenter: parent.horizontalCenter
        }
    }

    Label {
        id: date

        anchors {
            top: clock.bottom
            horizontalCenter: parent.horizontalCenter
        }

        text: clock.localizedDateString
        textSize: Label.Medium
        opacity: 0
        color: Theme.palette.normal.backgroundSecondaryText
    }

    Row {
        id: locationRow
        objectName: "locationRow"

        opacity: date.opacity
        spacing: units.gu(1)
        visible: location.text !== "Null" && location.text !== "Denied"

        anchors {
            top: date.bottom
            topMargin: units.gu(2)
            horizontalCenter: parent.horizontalCenter
        }

        Icon {
            id: locationIcon
            name: "location"
            height: units.gu(2.2)
            color: location.color
            asynchronous: true
        }

        Label {
            id: location
            objectName: "location"

            color: Theme.palette.normal.backgroundSecondaryText
            anchors.verticalCenter: locationIcon.verticalCenter

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

    Rectangle {
        id: divider
        width: parent.width
        height: 1
        color: UbuntuColors.silk
        anchors {
            top: locationRow.bottom
            topMargin: units.gu(3)
        }
    }

    UserWorldCityList {
        id: worldCityColumn
        opacity: date.opacity

        anchors {
            top: divider.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        footer: AddWorldCityButton {
            id: addWorldCityButton
            objectName: "addWorldCityButton"
        }
    }

    NestedListviewsHack {
        id:worldCityHack
        z:10
        parentListView : listview
        nestedListView : worldCityColumn
    }


    ParallelAnimation {
        id: otherElementsStartUpAnimation

        onStopped:startupAnimationEnd();

        UbuntuNumberAnimation {
            target: date
            property: "opacity"
            from: 0
            to: 1
            duration: UbuntuAnimation.SlowDuration
        }

        UbuntuNumberAnimation {
            target: date
            property: "anchors.topMargin"
            from: units.gu(29)
            to: units.gu(4)
            duration: UbuntuAnimation.SlowDuration
        }
    }
}
