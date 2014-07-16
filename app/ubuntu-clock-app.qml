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
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import "clock"
import "alarm"
import "components"
import "components/Utils.js" as Utils

MainView {
    id: clockApp

    // Property to store the state of an application (active or suspended)
    property bool applicationState: Qt.application.active

    // Property to enable/disable the debug mode to show more console output
    property bool debugMode: true

    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "clock"

    // applicationName for click packages (used as an unique app identifier)
    applicationName: "com.ubuntu.clock.devel"

    /*
      This property enables the application to change orientation when the
      device is rotated. This has been set to false since we are currently
      only focussing on the phone interface.
    */
    automaticOrientation: false

    /*
      The width and height defined below are the same dimension used by the
      designers in the clock visual spec.
    */
    width: units.gu(40)
    height: units.gu(70)

    backgroundColor: "#F5F5F5"

    useDeprecatedToolbar: false

    onApplicationStateChanged: {
        /*
          Update Clock time immediately when the clock app is brought from
          suspend instead of waiting for the next minute to update.
        */
        if(applicationState)
            clockPage.updateTime()
    }

    Background {}

    Timer {
        id: clockTimer

        interval: clockPage.isDigital ? 60000 : 1000
        repeat: true
        running: true
        onTriggered: clockPage.updateTime()
    }

    // Database to store the user preferences locally
    U1db.Database {
        id: clockDB
        path: "user-preferences"
    }

    // Document to store app settings data
    U1db.Document {
        id: clockModeDocument
        create: true
        database: clockDB
        docId: "clockModeDocument"
        defaults: { "digitalMode": false }
    }

    AlarmModel {
        id: alarmModel
        Component.onCompleted: Utils.log(debugMode, "Alarm Database loaded")
    }

    PageStack {
        id: mainStack

        Component.onCompleted: push(clockPage)

        ClockPage {
            id: clockPage

            /*
              #FIXME: When the SDK support hiding the header, then enable the
              clock page title. This will then set the correct window title on
              the desktop.

              title: "Clock"
            */

            /*
              #TODO: The bottom edge title should reflect the time to the next
              alarm. For instance it should read "Next alarm in 9h23m".
            */
            bottomEdgeTitle: i18n.tr("Next Alarm in ..")
            bottomEdgePageComponent: AlarmPage {}
        }
    }
}

