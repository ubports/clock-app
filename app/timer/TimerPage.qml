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
import QtQml.Models 2.1
import U1db 1.0 as U1db
import Ubuntu.Components.Popups 1.3
import "../components"
import "../alarm"

Item {
    id: _timerPage
    objectName: "timerPage"

    property Alarm alarm: null
    property var isRunning: alarm && alarm.enabled  && alarm.date > new Date();
    property AlarmModelComponent alarmModel: null

    ActiveTimers {
        id: activeTimers
        alarmModel: _timerPage.alarmModel
    }

    Component.onCompleted: {
        console.log("[LOG]: Timer Page Loaded")
        _timerPage.isRunning = Qt.binding(function() { return alarm && alarm.enabled && alarm.date > new Date(); });
    }

    onAlarmModelChanged: updateAlarms ();

    onIsRunningChanged: {
        //Currently we only support a single timer so if the timer is stopped :
        //   disconnect the alarmModel connections remove ALL the timers reconnect the  alarm Model
        if(!isRunning) {
            alarmModelConnection.target = null;
            activeTimers.removeAllTimerAlarms();
            alarmModelConnection.target = _timerPage.alarmModel;
            _timerPage.updateAlarms();
        }
    }

    Connections {
        id:alarmModelConnection
        target:alarmModel
        onCountChanged :updateAlarms();
        onIsReadyChanged: updateAlarms();
    }

    function updateAlarms () {
        console.log("Alarm Model updated")
        if(alarmModel && alarmModel.count > 0 ) {
            for(var i=0; i < alarmModel.count; i++) {
                var tmpAlarm = alarmModel.get(i);
                if(activeTimers.isAlarmATimerAlarm(tmpAlarm) && tmpAlarm.enabled  && tmpAlarm.date > new Date()) {
                    _timerPage.alarm = alarmModel.get(i);
                    break;
                }
            }
        }
    }

    TimerFace {
        id: timerFace
        objectName: "timerFace"
        running: _timerPage.isRunning
        adjustable: !running
        anchors {
            top: parent.top
            topMargin:units.gu(1.5)
            horizontalCenter: parent.horizontalCenter
        }

        onAdjusted: {
            timerNameField.text = "";
        }

    }

    Component {
        id:alarmComponent
        Alarm {}
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

                } else {
                    _timerPage.stopTimer();
                }
            }
        }
        running: isRunning
        repeat: true
    }

    Popover {
          //Display helping  hint when the user click on the start without setting the timer time
          id:pleaseSetTimePopover
          
          Label {
              id:pleaseSetTimeMsg
              anchors.centerIn: parent
              text:i18n.tr("Please set a time before starting the timer\nby dragging the clock hands above.")
              horizontalAlignment: Text.Center
          }
          autoClose: true
          
          callerMargin: units.gu(1)
          contentHeight: units.gu(5)
          contentWidth: pleaseSetTimeMsg.width + callerMargin * 2
          
          Timer {
			  id:closePleaseSetTimePopoverTimer
			  interval:2000
			  running:false
			  onTriggered:{
				  pleaseSetTimePopover.hide();
			  }
		  }
          
		  onVisibleChanged: {
			  if(visible) closePleaseSetTimePopoverTimer.start();
		}
      }

    Item {
        id: buttonRow
        width: parent.width - units.gu(4)
        height: units.gu(4)
        clip:true
        anchors {
            top: timerFace.bottom
            topMargin: units.gu(6.5)
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        Row {
            id: saveTimerRow
            spacing: units.gu(2)
            enabled: false
            height: enabled ? parent.height : 0
            clip: true
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            Behavior on height {
                UbuntuNumberAnimation{
                    duration: UbuntuAnimation.BriskDuration
                }
            }

            ActionIcon {
                id:dontSaveTimerButton
                objectName:"dontSaveTimerButton"
                icon.name:  "close"
                width: units.gu(7)
                height: units.gu(4)
                onClicked: {
                    timerNameField.focus = saveTimerRow.enabled = false;
                }
            }

            TextField {
                id:timerNameField
                width: buttonRow.width / 2 - units.gu(1)
                placeholderText: i18n.tr("Enter timer name")
                onAccepted: saveTimerRow.saveTimer();
                maximumLength: 25
            }

            ActionIcon {
                id:saveTimerAction
                enabled: timerNameField.displayText
                opacity: enabled ? 1 : 0.5
                objectName:"saveTimerAction"
                icon.name: "reminder-new"
                width: units.gu(7)
                height: units.gu(4)
                onClicked: saveTimerRow.saveTimer();
            }

            function saveTimer() {
                if (Qt.inputMethod.preeditText) {
                    Qt.inputMethod.commit()
                }
                clockDB.putDoc({"timer":{"time":timerFace.getTimerTime(),"message":timerNameField.text}});
                saveTimerRow.enabled = false
                timerNameField.text = "";
            }
        }

        Row {
            id: controlRow
            height: parent.height
            spacing: units.gu(2)
            anchors {
                top: saveTimerRow.bottom
                horizontalCenter: parent.horizontalCenter
            }
            ActionIcon {
                id:saveTimerButton
                objectName:"saveTimerButton"
                icon.name: "reminder-new"
                width: units.gu(7)
                height: units.gu(4)
                enabled: timerFace.getCircle().hasTime && !isRunning
                opacity: enabled ? 1: 0

                Behavior on opacity {
                    UbuntuNumberAnimation{
                        duration: UbuntuAnimation.BriskDuration
                    }
                }
                onClicked: {
                    timerNameField.focus = saveTimerRow.enabled = true;
                }

            }

            Button {
                id: startStopButton

                property bool inProgress: false
                property bool isActive: !inProgress  && (isRunning || timerFace.getCircle().hasTime)

                objectName: "startAndStopButton"
                width: buttonRow.width / 2 - units.gu(1)
                height: units.gu(4)
                opacity: isActive ? 1 : 0.5
                color: !isRunning  ? UbuntuColors.green : UbuntuColors.red
                text: isRunning ? i18n.tr("Stop") :  i18n.tr("Start")
                onClicked: {
                    if(!isActive) {
                        pleaseSetTimePopover.caller = startStopButton
                        pleaseSetTimePopover.show();
                        return;
                    }
                    inProgress = true;
                    if(isRunning) {
                        _timerPage.stopTimer();
                    } else {
                        _timerPage.startTimer();

                    }
                    inProgress = false;
                }

            }
            ActionIcon {
                id:resetTimerButton
                objectName:"resetTimerButton"
                icon.name: "reset"
                width: units.gu(7)
                height: units.gu(4)
                enabled: timerFace.getCircle().hasTime && !isRunning
                opacity: enabled ? 1: 0
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
    }

    NestedListviewsHack {
        id:timerNestedListViewHack
        z:10
        parentListView : listview
        nestedListView : timersList
        visible: dbAllTimersQuery.results.length !== 0
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

    TimerListView {
        id: timersList
        objectName: "timersList"
        anchors {
            top: buttonRow.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(1)
        }
        visible: dbAllTimersQuery.results.length !== 0

        nestedListViewHack: timerNestedListViewHack

        model: dbAllTimersQuery
    }

    TimerUtils {
        id: timerAlarmUtils
    }

    //============================= Timer Functions =============================

    /**
     * Save a new alarm
     * @param datetime the DateTime object that the timer alarm should be fired at.
     * @param message  the message to display when the alarm is fired.
     */
    function updateNewAlarmValues(datetime, message) {
        if(!alarm) {
            alarm = alarmComponent.createObject(_timerPage)
        }

        alarm.reset()
        alarm.type = Alarm.OneTime;
        alarm.message = activeTimers.addPrefixToMessage(message)
        alarm.date = datetime
        alarm.enabled = true

        return alarm;
    }
    /**
     * Start a new timer based on the current UI settings.
     */
    function startTimer() {
        var newAlarm = _timerPage.updateNewAlarmValues(timerFace.getCircle().getTime(), timerNameField.text);
        activeTimers.addActiveTimer(alarm);
        newAlarm.save();
    }

    /**
     * Stop the currently running timer.
     */
    function stopTimer() {
        alarm.enabled = false;
        alarm.cancel()
    }

}
