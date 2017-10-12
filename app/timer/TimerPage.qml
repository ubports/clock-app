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
import Timer 1.0
import Ubuntu.Components 1.3
import QtQml.Models 2.1
import U1db 1.0 as U1db

import "../components"

Item {
    id: _timerPage
    objectName: "timerPage"

    property Alarm alarm: null
    property var isRunning: alarm && alarm.enabled
    property AlarmModel alarmModel: null


    Component.onCompleted: {
        console.log("[LOG]: Timer Page Loaded")
    }

    onAlarmModelChanged: {
        updateAlarms ();
        if(alarmModel) {
            alarmModel.countChanged.connect(updateAlarms);
        }
    }

    function updateAlarms () {
         console.log("Alarm Model updated")
        if(alarmModel && alarmModel.count > 0 ) {
            for(var i=0; i < alarmModel.count; i++) {
                if(alarmModel.get(i).message.match(/^\(Timer\)( |$)/)) {
                    _timerPage.alarm = alarmModel.get(i);
                    break;
                }
            }
        }
    }


    TimerFace {
        id: timerFace
        objectName: "timerFace"
        adjustable: !_timerPage.isRunning
        anchors {
            top: parent.top
            topMargin: units.gu(2)
            horizontalCenter: parent.horizontalCenter
        }

        onAdjusted: {
            timerNameField.text = "";
        }

    }

    Component {
        id:alarmComponent
        Alarm {
        }
    }

    // Function to save a new alarm
    function startNewAlarm(datetime, message) {
        if(!alarm) {
            alarm = alarmComponent.createObject(_timerPage)
        }

        alarm.reset()
        alarm.type = Alarm.OneTime;
        alarm.message = "(Timer)" + (message ? message : "" )
        alarm.date = datetime
        alarm.enabled = true
        alarm.save()
    }

    Timer {
        id:timerFaceUpdate
        interval: 1000
        onTriggered: {
            if(alarm && alarm.enabled) {
               var secsDiff = alarm.date.getTime() - Date.now();
                if(secsDiff > 0) {
                    var date = new Date(secsDiff);
                    timerFace.getCircle().setTime( date );
                }
            }
        }
        running: isRunning
        repeat: true
    }


    Row {
        id: buttonRow
        spacing: units.gu(2)
        anchors {
            top: timerFace.bottom
            topMargin: units.gu(4)
            horizontalCenter: parent.horizontalCenter
            margins: units.gu(2)
        }

        ActionIcon {
            id:saveTimerButton
            objectName:"saveTimerButton"
            icon.name:   timerPropsRow.enabled ? "close" : "save"
            width: units.gu(7)
            height: units.gu(4)
            icon.color: UbuntuColors.slate
            enabled: timerFace.getCircle().hasTime && !isRunning
            opacity: timerFace.getCircle().hasTime  && !isRunning ? 1: 0

            Behavior on opacity {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }
            onClicked: timerPropsRow.enabled = !timerPropsRow.enabled

        }

        Button {
            id: startStopButton
            objectName: "startAndStopButton"
            width: _timerPage.width / 2 - units.gu(1)
            height: units.gu(4)
            enabled: isRunning || timerFace.getCircle().hasTime
            color: !isRunning  ? UbuntuColors.green : UbuntuColors.red
            text: isRunning ? i18n.tr("Stop") : (true ? i18n.tr("Start") : i18n.tr("Resume"))
            onClicked: {
                if(isRunning) {
                    alarm.enabled = false;
                    alarm.cancel()
                    clockDB.deleteDoc(dbActiveTimers.docId);
                } else {
                    startNewAlarm(timerFace.getCircle().getTime(), timerNameField.text);
                    clockDB.putDoc({"active_timers":{"time":alarm.date,"message":alarm.message}});
                    alarm.enabled = true;
                }
            }
        }
        ActionIcon {
            id:resetTimerButton
            objectName:"resetTimerButton"
            icon.name: "reset"
            width: units.gu(7)
            height: units.gu(4)
            enabled: timerFace.getCircle().hasTime && !isRunning
            opacity:  timerFace.getCircle().hasTime  && !isRunning ? 1: 0
            Behavior on opacity {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }

            onClicked: {
                timerFace.reset()
            }
        }
    }

    Row {
        id: timerPropsRow
        spacing: units.gu(2)
        enabled: false
        height: enabled ? units.gu(5) : 0
        clip: true
        anchors {
            top: buttonRow.bottom
            topMargin: units.gu(4)
            horizontalCenter: parent.horizontalCenter
            margins: units.gu(2)
        }

        Behavior on height {
            UbuntuNumberAnimation{
                duration: UbuntuAnimation.BriskDuration
            }
        }

        TextField {
            id:timerNameField
            width:_timerPage.width - units.gu(10)
            anchors {
                margins: units.gu(2)
            }

            placeholderText: i18n.tr("Enter Timer description")
            onAccepted: timerPropsRow.saveTimer();
            maximumLength: 25
        }
        ActionIcon {
            id:saveTimerAction
            objectName:"saveTimerAction"
            icon.name: "save"
            width: units.gu(7)
            height: units.gu(4)
            onClicked: timerPropsRow.saveTimer();
        }

        function saveTimer() {
            clockDB.putDoc({"timer":{"time":timerFace.getTimerTime(),"message":timerNameField.text}});
            timerPropsRow.enabled = false
            timerNameField.text = "";
        }
    }

    NestedListviewsHack {
        z:10
        parentListView : listview
        nestedListView : timersList
    }

    // U1db Index to index all documents storing the world city details
    U1db.Index {
        id: by_timer_message
        database: clockDB
        expression: [
            "timer.message",
            "timer.time",
        ]
    }



    // U1db Query to create a model of the world cities saved by the user
    U1db.Query {
        id: dbAllTimersQuery
        index: by_timer_message
        query: ["*"]
    }

    U1db.Index {
        id: active_timers_index
        database: clockDB
        expression: [
            "active_timers.message",
        ]
    }
    U1db.Query {
        id: dbActiveTimers
        index: active_timers_index
        query: ["*"]
    }

    TimerListView {
         id: timersList
         objectName: "timersList"
         anchors {
             top: timerPropsRow.bottom
             bottom: parent.bottom
             left: parent.left
             right: parent.right
             topMargin: units.gu(1)
         }
         visible: dbAllTimersQuery.results

         model: dbAllTimersQuery
     }
}
