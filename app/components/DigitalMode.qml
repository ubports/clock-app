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
        scale = 0
        _innerCircleAnimation.start()
    }

    width: maxWidth
    isFoldVisible: isMainClock

    Label {
        id: _digitalTime

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width:Math.min(parent.width,parent.height)-units.dp(4)

        color: Theme.palette.normal.baseText
        font.pixelSize: maxTimeFontSize
        minimumPixelSize: 6
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
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

        font.pixelSize: maxPeriodFontSize
        minimumPixelSize: 6
        fontSizeMode: Text.Fit
        visible: text !== ""
        color: Theme.palette.normal.baseText
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

        PauseAnimation {
            duration: 200
        }

        UbuntuNumberAnimation {
            target: _innerCircle
            property: "scale"
            from: 0
            to: 1
            duration: 700
        }

        // Fire signal that the animation is complete.
        ScriptAction {
            script: animationComplete()
        }
    }
}
