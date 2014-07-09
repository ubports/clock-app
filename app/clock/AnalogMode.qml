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

    Component.onCompleted: Utils.log(debugMode, "Loaded Analog Mode")
    Component.onDestruction: Utils.log(debugMode, "Unloaded Analog Mode")

    function startAnimation() {
        _animationTimer.start()
    }

    anchors.centerIn: parent
    width: units.gu(0)

    Timer {
        id: _animationTimer
        interval: 200
        repeat: false
        onTriggered: _innerCircleAnimation.start()
    }

    /*
      TODO: Add clock hands
    */

    PropertyAnimation {
        id: _innerCircleAnimation
        target: _innerCircleAnalog
        property: "width"
        from: units.gu(0)
        to: units.gu(23)
        duration: 900
    }
}
