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
import "../alarm"

Item {
    id:_timerFace
    width: units.gu(24)
    height:width + units.gu(0.5)

    property alias adjustable: timerCircle.adjustable
    property bool running: false

    // Below logic seemss weird but it`s need to prevent the time label from poping in and out while adjusting the timer
    property bool showTimeLabel: timerCircle.adjusting && timerTimeLbl.height || timerCircle.hasTime && !timerCircle.adjusting;


    signal adjusted(string adjustedTime)

    


    Column {
        width: parent.width

        Label {
            id: timerTimeLbl
            objectName: "timerTimeLbl"
            width:parent.width/3            
            height: showTimeLabel ? font.pixelSize + units.gu(1) : 0;
            opacity: showTimeLabel ? 1 : 0
            Behavior on height { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: units.gu(2.5)
            font.bold: running
            horizontalAlignment: Text.Center
            text: timerAlarmUtils.get_time_to_alarm(timerCircle.getTime(),new Date(), running)
            color: running ? theme.palette.normal.selectionText : theme.palette.normal.backgroundText;
        }

        AdjustableAnalogClock {
            id: timerCircle

            width: parent.width

            property bool hasTime: timerCircle.getTime().getTime() > Date.now()

            onAdjusted: _timerFace.adjusted(adjustedTime)

        }


    }

    function reset() {
         timerCircle.localDateTime = "1970:01:01:00:00:00"
    }

    function getCircle() {
        return timerCircle;
    }


    function getTimerTime() {
        return (new Date(timerCircle.getTime().getTime() - Date.now())).getTime();
    }

}
