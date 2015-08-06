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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.2

ListView {
    id: lapListView

    interactive: false

    StopwatchUtils {
        id: stopwatchUtils
    }

    displaced: Transition {
        UbuntuNumberAnimation {
            property: "y"
            duration: UbuntuAnimation.BriskDuration
        }
    }

    delegate: ListItem {
        divider.visible: true
        leadingActions: ListItemActions {
            actions: [
                Action {
                    iconName: "delete"
                    onTriggered: {
                        lapsModel.remove(index, 1)
                    }
                }
            ]
        }
        
        Row {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: units.gu(2)
            }
            
            Label {
                color: UbuntuColors.midAubergine
                text: "#%1".arg(count - index)
                width: parent.width / 7
                horizontalAlignment: Text.AlignHCenter
            }
            
            Label {
                width: 3 * parent.width / 7
                text: stopwatchUtils.millisToTimeString(model.laptime, true)
                horizontalAlignment: Text.AlignHCenter
            }
            
            Label {
                width: 3 * parent.width / 7
                text: stopwatchUtils.millisToTimeString(model.totaltime, true)
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
