/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Timezone 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../upstreamcomponents"

/*
  Page to display a list of cities from which the user can choose a city to add
  to his world clocks.

  NOTE: This page design should look exactly like the Address book app in terms
  of visual design. For instance it requires the fast scroll component, section
  headers, search mode etc.
*/

Page {
    id: worldCityList
    objectName: "worldCityList"

    property bool isOnlineMode: false

    title: i18n.tr("Select a city")
    visible: false
    flickable: null

    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: worldCityList.head
            actions: [
                Action {
                    iconName: "search"
                    text: i18n.tr("City")
                    onTriggered: {
                        worldCityList.state = "search"
                        searchField.forceActiveFocus()
                    }
                }
            ]
        },

        PageHeadState {
            name: "search"
            head: worldCityList.head
            backAction: Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    searchField.text = ""
                    worldCityList.state = "default"
                    isOnlineMode = false
                }
            }

            contents: TextField {
                id: searchField

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: i18n.tr("Search...")

                anchors {
                    left: parent ? parent.left : undefined
                    right: parent ? parent.right : undefined
                    rightMargin: units.gu(2)
                }

                Timer {
                    id: search_timer
                    interval: isOnlineMode ? 1 : 500
                    repeat: false
                    onTriggered:  {
                        isOnlineMode = false
                        console.log("Search string: " + searchField.text)

                        if(!isOnlineMode && sortedTimeZoneModel.count === 0) {
                            console.log("Enabling online mode")
                            isOnlineMode = true
                        }

                        if(isOnlineMode) {
                            var url = String("%1%2%3")
                            .arg("http://geoname-lookup.ubuntu.com/?query=")
                            .arg(searchField.text)
                            .arg("&app=com.ubuntu.clock.devel&version=3.0")
                            console.log("Online URL: " + url)
                            jsonTimeZoneModel.source = Qt.resolvedUrl(url)
                        }
                    }
                }

                onTextChanged: {
                    search_timer.restart()
                }
            }
        }
    ]

    Connections {
        target: clockApp
        onApplicationStateChanged: {
            /*
              Update world city list immediately when the clock app is brought
              from suspend instead of waiting for the next minute to update.
            */
            if(applicationState)
                xmlTimeZoneModel.update()
        }
    }

    JsonTimeZoneModel {
        id: jsonTimeZoneModel
        updateInterval: 60000
    }

    XmlTimeZoneModel {
        id: xmlTimeZoneModel
        updateInterval: 60000
        source: Qt.resolvedUrl("world-city-list.xml")
    }

    SortFilterModel {
        id: sortedTimeZoneModel
        model: isOnlineMode ? jsonTimeZoneModel : xmlTimeZoneModel
        sort.property: "city"
        sort.order: Qt.AscendingOrder
        filter.property: "city"
        filter.pattern: RegExp(searchField.text, "gi")
    }

    Label {
        id: onlineStateLabel
        visible: text != ""
        text: {
            if (isOnlineMode) {
                if(jsonTimeZoneModel.status === JsonTimeZoneModel.Loading) {
                    return i18n.tr("Searching for a city")
                }

                else if(jsonTimeZoneModel.status === JsonTimeZoneModel.Ready
                        && sortedTimeZoneModel.count === 0) {
                    return i18n.tr("No City Found")
                }

                else if(jsonTimeZoneModel.status === JsonTimeZoneModel.Error
                        && sortedTimeZoneModel.count === 0) {
                    return i18n.tr("<b>%1</b> %2")
                    .arg("Unable to connect.")
                    .arg("Please check your network connection and try again")
                }

                else {
                    return ""
                }
            }

            else {
                return ""
            }
        }

        width: parent.width
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        anchors {
            left: parent.left
            right: parent.right
            margins: units.gu(2)
            top: parent.top
            topMargin: units.gu(4)
        }
    }

    ActivityIndicator {
        running: jsonTimeZoneModel.status === JsonTimeZoneModel.Loading
                 && isOnlineMode
        anchors {
            top: onlineStateLabel.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
    }

    ListView {
        id: cityList
        objectName: "cityList"

        function addWorldCity(city, country, timezone) {
            console.log("[LOG]: Adding city to U1db Database")
            clockDB.putDoc
                    (
                        {
                            "worldlocation":
                            {
                                "city": city,
                                "country": country,
                                "timezone": timezone
                            }
                        },
                        encodeURIComponent(city + "_" + country)
                        )
        }

        function getSectionText(index) {
            return sortedTimeZoneModel.get(index).city.substring(0,1)
        }

        onFlickStarted: {
            Qt.inputMethod.hide()
        }

        anchors.fill: parent
        anchors.rightMargin: fastScroll.showing ? fastScroll.width - units.gu(1)
                                                : 0

        model: sortedTimeZoneModel
        currentIndex: -1

        clip: true

        section.property: "city"
        section.criteria: ViewSection.FirstCharacter
        section.labelPositioning: ViewSection.InlineLabels

        section.delegate: ListItem.Header {
            anchors.margins: units.gu(2)
            Label {
                /*
                  Ideally we wouldn't need this label inside a listitem header,
                  however the default header text is indented right 2 gu which
                  doesn't match design spec.
                */
                text: section
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        delegate: ListItem.Base {
            showDivider: false
            objectName: "worldCityItem" + index

            Column {
                id: worldCityDelegateColumn

                anchors {
                    left: parent.left
                    right: _localTime.left
                    rightMargin: units.gu(1)
                    verticalCenter: parent.verticalCenter
                }

                Label {
                    text: city
                    width: parent.width
                    elide: Text.ElideRight
                    color: UbuntuColors.midAubergine
                }

                Label {
                    text: country
                    fontSize: "xx-small"
                    width: parent.width
                    elide: Text.ElideRight
                }
            }

            Label {
                id: _localTime
                text: localTime
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }

            onClicked: {
                var tempCountry = country.split(",")
                if(tempCountry.length > 2) {
                    cityList.addWorldCity(city, tempCountry[1] + ","
                                          + tempCountry[2], timezoneID)
                } else {
                    cityList.addWorldCity(city, country, timezoneID)
                }

                mainStack.pop()
            }
        }

        Behavior on anchors.rightMargin {
            UbuntuNumberAnimation {}
        }
    }

    FastScroll {
        id: fastScroll

        listView: cityList

        enabled: (cityList.contentHeight > (cityList.height * 2)) &&
                 (cityList.height >= minimumHeight)

        anchors {
            top: cityList.top
            topMargin: units.gu(1.5)
            bottom: cityList.bottom
            right: parent.right
        }
    }
}
