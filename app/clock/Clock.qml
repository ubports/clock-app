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
    property alias time: _digitalTime.text
    
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
                target: _digitalTime
                property: "font.pixelSize"
                to: units.dp(62)
                duration: 900
            }
        }
        
        Label {
            id: _digitalTime
            anchors.centerIn: parent
            color: UbuntuColors.midAubergine
            opacity: font.pixelSize === units.dp(62) ? 1 : 0
            text: Qt.formatTime(new Date(), "hh:mm")
        }
    }
}
