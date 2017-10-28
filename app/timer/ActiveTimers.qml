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

Item {
    id: _activeTimers

    readonly property string  timerPrefix : "(Timer) ";

    property AlarmModel alarmModel: null

    onAlarmModelChanged: {

    }

    // U1db Query to create a model of the world cities saved by the user

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

    function removeAllTimerAlarms() {
       if(!alarmModel ) { return ; }
       var alarms = [];
       for(var i=0; i < alarmModel.count; i++) {
           alarms.push(alarmModel.get(i))
       }
       for(var i=0; i < alarms.length; i++) {
           var timerEntry = _activeTimers.findTimerAlarmByMessage(alarms[i].message);
           if(timerEntry) {
               alarms[i].cancel()
               clockDB.deleteDoc(dbActiveTimers.documents[i]);
               i--;
           }
       }
       for(var j in dbActiveTimers.documents) {
           clockDB.deleteDoc(dbActiveTimers.documents[j]);
       }
    }
    
    function count() {
        return dbActiveTimers.results.length;
    }
    
    function isAlarmATimerAlarm(alarmToCheck) {
        return alarmToCheck && findTimerAlarmByMessage(alarmToCheck.message) !== null;
    }

    function findTimerAlarmByMessage(alarmMessageToFind) {
        if(dbActiveTimers.results && alarmMessageToFind ){
            for(var i in dbActiveTimers.results) {
                if( alarmMessageToFind === dbActiveTimers.results[i].message ) {
                    return dbActiveTimers.results[i];
                }
            }
        }
        return null;
    }

    function findAlarmByTimerAlarm(timerAlarm) {
        if( !alarmModel || !timerAlarm || !timerAlarm.message ) { return null; }

        for(var i=0; i <  alarmModel.count; i++) {
            if( timerAlarm.message === alarmModel.get(i).message ||
                timerAlarm.message.trim() === alarmModel.get(i).message ) {
                return alarmModel.get(i);
            }
        }
    }

}
