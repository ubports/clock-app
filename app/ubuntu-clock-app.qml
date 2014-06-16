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
    applicationName: "com.ubuntu.clock"

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
          Update Clock time immediately when the clock app is brought from suspend
          instead of waiting for the next minute to update.
        */
        if(applicationState)
            clockPage.updateTime()
    }

    Background {}

    Timer {
        id: clockTimer

        interval: 60000
        repeat: true
        running: true
        onTriggered: clockPage.updateTime()
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

            bottomEdgeTitle: i18n.tr("%1 alarms").arg(alarmModel.count)

            bottomEdgePageComponent: AlarmPage {
                anchors.fill: parent
                anchors.topMargin: active ? units.gu(9.5) : units.gu(0)
            }
        }
    }
}

