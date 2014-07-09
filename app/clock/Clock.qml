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

ClockCircle {
    id: _outerCircle

    // Property to set the digital time label
    property string time: Qt.formatTime(new Date())
    
    isOuter: true

    Component.onCompleted: clockOpenAnimation.start()
    
    ParallelAnimation {
        id: clockOpenAnimation

        /*
          This animation and script is only executed ONCE when the clock app is
          opened.
        */
        
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
                    _digitalModeLoader.item.animationTimer.start()
                }
                else {
                    _analogModeLoader.source = Qt.resolvedUrl("AnalogMode.qml")
                    _analogModeLoader.item.animationTimer.start()
                }
            }
        }
    }

    Flipable {
        id: clockModeFlipable

        anchors.centerIn: parent
        width: units.gu(23)
        height: units.gu(23)

        property bool isDigital: false

        front: Loader {
            id: _analogModeLoader
            parent: clockModeFlipable
            anchors.centerIn: parent

            onSourceChanged: {
                if(source !== "") {
                    item.width = units.gu(23)
                }
            }
        }

        back: Loader {
            id: _digitalModeLoader
            parent: clockModeFlipable
            anchors.centerIn: parent

            onSourceChanged: {
                if(source !== "") {
                    item.width = units.gu(23)
                    item.digitalTimeSize = units.dp(62)
                    item.digitalTimePeriodSize = units.dp(12)
                }
            }
        }

        transform: Rotation {
            id: rotation
            origin.x: clockModeFlipable.width/2
            origin.y: clockModeFlipable.height/2
            axis.x: 1; axis.y: 0; axis.z: 0
            angle: 0    // the default angle
        }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: clockModeFlipable.isDigital
        }

        transitions: Transition {
            SequentialAnimation {
                ScriptAction {
                    script: clockModeFlipable.isDigital
                            ? _digitalModeLoader.source = Qt.resolvedUrl("DigitalMode.qml")
                            : _analogModeLoader.source = ""
                }

                NumberAnimation {
                    target: rotation
                    property: "angle"
                    duration: 1000
                }

                ScriptAction {
                    script: clockModeFlipable.isDigital
                            ? _analogModeLoader.source = Qt.resolvedUrl("AnalogMode.qml")
                            : _digitalModeLoader.source = ""
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.isDigital = !parent.isDigital
        }
    }
}
