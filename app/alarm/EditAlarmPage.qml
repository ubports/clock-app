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
import Ubuntu.Components.Pickers 1.0
import "../components"
import "../components/Utils.js" as Utils

Page {
    id: _editAlarmPage

    title: i18n.tr("New Alarm")
    visible: false

    Alarm {
        id: alarm
        onStatusChanged: {
            if (status != Alarm.Ready)
                return;
            if ((operation > Alarm.NoOperation) && (operation < Alarm.Reseting)) {
                mainStack.pop();
            }
        }
    }

    DatePicker {
            id: datePicker
            clip: true
            mode: "Hours|Minutes"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(-2)
        }
}
