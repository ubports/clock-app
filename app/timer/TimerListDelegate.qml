/*
 * Copyright (C) 2016 Canonical Ltd
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


ListItem {
    id: _timerListItem

    property var    timerTime
    property var    timerMessage
    property bool   activeAlarm: false


    ListItemLayout {
        title.text:timerMessage
        subtitle.text:timerAlarmUtils.timeDiffToString(timerTime.getTime());

        Column {
            visible : opacity !== 0;
            opacity: activeAlarm ? 1 : 0;
            SlotsLayout.position : SlotsLayout.TopRight;

            Behavior on opacity { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                name:"alarm"
                width:units.gu(1.5)
            }
            Label {
                text:i18n.tr("Active")
                font.pixelSize: units.gu(1.2)
            }
        }

    }

}
