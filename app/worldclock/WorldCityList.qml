import QtQuick 2.0
import Timezone 1.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: worldCityList

    title: i18n.tr("Select a city")
    visible: false

    TimeZoneModel {
        id: timeZoneModel
        source: Qt.resolvedUrl("world-city-list.xml")
        updateInterval: 1000
    }

    ListView {
        id: cityList

        anchors.fill: parent
        model: timeZoneModel

        delegate: ListItem.Subtitled {
            text: city + "," + country
            subText: timezoneID + "(" + localTime + ")"

            onClicked: {
                print(model.timezoneID, model.localTime)
            }
        }
    }
}
