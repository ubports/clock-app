/*
 * Copyright (C) 2014-2016 Canonical Ltd
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

Page {
    id: _alarmLabelPage
    objectName: "alarmLabelPage"

    // Property to set the alarm label in the edit alarm page
    property var alarm

    // Property to store the old alarm label to detect if user changed it or not
    property string oldAlarmLabel: alarm.message

    visible: false

    header: PageHeader {
        id: alarmLabelHeader
        objectName: "alarmLabelHeader"
        title: i18n.tr("Label")
        leadingActionBar.actions: [
            Action {
                id: backAction
                objectName: "backAction"
                iconName: "back"
                onTriggered: {
                    // Restore old alarm label if user presses the back button
                    alarm.message = oldAlarmLabel
                    pop()
                }
            }
        ]
        trailingActionBar.actions: [
            Action {
                id: saveAction
                objectName: "saveAction"
                iconName: "ok"
                enabled: oldAlarmLabel !== _labelEntry.text.trim() && _labelEntry.text.trim()
                onTriggered: {
                    alarm.message = _labelEntry.text.trim()
                    pop()
                }
            }
        ]
    }

    Component.onCompleted: {
        _labelEntry.forceActiveFocus()
    }

    Column {
        id: _labelColumn

        spacing: units.gu(0.5)

        anchors {
            top: _alarmLabelPage.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: units.gu(2)
        }

        Label {
            text: i18n.tr("Label")
        }

        TextField {
            id: _labelEntry
            objectName: "labelEntry"

            text: alarm.message
            width: parent.width
            inputMethodHints: Qt.ImhNoPredictiveText
        }
    }
}
