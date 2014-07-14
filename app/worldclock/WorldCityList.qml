/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
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
                    sortedTimeZoneModel.filter.pattern = RegExp("")
                    worldCityList.state = "default"
                }
            }

            contents: TextField {
                id: searchField

                anchors {
                    left: parent ? parent.left : undefined
                    right: parent ? parent.right : undefined
                    rightMargin: units.gu(2)
                }

                onTextChanged: {
                    sortedTimeZoneModel.filter.property = "city"
                    sortedTimeZoneModel.filter.pattern = RegExp(searchField.text)
                }
            }
        }
    ]

    XmlTimeZoneModel {
        id: timeZoneModel
        updateInterval: 1000
        source: Qt.resolvedUrl("world-city-list.xml")
    }

    SortFilterModel {
        id: sortedTimeZoneModel
        model: timeZoneModel
        sort.property: "city"
        sort.order: Qt.AscendingOrder
    }

    ListView {
        id: cityList

        anchors.fill: parent

        model: sortedTimeZoneModel

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

            height: units.gu(7)
            showDivider: false

            Column {
                id: _labelColumn

                anchors.verticalCenter: parent.verticalCenter

                Label {
                    id: _cityName
                    fontSize: "medium"
                    text: city
                    color: UbuntuColors.midAubergine
                }

                Label {
                    id: _countryName
                    text: country
                    fontSize: "xx-small"
                }
            }

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
                console.log("Add city to U1DB Model")
            }
        }
    }
}
