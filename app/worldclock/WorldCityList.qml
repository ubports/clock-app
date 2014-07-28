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

/*
  Page to display a list of cities from which the user can choose a city to add
  to his world clocks.

  NOTE: This page design should look exactly like the Address book app in terms
  of visual design. For instance it requires the fast scroll component, section
  headers, search mode etc.
*/

Page {
    id: worldCityList

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
                }
            }

            contents: TextField {
                id: searchField

                inputMethodHints: Qt.ImhNoPredictiveText

                anchors {
                    left: parent ? parent.left : undefined
                    right: parent ? parent.right : undefined
                    rightMargin: units.gu(2)
                }

                onTextChanged: {
                    sortedTimeZoneModel.filter.property = "city"
                    sortedTimeZoneModel.filter.pattern = RegExp(searchField.text, "gi")
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
                timeZoneModel.update()
        }
    }

    XmlTimeZoneModel {
        id: timeZoneModel
        updateInterval: 60000
        source: Qt.resolvedUrl("world-city-list.xml")
    }

    SortFilterModel {
        id: sortedTimeZoneModel
        model: timeZoneModel
        sort.property: "city"
        sort.order: Qt.AscendingOrder
    }

    FastScroll {
        id: fastScroll

        listView: cityList

        anchors {
            top: cityList.top
            topMargin: units.gu(1)
            bottom: cityList.bottom
            right: parent.right
        }
    }

    ListView {
        id: cityList

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

        anchors.fill: parent
        anchors.rightMargin: fastScroll.showing ? fastScroll.width - units.gu(1)
                                                : 0

        model: sortedTimeZoneModel

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

        delegate: SubtitledListItem {
            text: city
            subText: country
            showDivider: false

            Label {
                id: _localTime
                text: localTime
                fontSize: "medium"
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }

            onClicked: {
                cityList.addWorldCity(city, country, timezoneID)
                mainStack.pop()
            }
        }

        Behavior on anchors.rightMargin {
            UbuntuNumberAnimation {}
        }
    }
}
