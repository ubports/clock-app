import QtQuick 2.0
import Ubuntu.Components 1.1
import "../components"

ClockCircle {
    id: _innerCircleAnalog

    property alias animationTimer: _animationTimer

    anchors.centerIn: parent

    Component.onCompleted: console.log("Analog Mode loaded")
    Component.onDestruction: console.log("Analog Mode unloaded")

    Timer {
        id: _animationTimer
        interval: 200
        repeat: false
        onTriggered: _innerCircleAnimation.start()
    }

    PropertyAnimation {
        target: _innerCircleAnalog
        property: "width"
        to: units.gu(23)
        duration: 900
    }
}
