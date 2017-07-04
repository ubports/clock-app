import QtQuick 2.0
import Ubuntu.Components 1.3

Page {

    header: PageHeader {
        id:infoHeader
        title: i18n.tr("App Information")

    }

    ListModel {
       id: infoModel
     }

    Component.onCompleted: {
        infoModel.append({ name: i18n.tr("Get the source"), url: "https://github.com/ubports/clock-app" })
        infoModel.append({ name: i18n.tr("Report issues"), url: "https://github.com/ubports/clock-app/issues" })
        infoModel.append({ name: i18n.tr("Help translate"), url: "https://translate.ubports.com/projects/ubports/clock-app/" })
    }

    Column {
        id: aboutCloumn
        spacing:units.dp(2)
        width:parent.width

        Label { //An hack to add margin to the column top
            width:parent.width
            height:infoHeader.height *2
        }

        Icon {
          anchors.horizontalCenter: parent.horizontalCenter
          height: Math.min(parent.width/2, parent.height/2)
          width:height
          name:"clock-app"
          layer.enabled: true
          layer.effect: UbuntuShapeOverlay {  }
        }
        Label {
            width: parent.width
            font.pixelSize: units.gu(5)
            font.bold: true
            color: UbuntuColors.jet
            horizontalAlignment: Text.AlignHCenter
            text: "Clock App"
        }
        Label {
            width: parent.width
            color: UbuntuColors.ash
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("Version %1").arg("3.8.487")
        }

    }

    UbuntuListView {
         anchors {
            top: aboutCloumn.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(2)
         }

         currentIndex: -1
         interactive: false

         model :infoModel
         delegate: ListItem {
            ListItemLayout {
             title.text : model.name
             Icon {
                 width:units.gu(2)
                 name:"go-to"
             }
            }
            onClicked: Qt.openUrlExternally(model.url)


         }

    }

}
