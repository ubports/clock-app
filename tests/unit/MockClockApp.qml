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
import WorldClock 1.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.2
import "../../app"
import "../../app/components"
import "../../app/clock"

/*
 This file is meant to create a fake but fully fleshed clock app with its
 own database and settings. This will avoid messing with the user data while
 running the tests.
*/

MainView {
    id: clockApp

    // Property to store the state of an application (active or suspended)
    property bool applicationState: Qt.application.active

    width: units.gu(40)
    height: units.gu(70)
    applicationName: "com.ubuntu.fakeclock.test"

    U1db.Database {
        id: clockDB
        path: "user-preferences"
    }

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

    PageStack {
        id: mainStack
        objectName: "pageStack"

        Component.onCompleted: push(mainPage)

        MainPage {
            id: mainPage

            Loader {
                id: alarmModelLoader
                asynchronous: false
            }

            alarmModel: alarmModelLoader.item
            bottomEdgeEnabled: alarmModelLoader.status === Loader.Ready && alarmModelLoader.item.isReady && isClockPage
            notLocalizedDateTimeString: localTimeSource.notLocalizedCurrentDateTimeString
            localizedTimeString: localTimeSource.localizedCurrentTimeString
            localizedDateString: localTimeSource.localizedCurrentDateString
        }
    }
}
