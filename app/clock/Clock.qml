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
    property alias hours: _digitalTimeHours.text
    property alias minutes: _digitalTimeMinutes.text
    
    isOuter: true

    Component.onCompleted: clockOpenAnimation.start()
    
    ParallelAnimation {
        id: clockOpenAnimation
        
        PropertyAnimation {
            target: _outerCircle
            property: "width"
            to: units.gu(32)
            duration: 900
        }
        
        ScriptAction {
            script: animationTimer.start()
        }
    }
    
    ClockCircle {
        id: _innerCircle

        anchors.centerIn: parent
        
        Timer {
            id: animationTimer
            interval: 200
            repeat: false
            onTriggered: _innerCircleAnimation.start()
        }
        
        ParallelAnimation {
            id: _innerCircleAnimation
            
            PropertyAnimation {
                target: _innerCircle
                property: "width"
                to: units.gu(23)
                duration: 900
            }
            
            PropertyAnimation {
                target: _digitalTimeHours
                property: "font.pixelSize"
                to: units.dp(62)
                duration: 900
            }

            PropertyAnimation {
                target: _digitalTimeDivider
                property: "font.pixelSize"
                to: units.dp(62)
                duration: 900
            }

            PropertyAnimation {
                target: _digitalTimeMinutes
                property: "font.pixelSize"
                to: units.dp(62)
                duration: 900
            }
        }
        
        Label {
            id: _digitalTimeHours
            anchors {
                right: _digitalTimeDivider.left
                verticalCenter: parent.verticalCenter
            }
            color: UbuntuColors.midAubergine
            opacity: font.pixelSize === units.dp(62) ? 1 : 0
            text: Qt.formatTime(new Date(), "hh")
        }

        Label {
            id: _digitalTimeDivider
            anchors.centerIn: parent
            color: UbuntuColors.coolGrey
            opacity: font.pixelSize === units.dp(62) ? 1 : 0
            text: ":"
        }

        Label {
            id: _digitalTimeMinutes
            anchors {
                left: _digitalTimeDivider.right
                verticalCenter: parent.verticalCenter
            }
            color: UbuntuColors.midAubergine
            opacity: font.pixelSize === units.dp(62) ? 1 : 0
            text: Qt.formatTime(new Date(), "m")
        }
    }
}
