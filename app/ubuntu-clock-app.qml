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
import WorldClock 1.0
import U1db 1.0 as U1db
import Alarm 1.0
import Ubuntu.Components 1.3
import "components"
import QtQuick.Window 2.2

Window {
    id: rootWindow

    // Property to store the state of an application (active or suspended)
    property bool applicationState: Qt.application.active

    /*
      The width and height defined below are the same dimension used by the
      designers in the clock visual spec.
    */

    minimumWidth: units.gu(40)
    minimumHeight: units.gu(70)
    maximumWidth: units.gu(50)

    onApplicationStateChanged: {
        localTimeSource.update()
        Date.timeZoneUpdated()
        /*
         Reload the alarm model when the clock app gains focus to refresh
         the alarm page UI in the case of alarm notifications.
        */
        if(applicationState && !mainPage.isColdStart && (mainStack.currentPage.isMainPage
                                                         || mainStack.currentPage.isAlarmPage)) {
            console.log("[LOG]: Alarm Database unloaded")
            alarmModelLoader.source = ""
            alarmModelLoader.source = Qt.resolvedUrl("alarm/AlarmModelComponent.qml")
        }
    }

    MainView {
        id: clockApp

        // objectName for functional testing purposes (autopilot-qt5)
        objectName: "clockMainView"

        // applicationName for click packages (used as an unique app identifier)
        applicationName: "com.ubuntu.clock"

        backgroundColor: "#FFFFFF"

        anchors.fill: parent

        anchorToKeyboard: true

        // Database to store the user preferences locally
        U1db.Database {
            id: clockDB
            path: "user-preferences"
        }

        // Document to store clock mode chosen by user
        U1db.Document {
            id: clockModeDocument
            create: true
            database: clockDB
            docId: "clockModeDocument"
            defaults: { "digitalMode": false }
        }

        U1db.Document {
            id: userLocationDocument
            create: true
            database: clockDB
            docId: "userLocationDocument"
            defaults: { "lat": "NaN", "long": "Nan", "location": "Null" }
        }

        DateTime {
            id: localTimeSource
            updateInterval: 1000
        }

        AlarmSound {
            id: alarmSoundHelper
            // Create CustomSounds directory if it does not exist on app startup
            Component.onCompleted: createCustomAlarmSoundDirectory()
        }

        PageStack {
            id: mainStack

            Component.onCompleted: push(mainPage)

            MainPage {
                id: mainPage

                readonly property bool isMainPage: true

                Loader {
                    id: alarmModelLoader
                    asynchronous: false
                }

                alarmModel: alarmModelLoader.item
                /*
               FIXME: When the upstream QT bug at
               https://bugreports.qt-project.org/browse/QTBUG-40275 is fixed
               it will be possible to receive a datetime object directly for notLocalizedDateTimeString variable.
            */
                notLocalizedDateTimeString: localTimeSource.notLocalizedCurrentDateTimeString
                localizedTimeString: localTimeSource.localizedCurrentTimeString
                localizedDateString: localTimeSource.localizedCurrentDateString
            }
        }
    }
}

