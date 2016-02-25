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
import Ubuntu.Components 1.3

/*
 Generic clock component which has a digital and analog mode. A flip animation
 is shown when switching clock modes. This components is used by the main
 clock and the world clock list items.

 The component follows a parent-child model where certain functions are
 available only if used by a parent. You can set parent using the isMainClock
 variable. Some functions which are provided only to the parent are listed
 below,

 - Ability to switch clock modes by tapping on the center. As per design, only
   main clock app should allow switching mode by tapping at the center

 - Modify the user preference settings document to reflect the currently chosen
   clock mode. We don't want every child element modifying the file unnecessarily

 - Disable the clock hand in the child elements (world clock) as per the design
   spec.
*/
Item {
    id: _clockContainer

    // String with not localized date and time in format "yyyy:MM:dd:hh:mm:ss", eg.: "2016:10:05:16:10:15"
    property string notLocalizedDateTimeString

    // String with localized time, eg.: "4:10 PM"
    property string localizedTimeString

    // String with localized date, eg.: "Thursday, 17 September 2016"
    property string localizedDateString

    // Property to keep track of the clock mode
    property alias isDigital: clockModeFlipable.isDigital

    // Properties to set the dimension of the clock like the font size, width etc
    property int fontSize
    property int periodFontSize
    property int innerCircleWidth

    // Property to set if the component is the parent or the child
    property bool isMainClock: false

    // Properties to expose the analog and digital modes
    property alias digitalModeLoader: _digitalModeLoader
    property alias analogModeLoader: _analogModeLoader

    // Signal which is triggered whenever the flip animation is started
    signal triggerFlip();

    function flipClock() {
        clockFlipAnimation.start()
    }

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
            enabled: isMainClock
            anchors.fill: parent
            onClicked: {
                forceActiveFocus()
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
                triggerFlip()
                analogShadow.setSource
                        ("AnalogShadow.qml",
                         {
                             "shadowWidth": innerCircleWidth,
                             "shadowTimeFontSize": fontSize,
                             "shadowPeriodFontSize": periodFontSize,
                             "showSeconds": isMainClock
                         })

                digitalShadow.setSource
                        ("DigitalShadow.qml",
                         {
                             "shadowWidth": innerCircleWidth,
                             "shadowTimeFontSize": fontSize,
                             "shadowPeriodFontSize": periodFontSize,
                             "showSeconds": isMainClock
                         })

                if (clockModeFlipable.isDigital) {
                    digitalShadow.item.isAnalog = true
                }
                else {
                    analogShadow.item.isDigital = true
                }
            }
        }

        UbuntuNumberAnimation {
            target: bottomShadow
            property: "opacity"
            duration: 166
            from: 1
            to: 0
        }

        UbuntuNumberAnimation {
            target: upperShadow
            property: "opacity"
            duration: 166
            from: 0
            to: 1
        }

        /*
          Script to clean up after the flip animation is complete which
          involves (in the order listed below)
            - Hiding the shadows
            - Toggling clock mode and unloading the hidden mode
            - Unloading the analog and digital shadow required to show the
              paper effect
        */

        ScriptAction {
            script: {
                upperShadow.opacity = bottomShadow.opacity = 0
                isDigital = !isDigital

                if (isDigital) {
                    _digitalModeLoader.setSource
                            ("DigitalMode.qml",
                             {
                                 "width": innerCircleWidth,
                                 "timeFontSize": fontSize,
                                 "timePeriodFontSize": periodFontSize
                             })
                    _analogModeLoader.source = ""
                }
                else {
                    _analogModeLoader.setSource
                            ("AnalogMode.qml",
                             {
                                 "width": innerCircleWidth,
                                 "showSeconds": isMainClock
                             })
                    _digitalModeLoader.source = ""
                }

                analogShadow.source = digitalShadow.source = ""

                if(isMainClock) {
                    var isDigitalSetting = JSON.parse
                            (JSON.stringify(clockModeDocument.contents))
                    isDigitalSetting.digitalMode = isDigital
                    clockModeDocument.contents = isDigitalSetting
                }
            }
        }
    }
}
