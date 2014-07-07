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

Page {
    id: _alarmLabelPage

    visible: false
    title: i18n.tr("Label")

    // Property to set the alarm label in the edit alarm page
    property var alarmLabel

    Column {
        id: _labelColumn

        spacing: units.gu(0.5)

        anchors {
            fill: parent
            margins: units.gu(2)
        }

        Label {
            text: i18n.tr("Label")
        }

        TextField {
            id: _labelEntry
            text: alarmLabel.subText
            width: parent.width
        }
    }

    tools: ToolbarItems {
        back: Button {
            action: Action {
                iconName: "back"
                onTriggered: {
                    alarmLabel.subText = _labelEntry.text
                    mainStack.pop()
                }
            }
        }
    }
}
