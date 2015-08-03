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

    isOuter: true
    width: units.gu(32)

    ClockCircle {
        id: innerCircle

        width: units.gu(23)
        anchors.centerIn: parent
    }

    Label {
        anchors.centerIn: parent
        text: "00:00:00"
        fontSize: "x-large"
        color: UbuntuColors.midAubergine
    }
}
