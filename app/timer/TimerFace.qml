/*
 * Copyright (C) 2015-2016 Canonical Ltd
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
import Ubuntu.Components.Pickers 1.3
import "../components"

Item {
    width: units.gu(24)
    height:width

    property alias adjustable: timerCircle.adjustable

    Column {
        width: parent.width

        AdjustableAnalogClock {
            id: timerCircle

            width: parent.width

            property bool hasTime: datedTime.getTime() > Date.now()

        }

        Label {
            id: timerTimeLbl
            objectName: "timerTimeLbl"
            width:parent.width/3
            height: parent.height/6
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: units.gu(3)
            horizontalAlignment: Text.Center
            text: timerCircle.localDateTime.split(":")[3] + "h " +timerCircle.localDateTime.split(":")[4] + "m " + (timerCircle.showSeconds ? timerCircle.localDateTime.split(":")[5] + "s" : "");
            anchors.verticalCenterOffset: -parent.width/4
            color: UbuntuColors.ash
        }
    }

    function reset() {
         timerCircle.localDateTime = "1970:01:01:00:00:00"
    }

    function getCircle() {
        return timerCircle;
    }

    function getTimerTime() {
        return (new Date(timerCircle.datedTime.getTime() - Date.now())).getTime();
    }

}
