import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components/Utils.js" as Utils

Column {
    id: fakeHeader

    height: units.gu(9)

    Rectangle {
        height: units.gu(7)
        width: parent.width
        color:"#F5F5F5"
        
        Icon {
            id: backIcon
            name: "back"
            width: units.gu(2.5)
            color: "#5D5D5D"
            height: width
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2.2)
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Label {
            text: "Alarms"
            fontSize: "x-large"
            anchors.left: backIcon.right
            anchors.leftMargin: units.gu(1.25)
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Icon {
            id: addIcon
            name: "add"
            width: units.gu(2.5)
            height: width
            color: "#5D5D5D"
            anchors.right: parent.right
            anchors.rightMargin: units.gu(2.3)
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    Rectangle {
        color: "#C9C9C9"
        height: units.gu(2)
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
