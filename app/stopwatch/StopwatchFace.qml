/*
 * Copyright (C) 2015 Canonical Ltd
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
import "../components"

ClockCircle {
    id: outerCirle

    // Property to hold the total time (in milliseconds)
    property int milliseconds: 0

    isOuter: true
    width: units.gu(32)

    StopwatchUtils {
        id: stopwatchUtils
    }

    ClockCircle {
        id: innerCircle

        width: units.gu(23)
        anchors.centerIn: parent
    }

    Column {
        id: text

        anchors.centerIn: parent

        Label {
            text: stopwatchUtils.millisToTimeString(milliseconds, false, true)
            font.pixelSize: units.dp(34)
            color: UbuntuColors.midAubergine
        }

        Label {
            text: stopwatchUtils.millisToString(milliseconds)
            font.pixelSize: units.dp(18)
            color: UbuntuColors.midAubergine
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
