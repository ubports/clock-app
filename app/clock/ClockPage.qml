import QtQuick 2.0
import Ubuntu.Components 1.1
import "../components"

Page {
    id: clockPage

    /*
      Property to set the maximum drag distance before freezing the add
      city button resize
    */
    property int _maxThreshold: -50

    /*
      Property to set the minimum drag distance before activating the add
      city signal
    */
    property int _minThreshold: -40

    flickable: null
    anchors.fill: parent

    function updateTime() {
        clock.time = Qt.formatTime(new Date(), "hh:mm")
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: clock.height + date.height + locationRow.height

        AddCityButton {
            id: addCityButton
            anchors.top: parent.top
            anchors.topMargin: -labelHeight
            anchors.horizontalCenter: parent.horizontalCenter
            maxThreshold: _maxThreshold
        }

        Clock {
            id: clock
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: units.gu(16) + clockApp.height/8
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: date

            Component.onCompleted: anchors.topMargin = units.gu(44)

            anchors.top: parent.top
            anchors.topMargin: units.gu(40)
            anchors.horizontalCenter: parent.horizontalCenter

            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
            fontSize: "medium"

            Behavior on anchors.topMargin {
                UbuntuNumberAnimation { duration: 900 }
            }
        }

        Row {
            id: locationRow

            spacing: units.gu(1)

            anchors.top: date.bottom
            anchors.topMargin: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: locationIcon
                source: "../graphics/Location_Pin.png"
                width: units.gu(1.2)
                height: units.gu(2.2)
            }

            Label {
                id: location
                text: "Location"
                fontSize: "large"
                anchors.verticalCenter: locationIcon.verticalCenter
                color: UbuntuColors.midAubergine
            }
        }

        onDragEnded: {
            if(contentY < _minThreshold)
                console.log("[LOG]: Activate add city signal")
        }

        onContentYChanged: {
            if(contentY < 0 && atYBeginning) {
                addCityButton.dragPosition = contentY.toFixed(0)
            }
        }
    }
}
