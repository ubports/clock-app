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

ClockCircle {
    id: _innerCircleAnalog

    // Property to set the max width when running the animation
    property int maxWidth

    // Property to show/hide the seconds hand
    property bool showSeconds
    property bool partialRotation: true
    property bool animateRotation: false

    property var  localDateTime: notLocalizedDateTimeString

    signal animationComplete()

    function startAnimation() {
        _innerCircleAnimation.start()
    }

    isFoldVisible: isMainClock
    width: units.gu(0)

    Image {
        id: hourHandShadow

        z: minuteHand.z + 1
        width: parent.width
        anchors.centerIn: parent
        anchors.verticalCenterOffset: showSeconds ? units.dp(2) : units.dp(1)

        source: "../graphics/Hour_Hand_Shadow.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        // notLocalizedDateTimeString.split(":")[3] is hours
        // notLocalizedDateTimeString.split(":")[4] is minutes
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 12 hours in clock face,
        // For hours: 360deg/12h=30 deg/h, for minutes 30deg/60min= 0.5 deg/min
        rotation: (parseInt(localDateTime.split(":")[3]) * 30) + (partialRotation? (parseInt(localDateTime.split(":")[4]) * 0.5) : 0 )
        Behavior on rotation { enabled: animateRotation; UbuntuNumberAnimation { duration:UbuntuAnimation.FastDuration } }
    }

    Image {
        id: hourHand

        z: minuteHand.z + 1
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Hour_Hand.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        // notLocalizedDateTimeString.split(":")[3] is hours
        // notLocalizedDateTimeString.split(":")[4] is minutes
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 12 hours in clock face,
        // For hours: 360deg/12h=30 deg/h, for minutes 30deg/60min= 0.5 deg/min
        rotation: (parseInt(localDateTime.split(":")[3]) * 30) + (partialRotation? (parseInt(localDateTime.split(":")[4]) * 0.5) : 0 )
        Behavior on rotation { enabled: animateRotation; UbuntuNumberAnimation { duration:UbuntuAnimation.FastDuration } }
    }

    Image {
        id: minuteHandShadow

        z: parent.z + 1
        width: parent.width
        anchors.centerIn: parent
        anchors.verticalCenterOffset: showSeconds ? units.dp(2) : units.dp(1)

        source: "../graphics/Minute_Hand_Shadow.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        // notLocalizedDateTimeString.split(":")[4] is minutes
        // notLocalizedDateTimeString.split(":")[5] is seconds
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 60 miutes in clock face,
        // For minutes: 360deg/60min=6 deg/min, for seconds 6deg/60sec= 0.1 deg/sec
        rotation: (parseInt(localDateTime.split(":")[4]) * 6) + (partialRotation? (parseInt(localDateTime.split(":")[5]) * 0.1) : 0 )
        Behavior on rotation { enabled: animateRotation; UbuntuNumberAnimation { duration:UbuntuAnimation.FastDuration } }
    }

    Image {
        id: minuteHand

        z: parent.z + 1
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: Theme.name == "Ubuntu.Components.Themes.Ambiance" ? "../graphics/Minute_Hand.png" : "../graphics/Minute_Hand_White.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        // notLocalizedDateTimeString.split(":")[4] is minutes
        // notLocalizedDateTimeString.split(":")[5] is seconds
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 60 miutes in clock face,
        // For minutes: 360deg/60min=6 deg/min, for seconds 6deg/60sec= 0.1 deg/sec
        rotation: (parseInt(localDateTime.split(":")[4]) * 6) + (partialRotation? (parseInt(localDateTime.split(":")[5]) * 0.1) : 0 )
        Behavior on rotation { enabled: animateRotation; UbuntuNumberAnimation { duration:UbuntuAnimation.FastDuration } }
    }

    Image {
        id: secondHandShadow

        anchors.centerIn: parent
        width: parent.width + units.gu(2)
        anchors.verticalCenterOffset: units.dp(2)

        visible: showSeconds
        source: "../graphics/Second_Hand_Shadow.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        // notLocalizedDateTimeString.split(":")[5] is seconds
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 60 seconds in clock face,
        // For seconds 360deg/60sec= 6 deg/sec
        rotation: visible ? parseInt(localDateTime.split(":")[5]) * 6 : 0
        Behavior on rotation { enabled: animateRotation; UbuntuNumberAnimation { duration:UbuntuAnimation.FastDuration } }
    }

    Image {
        id: secondHand

        anchors.centerIn: parent
        width: parent.width + units.gu(2)

        smooth: true
        visible: showSeconds
        source: "../graphics/Second_Hand.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        // notLocalizedDateTimeString.split(":")[5] is seconds
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 60 seconds in clock face,
        // For seconds 360deg/60sec= 6 deg/sec
        rotation: visible ? parseInt(localDateTime.split(":")[5]) * 6 : 0
        Behavior on rotation { enabled: animateRotation; UbuntuNumberAnimation { duration:UbuntuAnimation.FastDuration } }
    }

    Image {
        id: center

        z: hourHand.z + 1
        width: parent.width
        anchors.centerIn: parent

        fillMode: Image.PreserveAspectFit
        source: "../graphics/Knob.png"
        asynchronous: true
    }

    SequentialAnimation {
        id: _innerCircleAnimation

        PauseAnimation {
            duration: 200
        }

        UbuntuNumberAnimation {
            target: _innerCircleAnalog
            property: "width"
            from: units.gu(0)
            to: maxWidth
            duration: 700
        }

        // Fire signal that the animation is complete.
        ScriptAction {
            script: animationComplete()
        }
    }
}
