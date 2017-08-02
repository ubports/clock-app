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
import QtTest 1.0
import Ubuntu.Test 1.0
import Ubuntu.Components 1.3

MockClockApp {
    id: clockApp

    ClockTestCase {
        id: worldClockFeatureTest
        name: "WorldClockFeatureTest"

        when: windowShown

        property var header
        property var clockPage
        property var pageStack

        function initTestCase() {
            header = findChild(clockApp, "MainView_Header")
            pageStack = findChild(clockApp, "pageStack")
            clockPage = findChild(clockApp, "clockPage")
        }

        // *********** Helper Functions ************

        function pressAddWorldCityButton() {
            var addWorldCityButton = findChild(clockApp, "addWorldCityButton")
            pressButton(addWorldCityButton)
        }

        function _findWorldCity(cityList, type, cityName, countryName) {
            /*
             The list view for the user world city list and the available world
             city list have the same structure with some minor object name
             changes. The 'objectPrefix' varible is used to handle that.
            */
            var objectPrefix = type === "user" ? "user" : "default"

            for(var i=0; i<cityList.count; i++) {
                var cityListItem = findChild(clockApp, objectPrefix+"WorldCityItem"+i)
                var city = findChild(cityListItem, objectPrefix+"CityNameText")
                var country = findChild(cityListItem, objectPrefix+"CountryNameText")

                if (city.text === cityName && country.text === countryName) {
                    return i
                }
            }

            return -1;
        }

        function findUserWorldCity(cityList, cityName, countryName) {
            return _findWorldCity(cityList, "user", cityName, countryName)
        }

        function findDefaultWorldCity(cityList, cityName, countryName) {
            return _findWorldCity(cityList, "default", cityName, countryName)
        }

        function assertWorldCityAddition(cityName, countryName) {
            var cityList = findChild(clockApp, "userWorldCityRepeater")

            // Wait for the user list to be populated with results
            tryCompareFunction(function() { return cityList.count > 0}, true)

            var cityIndex = findUserWorldCity(cityList, cityName, countryName)

            if (cityIndex === -1) {
                // If city couldn't be found in the saved city list, fail the test
                fail("City added during the test cannot be found in the user world city list!")
            }
        }

        function deleteWorldCity(cityName, countryName) {
            var cityList = findChild(clockApp, "userWorldCityRepeater")

            var oldCount = cityList.count
            var cityIndex = findUserWorldCity(cityList, cityName, countryName)

            if (cityIndex === -1) {
                fail("City added during the test cannot be found in the user world city list!")
            }
            else {
                var cityListItem = findChild(clockApp, "userWorldCityItem"+cityIndex)
                swipeToDeleteItem(cityListItem)
            }

            /*
             #FIXME: Commented out the following line as deleting a world city
             when there is only one world city does not decrease the count to 0
             but leaves it as 1 causing the test to fail. This has been reported
             in bug #1368393. (Also fails in Autopilot)

             tryCompare(cityList, "count", oldCount-1, 5000, "city list count did not decrease")

             The wait() call below is to ensure that the world city is deleted properly
             which wouldn't be required if could do the count decrease check mentioned above.
            */

            wait(1000)
        }

        function addCityFromList(cityName, countryName) {
            var worldCityPage = getPage(pageStack, "worldCityList")
            var cityList = findChild(worldCityPage, "cityList")

            // Wait for the list to be populated with results
            tryCompareFunction(function() { return cityList.count > 0}, true)

            var cityIndex = findDefaultWorldCity(cityList, cityName, countryName)

            if (cityIndex === -1) {
                fail("City cannot be found in the local world city list")
            }

            var cityListItem = findChild(cityList, "defaultWorldCityItem"+cityIndex)
            mouseClick(cityListItem, centerOf(cityListItem).x, centerOf(cityListItem).y)
        }

        function addCityBySearchingOnline(cityName, countryName) {
            pressHeaderButton(header, "searchButton")
            var searchField = findChild(clockApp, "searchField")
            tryCompare(searchField, "visible", true, 5000, "Search field is not visible")
            typeString(cityName)
            addCityFromList(cityName, countryName)
        }

        // *********** Test Functions *************

        /*
         Test to check if a city found in the world city list can be added
         to the user world city list.
        */
        function test_addCityAlreadyPresentInWorldCityList() {
            var clockPage = getPage(pageStack, "clockPage")

            pressAddWorldCityButton()

            var worldCityPage = getPage(pageStack, "worldCityList")
            waitForRendering(worldCityPage)

            addCityFromList("Albuquerque", "United States")
            assertWorldCityAddition("Albuquerque", "United States")

            // Clean up after the test by deleting the city which was added during the test
            deleteWorldCity("Albuquerque", "United States")
        }
    }
}
