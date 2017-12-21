/*
 * Copyright (C) 2014-2016 Canonical Ltd
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

import QtQuick 2.4
import WorldClock 1.0
import Ubuntu.Components 1.3
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
    property alias jsonTimeZoneModel: jsonTimeZoneModelLoader.item
    property alias staticTimeZoneModel: staticTimeZoneModelLoader.item

    Component.onCompleted: {
        /*
         Load the predefined city list model *only* after the page has loaded
         to improve the loading time preception of the user.
       */
        staticTimeZoneModelLoader.sourceComponent = staticTimeZoneModelComponent
    }

    visible: false
    header: standardHeader

    PageHeader {
        id: standardHeader

        title: i18n.tr("Select a city")
        flickable: null
        visible: worldCityList.header === standardHeader
        trailingActionBar.actions: [
            Action {
                objectName: "searchButton"
                iconName: "search"
                text: i18n.tr("City")
                onTriggered: {
                    worldCityList.header = searchHeader
                    searchComponentLoader.sourceComponent = searchComponent
                    jsonTimeZoneModelLoader.sourceComponent = jsonTimeZoneModelComponent
                    searchComponentLoader.item.forceActiveFocus()
                }
            }
        ]
    }

    PageHeader {
        id: searchHeader

        flickable: null
        visible: worldCityList.header === searchHeader

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    cityList.forceActiveFocus()
                    searchComponentLoader.item.text = ""
                    worldCityList.header = standardHeader
                    isOnlineMode = false
                    searchComponentLoader.sourceComponent = undefined
                    jsonTimeZoneModelLoader.sourceComponent = undefined
                }
            }
        ]

        contents: Loader {
            id: searchComponentLoader
            anchors {
                left: parent ? parent.left : undefined
                right: parent ? parent.right : undefined
                verticalCenter: parent ? parent.verticalCenter : undefined
            }
        }
    }

    Component {
        id: searchComponent
        TextField {
            id: searchField
            objectName: "searchField"

            inputMethodHints: Qt.ImhNoPredictiveText
            placeholderText: i18n.tr("Search...")

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
                        .arg("&app=com.ubuntu.clock&version=3.9.x")
                        console.log("Online URL: " + url)
                        if (jsonTimeZoneModelLoader.status === Loader.Ready) {
                            jsonTimeZoneModel.source = Qt.resolvedUrl(url)
                        }
                    }
                }
            }

            onTextChanged: {
                search_timer.restart()
            }
        }
    }

    Connections {
        target: rootWindow
        onApplicationStateChanged: {
            /*
              Update world city list immediately when the clock app is brought
              from suspend instead of waiting for the next minute to update.
            */
            if(applicationState)
                staticTimeZoneModel.update()
        }
    }

    /*
     Loader to allow for dynamic loading/unloading of the json model only when
     necessary.
    */
    Loader {
        id: jsonTimeZoneModelLoader
        asynchronous: true
    }

    Component {
        id: jsonTimeZoneModelComponent
        JsonTimeZoneModel {
            updateInterval: 60000
        }
    }

    Loader {
        id: staticTimeZoneModelLoader
        asynchronous: true
    }

    Component {
        id: staticTimeZoneModelComponent
        StaticTimeZoneModel {
            updateInterval: 60000
        }
    }

    SortFilterModel {
        id: sortedTimeZoneModel

        model: {
            if (isOnlineMode && jsonTimeZoneModelLoader.status === Loader.Ready) {
                return jsonTimeZoneModel
            }

            else  if (staticTimeZoneModelLoader.status === Loader.Ready) {
                return staticTimeZoneModel
            }

            else {
                return undefined
            }
        }

        sort.property: "cityName"
        sort.order: Qt.AscendingOrder
        filter.property: "cityName"
        filter.pattern: searchComponentLoader.status === Loader.Ready ? RegExp(searchComponentLoader.item.text, "gi")
                                                                      : RegExp("", "gi")
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
                    return String("<b>%1</b> %2")
                    .arg(i18n.tr("Unable to connect."))
                    .arg(i18n.tr("Please check your network connection and try again"))
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
            top: worldCityList.header.bottom
            topMargin: units.gu(4)
        }
    }

    ActivityIndicator {
        running: {
            if (jsonTimeZoneModelLoader.status === Loader.Ready && isOnlineMode) {
                return jsonTimeZoneModel.status === JsonTimeZoneModel.Loading
            } else {
                return false
            }
        }
        anchors {
            top: onlineStateLabel.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
    }

    ListView {
        id: cityList
        objectName: "cityList"
        currentIndex: -1

        function addWorldCity(cityId, countryName, timezone) {
            console.log("[LOG]: Adding " + cityId.toString() + " city to U1db Database")
            clockDB.putDoc
                    (
                        {
                            "worldlocation":
                            {
                                "city": cityId,
                                "country": countryName.replace("'"," "),
                                "timezone": timezone
                            }
                        },
                        // Apostrophes are forbidden by database, so we replace it with spaces.
                        // It will be replaced/translated next time after read from database.
                        // Country field is used only by jsonTimeZoneModel (lp: #1473074).
                        encodeURIComponent(cityId + "_" + countryName.replace("'"," "))
                        )
        }

        function getSectionText(index) {
            return sortedTimeZoneModel.get(index).cityName.substring(0,1)
        }

        onFlickStarted: {
            forceActiveFocus()
        }

        anchors {
            top: worldCityList.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            rightMargin: fastScroll.showing ? fastScroll.width - units.gu(1)
                                            : 0
        }

        model: sortedTimeZoneModel
        clip: true

        section.property: "cityName"
        section.criteria: ViewSection.FirstCharacter
        section.labelPositioning: ViewSection.InlineLabels

        section.delegate: ListItem {
            height: header.implicitHeight + units.gu(2)
            Label {
                id: header
                text: section
                font.weight: Font.DemiBold
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        delegate: ListItem {
            divider.visible: false
            objectName: "defaultWorldCityItem" + index
            height: worldCityListItemLayout.height

            ListItemLayout {
                id: worldCityListItemLayout

                title.text: cityName
                title.objectName: "defaultCityNameText"
                subtitle.text: countryName
                subtitle.textSize: Label.Medium
                subtitle.objectName: "defaultCountryNameText"

                padding.top: units.gu(1.5)
                padding.bottom: units.gu(1.5)

                Label {
                    id: _localTime
                    text: localizedZoneTime
                    SlotsLayout.position: SlotsLayout.Trailing
                }
            }

            onClicked: {
                var splittedCountryName = countryName.split(",")
                if(splittedCountryName.length > 2) {
                    cityList.addWorldCity(cityId,
                                          splittedCountryName[1] + "," + splittedCountryName[2],
                                          timezoneID)
                } else {
                    cityList.addWorldCity(cityId, countryName, timezoneID)
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
