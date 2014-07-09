import QtQuick 2.0
import Ubuntu.Components 1.1
import "../components"

ClockCircle {
    id: _innerCircle

    property alias animationTimer: _animationTimer
    property alias digitalTimeSize: _digitalTime.font.pixelSize
    property alias digitalTimePeriodSize: _digitalTimePeriod.font.pixelSize

    anchors.centerIn: parent

    Component.onCompleted: console.log("Digital Mode loaded")
    Component.onDestruction: console.log("Digital Mode unloaded")

    Timer {
        id: _animationTimer
        interval: 200
        repeat: false
        onTriggered: _innerCircleAnimation.start()
    }

    ParallelAnimation {
        id: _innerCircleAnimation

        PropertyAnimation {
            target: _innerCircle
            property: "width"
            to: units.gu(23)
            duration: 900
        }

        PropertyAnimation {
            target: _digitalTime
            property: "font.pixelSize"
            to: units.dp(62)
            duration: 900
        }

        PropertyAnimation {
            target: _digitalTimePeriod
            property: "font.pixelSize"
            to: units.dp(12)
            duration: 900
        }
    }

    Label {
        id: _digitalTime

        anchors.centerIn: parent

        color: UbuntuColors.midAubergine
        font.pixelSize: units.dp(1)
        text: {
            if (time.search(Qt.locale().amText) !== -1) {
                // 12 hour format detected with the localised AM text
                return time.split(Qt.locale().amText)[0].trim()
            }
            else if (time.search(Qt.locale().pmText) !== -1) {
                // 12 hour format detected with the localised PM text
                return time.split(Qt.locale().pmText)[0].trim()
            }
            else {
                // 24-hour format detected, return full time string
                return time
            }
        }
    }

    Label {
        id: _digitalTimePeriod

        anchors.top: _digitalTime.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        color: UbuntuColors.midAubergine
        font.pixelSize: units.dp(1)
        visible: text !== ""
        text: {
            if (time.search(Qt.locale().amText) !== -1) {
                // 12 hour format detected with the localised AM text
                return Qt.locale().amText
            }
            else if (time.search(Qt.locale().pmText) !== -1) {
                // 12 hour format detected with the localised PM text
                return Qt.locale().pmText
            }
            else {
                // 24-hour format detected
                return ""
            }
        }
    }
}
