import QtQuick 2.0
import Timezone 1.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: worldCityList

    title: i18n.tr("Select a city")
    visible: false

    XmlListModel {
        id: worldCityModel;

        source: Qt.resolvedUrl("world-city-list.xml")
        query: "/Cities/City"

        XmlRole { name: "city"; query: "cityName/string()"; isKey: true }
        XmlRole { name: "country"; query: "countryName/string()"; isKey: true }
        XmlRole { name: "timezoneID"; query: "timezoneID/string()"; isKey: true }
    }

    Zone {
        id: cityTimezone
    }

    ListView {
        id: cityList

        anchors.fill: parent
        model: worldCityModel

        delegate: ListItem.Subtitled {
            text: city + "," + country
            subText: timezoneID
        }
    }
}
