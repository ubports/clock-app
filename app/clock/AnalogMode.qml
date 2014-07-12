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
    id: _innerCircleAnalog

    function startAnimation() {
        _animationTimer.start()
    }

    width: units.gu(0)

    Timer {
        id: _animationTimer
        interval: 200
        repeat: false
        onTriggered: _innerCircleAnimation.start()
    }

    Image {
        id: hourHand

        z: minuteHand.z + 1
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Hour_Hand.png"
        fillMode: Image.PreserveAspectFit
        rotation: analogTime.getHours() * 30
    }

    Image {
        id: minuteHand

        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Minute_Hand.png"
        fillMode: Image.PreserveAspectFit
        rotation: analogTime.getMinutes() * 6
    }

    Image {
        id: secondHand

        anchors.centerIn: parent
        width: parent.width + units.gu(2)

        smooth: true
        source: "../graphics/Second_Hand.png"
        fillMode: Image.PreserveAspectFit
        rotation: analogTime.getSeconds() * 6
    }

    Image {
        id: center

        z: hourHand.z + 1
        width: parent.width
        anchors.centerIn: parent

        fillMode: Image.PreserveAspectFit
        source: "../graphics/Knob.png"
    }

    PropertyAnimation {
        id: _innerCircleAnimation
        target: _innerCircleAnalog
        property: "width"
        from: units.gu(0)
        to: units.gu(23)
        duration: 900
    }

}
