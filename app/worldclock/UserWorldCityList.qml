import QtQuick 2.0
import Timezone 1.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import "../components"
import "../components/Utils.js" as Utils

Column {
    id: worldCityColumn
    
    function getTimeDiff(time) {
        var hours, minutes;
        time = Math.floor(time / 60)
        minutes = time % 60
        hours = Math.floor(time / 60)
        return [hours, minutes]
    }
    
    anchors.top: locationRow.bottom
    anchors.topMargin: units.gu(6)
    width: parent.width
    
    // U1db Index to index all documents storing the world city details
    U1db.Index {
        id: by_worldcity
        database: clockDB
        expression: [
            "worldlocation.city",
            "worldlocation.country",
            "worldlocation.timezone"
        ]
    }
    
    // U1db Query to create a model of the world cities saved by the user
    U1db.Query {
        id: worldCityQuery
        index: by_worldcity
        query: ["*","*","*"]
    }
    
    U1dbTimeZoneModel {
        id: u1dbModel
        updateInterval: 1000
        model: worldCityQuery.results
    }
    
    Repeater {
        model: u1dbModel
        delegate: SubtitledListItem {
            
            height: units.gu(8)
            
            text: model.city
            subText: model.country
            showDivider: false
            removable: true
            confirmRemoval: true
            
            Label {
                id: localTimeLabel
                
                anchors.centerIn: parent
                fontSize: "large"
                text: model.localTime
            }
            
            Label {
                id: relativeTimeLabel
                
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                
                fontSize: "xx-small"
                horizontalAlignment: Text.AlignRight
                text: {
                    var day;
                    
                    if(model.daysTo === 0) {
                        day = i18n.tr("Today")
                    }
                    
                    else if(model.daysTo === 1) {
                        day = i18n.tr("Tomorrow")
                    }
                    
                    else if(model.daysTo === -1) {
                        day = i18n.tr("Yesterday")
                    }
                    
                    var isBehind = model.timeTo > 0 ? i18n.tr("behind")
                                                    : i18n.tr("ahead")
                    
                    var timediff = worldCityColumn.getTimeDiff(Math.abs(model.timeTo))
                    var minute = timediff[1]
                    var hour = timediff[0]
                    
                    if(hour > 0 &&  minute > 0) {
                        return ("%1\n%2hr%3min %4")
                        .arg(day)
                        .arg(hour)
                        .arg(minute)
                        .arg(isBehind)
                    }
                    
                    else if(hour > 0 && minute === 0) {
                        return ("%1\n%2hr %3")
                        .arg(day)
                        .arg(hour)
                        .arg(isBehind)
                    }
                    
                    else if(hour === 0 && minute > 0) {
                        return ("%1\n%2min %3")
                        .arg(day)
                        .arg(minute)
                        .arg(isBehind)
                    }
                    
                    else {
                        return i18n.tr("No Time Difference")
                    }
                }
            }
            
            onItemRemoved: {
                /*
                 NOTE: This causes the document to be deleted twice resulting
                 in an error. The bug has been reported at
                 https://bugs.launchpad.net/ubuntu-ui-toolkit/+bug/1276118
                */
                Utils.log("Deleting world location: " + model.city)
                clockDB.deleteDoc(worldCityQuery.documents[index])
            }
        }
    }
}
