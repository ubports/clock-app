import QtQuick 2.0
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0
import QtFeedback 5.0

AnalogMode {
    id:_adjustableAnalogClock
    property var  isMainClock: false
    property bool adjustable: true
    property bool adjusting: false
    property bool enableHaptic: false

    signal adjusted(string adjustedTime)

    showSeconds: !adjustable
    partialRotation: !adjustable
    animateRotation: adjustable

    localDateTime: "1970:01:01:00:00:00"

    Image {
        id: hourHandAdjust
        opacity:adjustable ? 0.2 : 0
        Behavior on opacity { UbuntuNumberAnimation { duration:UbuntuAnimation.BriskDuration } }
        z: minuteHandAdjust.z + 10
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Hour_Adjust_Circle.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }

    ClockCircle {
        id:hourCircleLayer
        opacity:adjustable ? 0.75 : 0
        Behavior on opacity { UbuntuNumberAnimation { duration:UbuntuAnimation.BriskDuration } }
        z: 1
        width: parent.width / 2 + units.gu(1.5)
        anchors.centerIn: parent
        isFoldVisible:false
        borderColorTop:"#909E9E9E"
        borderColorBottom:"#B09E9E9E"
        layer.effect: FastBlur {
            radius: units.gu(1)
        }
        layer.enabled: true

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
                 var oldLocalDateTime = localDateTime;
                var localPoint = mapToItem(adjustHourMouseArea, mouse.x, mouse.y)
                var minutes = parseInt(localDateTime.split(":")[4]);
                var rot =  1-(Math.PI + Math.atan2(localPoint.x-(width/2),localPoint.y-(height/2))) / (Math.PI*2);
                localDateTime =  "1970:01:01:"+ parseInt(rot * 12) + ":"+minutes+":00";
                if(oldLocalDateTime != localDateTime && enableHaptic )  {
                   Haptics.play();
                }
                adjusted(localDateTime)
            }
        }

        onPressed:  {
           var localPoint = mapToItem(adjustHourMouseArea, mouse.x, mouse.y)
           var tangx = localPoint.x-(width/2);
           var tangy = localPoint.y-(height/2);
            if (!adjustable || Math.abs(Math.sqrt((tangx*tangx)+(tangy*tangy))) > adjustHourMouseArea.width/2 ) {
                 mouse.accepted = false;
            }
            adjusting = true
        }

        onReleased: adjusting = false

        onMouseXChanged: updateHours(mouse)
        onMouseYChanged: updateHours(mouse)
    }

    Image {
        id: minuteHandAdjust
        opacity:adjustable ? 0.2 : 0
        Behavior on opacity { UbuntuNumberAnimation { duration:UbuntuAnimation.BriskDuration } }
        z: 10
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: Theme.name == "Ubuntu.Components.Themes.Ambiance" ? "../graphics/Minute_Adjust_Cirlce.png" : "../graphics/Minute_Adjust_Cirlce_White.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }

    //Seperate the ohur adjusting area from the minute adjustment area by 3gu
    MouseArea {
        id:adjustHourMinutesSeperator
        z: adjustMinuteMouseArea.z + 1
        anchors.centerIn: parent
        width:adjustHourMouseArea.width + units.gu(3)
        height: adjustHourMouseArea.height + units.gu(3)
        propagateComposedEvents: true
        preventStealing: true

        onPressed:  {
           var localPoint = mapToItem(adjustHourMinutesSeperator, mouse.x, mouse.y)
           var tangx = localPoint.x-(width/2);
           var tangy = localPoint.y-(height/2);
            if (Math.abs(Math.sqrt((tangx*tangx)+(tangy*tangy))) > adjustHourMinutesSeperator.width/2 ) {
                 mouse.accepted = false;
            }

        }
    }

    MouseArea {
        id:adjustMinuteMouseArea
        z:minuteHandAdjust.z + 1
        anchors.fill: parent
        preventStealing: true
        propagateComposedEvents: true
        function updateMinutes(mouse) {
            if(adjustable) {
                var oldLocalDateTime = localDateTime;
                var localPoint = mapToItem(adjustMinuteMouseArea, mouse.x, mouse.y)
                var hour = parseInt(localDateTime.split(":")[3]);
                var rot = 1-(Math.PI + Math.atan2(localPoint.x-(width/2),localPoint.y-(parent.height/2))) / (Math.PI*2);
                localDateTime =  "1970:01:01:"+ hour +":"+ parseInt(rot * 60) + ":00";
                if(oldLocalDateTime != localDateTime  && enableHaptic) {
                    Haptics.play();
                }
                adjusted(localDateTime)
            }
        }

        onPressed: {
            var localPoint = mapToItem(adjustMinuteMouseArea, mouse.x, mouse.y)
            var tangx = localPoint.x-(width/2);
            var tangy = localPoint.y-(height/2);
            if (!adjustable || Math.abs(Math.sqrt((tangx*tangx)+(tangy*tangy))) > width/2 ) {
                 mouse.accepted = false;
            }
            adjusting = true;
        }

        onReleased: adjusting = false

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
