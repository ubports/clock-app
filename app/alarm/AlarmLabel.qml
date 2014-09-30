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

import QtQuick 2.3
import Ubuntu.Components 1.1

Page {
    id: _alarmLabelPage
    objectName: "alarmLabelPage"

    // Property to set the alarm label in the edit alarm page
    property var alarm

    visible: false
    title: i18n.tr("Label")

    head.backAction: Action {
        id: backAction
        iconName: "back"
        onTriggered: {
            alarm.message = _labelEntry.text
            pop()
        }
    }

    Component.onCompleted: {
        _labelEntry.forceActiveFocus()
    }

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
            objectName: "labelEntry"

            text: alarm.message
            width: parent.width
            inputMethodHints: Qt.ImhNoPredictiveText

            onTextChanged: {
                backAction.enabled = !!text.trim()
            }
        }
    }
}
