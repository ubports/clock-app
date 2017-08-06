import QtQuick 2.0

AnalogMode {

    property var  isMainClock: false
    property bool adjustable: true
    property var datedTime: new Date(0)

    showSeconds: false

    localDateTime: "1970:01:01:00:00:00"

    onLocalDateTimeChanged: {
        var tmpTime = new Date(Date.now());
        datedTime = new Date( tmpTime.setHours( tmpTime.getHours() + parseInt(localDateTime.split(":")[3]),
                                                tmpTime.getMinutes() + parseInt(localDateTime.split(":")[4])));

    }

    MouseArea {
        id:adjustHourMouseArea
        z:10
        anchors.centerIn: parent
        width:parent.width/2
        height: parent.height/2
        preventStealing: true
        function updateHours(mouse) {
            if(adjustable) {
                var minutes = parseInt(localDateTime.split(":")[4]);
                var rot =  1-(Math.PI + Math.atan2(mouse.x-(parent.width/4),mouse.y-(parent.height/4))) / (Math.PI*2);
                localDateTime =  "1970:01:01:"+ parseInt(rot * 12) + ":"+minutes+":00";
            }
        }

        onMouseXChanged: updateHours(mouse)
        onMouseYChanged: updateHours(mouse)
    }

    MouseArea {
        id:adjustMinuteMouseArea
        z:5
        anchors.fill: parent
        preventStealing: true
        function updateMinutes(mouse) {
            if(adjustable) {
                var hour = parseInt(localDateTime.split(":")[3]);
                var rot = 1-(Math.PI + Math.atan2(mouse.x-(parent.width/2),mouse.y-(parent.y+parent.height/2))) / (Math.PI*2);
                localDateTime =  "1970:01:01:"+ hour +":"+ parseInt(rot * 60) + ":00";
            }
        }

        onMouseXChanged: updateMinutes(mouse)
        onMouseYChanged: updateMinutes(mouse)
    }
}
