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

Page {
    id: worldCityList

    title: i18n.tr("Select a city")
    visible: false

    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: worldCityList.head
            actions: Action {
                iconName: "search"
                onTriggered: worldCityList.state = "search"
            }
        },

        PageHeadState {
            id: headerState
            name: "search"
            head: worldCityList.head
            backAction: Action {
                id: leaveSearchAction
                text: "back"
                iconName: "back"
                onTriggered: worldCityList.state = "default"
            }
            contents: TextField {
                enabled: false
                anchors {
                    /*
                      #FIXME: The left and right anchoring causes a warning
                      message to type during run time. Investigate why.
                      TypeError: Cannot read property of null
                    */
                    left: parent.left
                    right: parent.right
                    rightMargin: units.gu(2)
                }
            }
        }
    ]

    TimeZoneModel {
        id: timeZoneModel
        updateInterval: 1000
        source: Qt.resolvedUrl("world-city-list.xml")
    }

    ListView {
        id: cityList

        anchors.fill: parent
        model: timeZoneModel

        Component {
            id: sectionHeading
            ListItem.Header {
                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: units.gu(2)
                    }

                    text: section
                    color: Theme.palette.normal.baseText
                    fontSize: "medium"
                }
            }
        }

        section.property: "city"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: sectionHeading;
        section.labelPositioning: ViewSection.InlineLabels

        delegate: ListItem.Base {

            height: units.gu(7)

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
