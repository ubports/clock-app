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
import QtTest 1.0
import Ubuntu.Test 1.0
import Ubuntu.Components 1.1

MockClockApp {
    id: clockApp

    Utils {
        id: utils
    }

    UbuntuTestCase {
        id: worldClockFeatureTest
        name: "WorldClockFeatureTest"

        when: windowShown

        property var header
        property var backButton
        property var clockPage

        function initTestCase() {
            header = findChild(clockApp, "MainView_Header")
            backButton = findChild(header, "customBackButton")
            clockPage = findChild(clockApp, "clockPage")
        }

        // *********** Helper Functions ************

        function _pressAddWorldCityButton() {
            var addWorldCityButton = findChild(clockApp, "addWorldCityButton")
            utils.pressButton(addWorldCityButton)
        }

        function _findWorldCity(cityList, type, cityName, countryName) {
            var objectPrefix = type === "user" ? "user" : "default"
            for(var i=0; i<=cityList.count; i++) {
                var cityListItem = findChild(clockApp, objectPrefix+"WorldCityItem"+i)
                var city = findChild(cityListItem, objectPrefix+"CityNameText")
                var country = findChild(cityListItem, objectPrefix+"CountryNameText")
                if (city.text === cityName && country.text === countryName) {
                    return i
                }
            }

            return -1;
        }

        function _confirmWorldCityAddition(cityName, countryName) {
            var cityList = findChild(clockApp, "userWorldCityRepeater")
            tryCompareFunction(function() { return cityList.count > 0}, true)

            var cityIndex = _findWorldCity(cityList, "user", cityName, countryName)

            if (cityIndex === -1) {
                fail("Couldn't locate city to confirm world city addition")
            }
        }

        function _deleteWorldCity(cityName, countryName) {
            var cityList = findChild(clockApp, "userWorldCityRepeater")
            tryCompareFunction(function() { return cityList.count > 0}, true)

            var cityIndex = _findWorldCity(cityList, "user", cityName, countryName)

            if (cityIndex === -1) {
                fail("Couldn't locate city to confirm world city addition")
            } else {
                var cityListItem = findChild(clockApp, "userWorldCityItem"+cityIndex)
                utils.swipeToDeleteItem(cityListItem)
            }

            //tryCompare(cityList, "count", 0, 5000, "city list count did not decrease")
        }

        function _addCityFromLocalList(cityList, type, cityName, countryName) {
            var cityIndex = _findWorldCity(cityList, type, cityName, countryName)

            if (cityIndex === -1) {
                fail("City cannot be found in the local city list")
            }

            var cityListItem = findChild(cityList, "defaultWorldCityItem"+cityIndex)
            mouseClick(cityListItem, centerOf(cityListItem).x, centerOf(cityListItem).y)
        }

        // *********** Test Functions *************

        function test_addLocalWorldCity() {
            var pageStack = findChild(clockApp, "pageStack")
            var clockPage = utils.getPage(pageStack, "clockPage")

            _pressAddWorldCityButton()

            var worldCityPage = utils.getPage(pageStack, "worldCityList")
            waitForRendering(worldCityPage)

            var cityList = findChild(worldCityPage, "cityList")
            tryCompareFunction(function() { return cityList.count > 0}, true)

            _addCityFromLocalList(cityList, "default", "Amsterdam", "Netherlands")

            waitForRendering(clockPage)

            _confirmWorldCityAddition("Amsterdam", "Netherlands")

            _deleteWorldCity("Amsterdam", "Netherlands")
        }
    }
}
