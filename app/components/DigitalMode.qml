/*
 * Copyright (C) 2014-2015 Canonical Ltd
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
import Ubuntu.Components 1.2

ClockCircle {
    id: _innerCircle

    // Property to allow setting the time font size manually
    property alias timeFontSize: _digitalTime.font.pixelSize

    // Property to allow setting the time period font size manually
    property alias timePeriodFontSize: _digitalTimePeriod.font.pixelSize

    // Properties to set the maximum dimensions when running the animations
    property int maxWidth
    property int maxTimeFontSize
    property int maxPeriodFontSize

    signal animationComplete()

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

    Label {
        id: _digitalTime

        anchors.centerIn: parent

        color: UbuntuColors.midAubergine
        font.pixelSize: units.dp(1)
        text: {
            if (localizedTimeString.search(Qt.locale().amText) !== -1) {
                // 12 hour format detected with the localised AM text
                return localizedTimeString.replace(Qt.locale().amText, "").trim()
            }
            else if (localizedTimeString.search(Qt.locale().pmText) !== -1) {
                // 12 hour format detected with the localised PM text
                return localizedTimeString.replace(Qt.locale().pmText, "").trim()
            }
            else {
                // 24-hour format detected, return full time string
                return localizedTimeString
            }
        }
    }

    Label {
        id: _digitalTimePeriod

        anchors.top: _digitalTime.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        color: UbuntuColors.midAubergine
        font.pixelSize: units.dp(1)
        visible: text !== ""
        text: {
            if (localizedTimeString.search(Qt.locale().amText) !== -1) {
                // 12 hour format detected with the localised AM text
                return Qt.locale().amText
            }
            else if (localizedTimeString.search(Qt.locale().pmText) !== -1) {
                // 12 hour format detected with the localised PM text
                return Qt.locale().pmText
            }
            else {
                // 24-hour format detected
                return ""
            }
        }
    }

    SequentialAnimation {
        id: _innerCircleAnimation

        ParallelAnimation {
            PropertyAnimation {
                target: _innerCircle
                property: "width"
                from: units.gu(0)
                to: maxWidth
                duration: 900
            }

            PropertyAnimation {
                target: _digitalTime
                property: "font.pixelSize"
                from: units.dp(1)
                to: maxTimeFontSize
                duration: 900
            }

            PropertyAnimation {
                target: _digitalTimePeriod
                property: "font.pixelSize"
                from: units.dp(1)
                to: maxPeriodFontSize
                duration: 900
            }
        }

        // Fire signal that the animation is complete.
        ScriptAction {
            script: animationComplete()
        }
    }
}
