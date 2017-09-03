/*
 * Copyright (C) 2016 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Calendar App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Calendar App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import "../alarm"

BottomEdge {
    id: bottomEdge
    objectName: "bottomEdge"

    property var pageStack: null
    property var alarmModel: null
    // WORKAROUND: BottomEdge component loads the page async while draging it
    // this cause a very bad visual.
    // To avoid that we create it as soon as the component is ready and keep
    // it invisible until the user start to drag it.
    property var _realPage: null

    hint {
        enabled: visible
        iconName: "alarm-clock"
        text: i18n.tr("Alarms")
        status: BottomEdgeHint.Active
    }

    contentComponent: Item {
        id: pageContent

        implicitWidth: bottomEdge.width
        implicitHeight: bottomEdge.height
        children: bottomEdge._realPage
        Component.onDestruction: {
            bottomEdge._realPage.destroy()
            bottomEdge._realPage = null
            _realPage = editorPageBottomEdge.createObject(null)
        }
    }

    Component.onCompleted:  {
        if (alarmModel)
            _realPage = editorPageBottomEdge.createObject(null)
    }

    onAlarmModelChanged: {
        if (alarmModel)
            _realPage = editorPageBottomEdge.createObject(null)
    }

    Component {
        id: editorPageBottomEdge
        AlarmPage {
            implicitWidth: bottomEdge.width
            implicitHeight: bottomEdge.height
            model: bottomEdge.alarmModel
            pageStack: bottomEdge.pageStack
            enabled: bottomEdge.status === BottomEdge.Committed
            active: bottomEdge.status === BottomEdge.Committed
            visible: (bottomEdge.status !== BottomEdge.Hidden)
            onBottomEdgeClosed: bottomEdge.collapse()
        }
    }
}
