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

Flipable {
    id: digitalShadow

    // Property to switch between digital and analog mode
    property bool isAnalog: false

    width: units.gu(23)
    height: width/2
    clip: true

    front: DigitalMode {
        id: _digitalMode
        width: units.gu(23)
        timeFontSize: units.dp(62)
        timePeriodFontSize: units.dp(12)
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    back: AnalogMode {
        id: _analogMode
        width: units.gu(23)
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    transform: Rotation {
        id: rotation
        origin.x: digitalShadow.width/2
        origin.y: 0
        axis.x: 1; axis.y: 0; axis.z: 0
        angle: 0
    }

    states: State {
        name: "Digital"
        when: digitalShadow.isAnalog
        PropertyChanges {
            target: rotation
            angle: -180
        }
    }

    transitions: Transition {
        NumberAnimation {
            target: rotation
            property: "angle"
            duration: 666
        }
    }
}
