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
import DateTime 1.0
import Ubuntu.Components 1.1
import "../components"

Clock {
    id: mainClock

    fontSize: units.dp(62)
    periodFontSize: units.dp(12)
    innerCircleWidth: units.gu(23)

    isMainClock: true

    Connections {
        target: clockApp
        onApplicationStateChanged: {
            localTimeSource.update()
        }
    }

    DateTime {
        id: localTimeSource
        updateInterval: 1000
    }

    /*
     Create a new Date() object and pass the date, month, year, hour, minute
     and second received from the DateTime plugin manually to ensure the
     timezone info is set correctly.

     Javascript Month is 0-11 while QDateTime month is 1-12. Hence the -1
     is required.
    */

    /*
      FIXME: When the upstream QT bug at
      https://bugreports.qt-project.org/browse/QTBUG-40275 is fixed it will be
      possible to receive a datetime object directly instead of using this hack.
    */
    analogTime: new Date
                (
                    localTimeSource.localDateString.split(":")[0],
                    localTimeSource.localDateString.split(":")[1]-1,
                    localTimeSource.localDateString.split(":")[2],
                    localTimeSource.localTimeString.split(":")[0],
                    localTimeSource.localTimeString.split(":")[1],
                    localTimeSource.localTimeString.split(":")[2],
                    localTimeSource.localTimeString.split(":")[3]
                )
    time: Qt.formatTime(analogTime)

    isDigital: clockModeDocument.contents.digitalMode ? true : false

    Component.onCompleted: {
        clockOpenAnimation.start()
    }

    /*
      The clockOpenAnimation is only executed once when the clock app is
      opened.
    */
    SequentialAnimation {
        id: clockOpenAnimation

        /*
          On startup, first ensure that the correct mode is loaded into memory,
          and then only proceed to start the startup animation.
        */

        ScriptAction {
            script: {
                if (isDigital) {
                    digitalModeLoader.setSource
                            ("../components/DigitalMode.qml",
                             {
                                 "maxWidth": innerCircleWidth,
                                 "maxTimeFontSize": fontSize,
                                 "maxPeriodFontSize": periodFontSize,
                             })
                }
                else {
                    analogModeLoader.setSource
                            ("../components/AnalogMode.qml",
                             {
                                 "maxWidth": innerCircleWidth,
                                 "showSeconds": isMainClock
                             })
                }
            }
        }

        ParallelAnimation {
            PropertyAnimation {
                target: mainClock
                property: "width"
                to: units.gu(32)
                duration: 900
            }

            ScriptAction {
                script: {
                    if (isDigital) {
                        digitalModeLoader.item.startAnimation()
                    }
                    else {
                        analogModeLoader.item.startAnimation()
                    }
                }
            }
        }
    }
}
