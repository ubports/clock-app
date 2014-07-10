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

ClockCircle {
    id: _outerCircle

    // Property to set the analog time
    property var analogTime: new Date()

    // Property to set the digital time label
    property string time: Qt.formatTime(analogTime)

    // Property to trigger the start up animations
    property bool isStartup: true

    Component.onCompleted: {
        clockOpenAnimation.start()
    }

    // Sets the style to outer circle
    isOuter: true

    Flipable {
        id: clockModeFlipable

        // Property to switch between digital and analog mode
        property bool isDigital: false

        width: units.gu(23)
        height: units.gu(23)
        anchors.centerIn: parent

        front: Loader {
            id: _analogModeLoader
            anchors.centerIn: parent
        }

        back: Loader {
            id: _digitalModeLoader
            anchors.centerIn: parent
        }

        transform: Rotation {
            id: rotation
            origin.x: clockModeFlipable.width/2
            origin.y: clockModeFlipable.height/2
            axis.x: 1; axis.y: 0; axis.z: 0
            angle: 0
        }

        states: State {
            name: "Digital"
            when: clockModeFlipable.isDigital
            PropertyChanges {
                target: rotation
                angle: 180
            }
        }

        transitions: Transition {

            /*
              Rotation animation for switching between analog and digital modes.
              It is however disabled during app startup.
            */
            enabled: !isStartup

            SequentialAnimation {
                ScriptAction {
                    script: {
                        if (clockModeFlipable.isDigital) {
                            Utils.log(debugMode, "Loading Digital mode...")
                            _digitalModeLoader.setSource(
                                        "DigitalMode.qml",
                                        {
                                            "width": units.gu(23),
                                            "timeFontSize": units.dp(62),
                                            "timePeriodFontSize": units.dp(12)
                                        })
                        }
                        else {
                            Utils.log("Loading Analog mode..")
                            _analogModeLoader.setSource(
                                        "AnalogMode.qml",
                                        {
                                            "width": units.gu(23)
                                        })
                        }
                    }
                }

                NumberAnimation {
                    target: rotation
                    property: "angle"
                    duration: 1000
                }

                ScriptAction {
                    script: {
                        if (clockModeFlipable.isDigital) {
                            Utils.log(debugMode, "Unloading Analog mode...")
                            _analogModeLoader.source = ""
                        }
                        else {
                            Utils.log(debugMode, "Unloading Digital mode...")
                            _digitalModeLoader.source = ""
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.isDigital = !parent.isDigital
        }
    }

    SequentialAnimation {
        id: clockOpenAnimation

        /*
          This animation and script is only executed once when the clock app is
          opened.
        */

        ParallelAnimation {

            PropertyAnimation {
                target: _outerCircle
                property: "width"
                to: units.gu(32)
                duration: 900
            }

            ScriptAction {
                script: {
                    if (clockModeFlipable.isDigital) {
                        _digitalModeLoader.source = Qt.resolvedUrl("DigitalMode.qml")
                        _digitalModeLoader.item.startAnimation()
                    }
                    else {
                        _analogModeLoader.source = Qt.resolvedUrl("AnalogMode.qml")
                        _analogModeLoader.item.startAnimation()
                    }
                }
            }
        }

        ScriptAction {
            script: isStartup = false
        }
    }
}
