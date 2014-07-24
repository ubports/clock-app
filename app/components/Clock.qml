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

import QtQuick 2.0
import Ubuntu.Components 1.1
import "Utils.js" as Utils

ClockCircle {
    id: _outerCircle

    // Property to set the analog time
    property var analogTime: new Date()

    // Property to set the digital time label
    property string time: Qt.formatTime(analogTime)

    // Property to keep track of the clock mode
    property alias isDigital: clockModeFlipable.isDigital

    property int innerCircleWidth
    property int fontSize
    property int periodFontSize
    property bool isMainClock: false

    property alias digitalModeLoader: _digitalModeLoader
    property alias analogModeLoader: _analogModeLoader

    // Sets the style to outer circle
    isOuter: true

    Shadow {
        id: upperShadow
        rotation: 0
        width: innerCircleWidth - units.gu(0.5)
        z: clockModeFlipable.z + 2
        anchors.centerIn: clockModeFlipable
        anchors.verticalCenterOffset: -width/4
    }

    Shadow {
        id: bottomShadow
        rotation: 180
        width: upperShadow.width
        z: clockModeFlipable.z + 2
        anchors.centerIn: clockModeFlipable
        anchors.verticalCenterOffset: width/4
    }

    Loader {
        id: analogShadow
        z: clockModeFlipable.isDigital ? clockModeFlipable.z + 1
                                       : clockModeFlipable.z + 3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: clockModeFlipable.bottom
    }

    Loader {
        id: digitalShadow
        z: clockModeFlipable.isDigital ? clockModeFlipable.z + 3
                                       : clockModeFlipable.z + 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: clockModeFlipable.bottom
    }

    Flipable {
        id: clockModeFlipable

        // Property to switch between digital and analog mode
        property bool isDigital: false

        width: innerCircleWidth
        height: width
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

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clockFlipAnimation.start()
            }
        }

        onStateChanged: {
            if(!isMainClock) {
                console.log(state)
                clockFlipAnimation.start()
            }
        }
    }

    /*
      The clockFlipAnimation is executed during every switch between
      analog and digital modes.
    */
    SequentialAnimation {
        id: clockFlipAnimation

        ScriptAction {
            script: {
                analogShadow.setSource("AnalogShadow.qml",
                                       {
                                           "shadowWidth": units.gu(23),
                                           "shadowTimeFontSize": units.dp(62),
                                           "shadowPeriodFontSize": units.dp(12),
                                       })
                digitalShadow.setSource("DigitalShadow.qml",
                                        {
                                            "shadowWidth": units.gu(23),
                                            "shadowTimeFontSize": units.dp(62),
                                            "shadowPeriodFontSize": units.dp(12),
                                        })

                if (clockModeFlipable.isDigital) {
                    digitalShadow.item.isAnalog = true
                }
                else {
                    analogShadow.item.isDigital = true
                }
            }
        }

        PropertyAnimation {
            target: bottomShadow
            property: "opacity"
            duration: 333
            from: 1
            to: 0
        }

        PropertyAnimation {
            target: upperShadow
            property: "opacity"
            duration: 333
            from: 0
            to: 1
        }

        /*
          Script to clean up after the flip animation is complete which
          involves (in the order listed below)
            - Hiding the shadows
            - Toggling main clock mode and unloading the hidden mode
            - Unloading the analog and digital shadow required to show the
              paper effect
        */

        ScriptAction {
            script: {
                upperShadow.opacity = bottomShadow.opacity = 0
                clockModeFlipable.isDigital = !clockModeFlipable.isDigital

                if (clockModeFlipable.isDigital) {
                    Utils.log(debugMode, "Loaded Digital mode...")
                    _digitalModeLoader.setSource(
                                "DigitalMode.qml",
                                {
                                    "width": _outerCircle.innerCircleWidth,
                                    "timeFontSize": _outerCircle.fontSize,
                                    "timePeriodFontSize": _outerCircle.periodFontSize
                                })
                    Utils.log(debugMode, "Unloaded Analog mode...")
                    _analogModeLoader.source = ""
                }
                else {
                    Utils.log(debugMode, "Loaded Analog mode..")
                    _analogModeLoader.setSource(
                                "AnalogMode.qml",
                                {
                                    "width": _outerCircle.innerCircleWidth
                                })
                    Utils.log(debugMode, "Unloaded Digital mode...")
                    _digitalModeLoader.source = ""
                }

                analogShadow.source = digitalShadow.source = ""

                if(isMainClock) {
                    var isDigitalSetting = JSON.parse(JSON.stringify(clockModeDocument.contents))
                    isDigitalSetting.digitalMode = isDigital
                    clockModeDocument.contents = isDigitalSetting
                }
            }
        }
    }
}
