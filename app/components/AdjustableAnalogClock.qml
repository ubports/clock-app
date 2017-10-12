import QtQuick 2.0
import Ubuntu.Components 1.3

AnalogMode {

    property var  isMainClock: false
    property bool adjustable: true

    signal adjusted(string adjustedTime)

    showSeconds: !adjustable
    partialRotation: !adjustable
    animateRotation: adjustable

    localDateTime: "1970:01:01:00:00:00"

    Image {
        id: hourHandAdjust
        opacity:adjustable ? 1 : 0
        Behavior on opacity { UbuntuNumberAnimation { duration:UbuntuAnimation.BriskDuration } }
        z: 20
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Hour_Adjust_Circle.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id:adjustHourMouseArea
        z: hourHandAdjust.z + 1
        anchors.centerIn: parent
        width:parent.width/2
        height: parent.height/2
        propagateComposedEvents: true
        preventStealing: true
        function updateHours(mouse) {
            if(adjustable) {
                var minutes = parseInt(localDateTime.split(":")[4]);
                var rot =  1-(Math.PI + Math.atan2(mouse.x-(parent.width/4),mouse.y-(parent.height/4))) / (Math.PI*2);
                localDateTime =  "1970:01:01:"+ parseInt(rot * 12) + ":"+minutes+":00";
                adjusted(localDateTime)
            }
        }

        onPressed:  {
           var tangx = mouse.x-(x );
           var tangy = mouse.y-(y );
            if (!adjustable || Math.abs(Math.sqrt((tangx*tangx)+(tangy*tangy))) > width/2 ) {
                 mouse.accepted = false;
            }
        }

        onMouseXChanged: updateHours(mouse)
        onMouseYChanged: updateHours(mouse)
    }

    Image {
        id: minuteHandAdjust
        opacity:adjustable ? 1 : 0
        Behavior on opacity { UbuntuNumberAnimation { duration:UbuntuAnimation.BriskDuration } }
        z: 10
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Minute_Adjust_Cirlce.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }


    MouseArea {
        id:adjustMinuteMouseArea
        z:minuteHandAdjust.z + 1
        anchors.fill: parent
        preventStealing: true
        propagateComposedEvents: true
        function updateMinutes(mouse) {
            if(adjustable) {
                var hour = parseInt(localDateTime.split(":")[3]);
                var rot = 1-(Math.PI + Math.atan2(mouse.x-(parent.width/2),mouse.y-(parent.y+parent.height/2))) / (Math.PI*2);
                localDateTime =  "1970:01:01:"+ hour +":"+ parseInt(rot * 60) + ":00";
                adjusted(localDateTime)
            }
        }

        onPressed: {
            var tangx = mouse.x-(x + width/2);
            var tangy = mouse.y-(y + height/2);
            if (!adjustable || Math.abs(Math.sqrt((tangx*tangx)+(tangy*tangy))) > width/2 ) {
                 mouse.accepted = false;
            }
        }

        onMouseXChanged: updateMinutes(mouse)
        onMouseYChanged: updateMinutes(mouse)
    }

    function setTime(time) {
        var timezoneHours = ((time).getTimezoneOffset() / 60);
        var timezoneminutes = ((time).getTimezoneOffset() % 60);
        localDateTime= "1970:01:01:"+parseInt(time.getHours()+timezoneHours)+ ":"+parseInt(time.getMinutes()+timezoneminutes)+":"+time.getSeconds();

    }

    function getTime() {
        if(!localDateTime) { return new Date(0); }

        var tmpTime = new Date(Date.now());
        return new Date( tmpTime.setHours( tmpTime.getHours() + parseInt(localDateTime.split(":")[3]),
                                           tmpTime.getMinutes() + parseInt(localDateTime.split(":")[4]),
                                           tmpTime.getSeconds() + parseInt(localDateTime.split(":")[5]) ) );
    }
}
