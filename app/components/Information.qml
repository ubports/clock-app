import QtQuick 2.0
import Ubuntu.Components 1.3

Page {

    header: PageHeader {
        id:infoHeader
        title: i18n.tr("Information")

    }

    ListModel {
       id: infoModel
     }

    Component.onCompleted: {
        infoModel.append({ name: i18n.tr("Get the source"), url: "https://github.com/ubports/clock-app" })
        infoModel.append({ name: i18n.tr("Report Issues"), url: "https://github.com/ubports/clock-app/issues" })
        infoModel.append({ name: i18n.tr("Help Translate"), url: "https://ubpweblate.tnvcomp.com/projects/ubports/clock-app/" })
    }

    UbuntuListView {
         anchors.fill: parent
         anchors.topMargin: infoHeader.height
         currentIndex: -1

         model :infoModel
         delegate: ListItem {
            ListItemLayout {
             title.text : model.name
            }
            onClicked: Qt.openUrlExternally(model.url)
         }

    }
}
