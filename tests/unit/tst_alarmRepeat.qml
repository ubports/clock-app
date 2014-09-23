import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Test 1.0
import Ubuntu.Components 1.1
import "../../app/alarm"

MainView {
    id: mainView

    width: units.gu(40)
    height: units.gu(70)
    useDeprecatedToolbar: false

    Alarm {
        id: _alarm
    }

    Component {
        id: alarmRepeatPage
        AlarmRepeat {
            alarm: _alarm
        }
    }

    Loader {
        id: alarmRepeatPageLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    UbuntuTestCase {
        id: alarmRepeatPageTest
        name: "AlarmRepeatPage"

        when: windowShown

        property var header
        property var backButton
        property var repeater
        property var today: Qt.locale().standaloneDayName(
                                new Date().getDay(), Locale.LongFormat)

        function init() {
            alarmRepeatPageLoader.sourceComponent = alarmRepeatPage
            alarmRepeatPageLoader.item.visible = true
            header = findChild(mainView, "MainView_Header")
            backButton = findChild(header, "customBackButton")
            repeater = findChild(alarmRepeatPageLoader.item, "alarmDays")
        }

        function cleanup() {
            alarmRepeatPageLoader.sourceComponent = undefined
            _alarm.reset()
            // TEST FAILS HERE!
            // _alarm.reset() is supposed to reset Alarm to OneTime. Not sure why it doesn't
            tryCompare(_alarm, "type", Alarm.OneTime, 5000, "Alarm Type is not one time by default")
            tryCompare(_alarm, "status", Alarm.Ready)
        }

        /*
         Test to check if none of the switches are checked by default since by
         default an alarm is an one-time alarm and in the repeat page none of
         the days must be checked
        */
        function test_allSwitchesAreUncheckedByDefault() {
            waitForRendering(alarmRepeatPageLoader.item);

            tryCompare(_alarm, "daysOfWeek", 0, 3000, "Alarm days of weeks is not 0 by default")

            for(var i=0; i<repeater.count; i++) {
                var currentDayLabel = findChild(alarmRepeatPageLoader.item, "alarmDay"+i)
                var currentDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+i)

                compare(currentDaySwitch.checked, false, "All switches are not disabled by default")
            }
        }

        /*
         Test to check if the alarm types are being correctly changed when
         toggling some of the swtiches. So if a switch is toggle, the alarm
         should become a repeating alarm. if no switches are enabled then
         it should be a one time alarm.
        */
        function test_alarmTypeSwitch() {
            waitForRendering(alarmRepeatPageLoader.item);

            // TEST FAILS HERE //
            // Alarm should be one-time by default. By the test before this
            // changed the value and the alarm.reset() in the cleanup doesn't
            // seem to do its job.

            // test_alarmObjectSetsSwitchStatus() is run before this test. And in
            // that test I set the alarm type to repeating. However the cleanup
            // should reset back to one-time when calling the alarm.reset() function.

            tryCompare(_alarm, "type", Alarm.OneTime, 3000, "Alarm type is not OneTime by default")

            var dayListItem = findChild(alarmRepeatPageLoader.item, "alarmDay"+3)

            mouseClick(dayListItem, centerOf(dayListItem).x, centerOf(dayListItem).y)
            tryCompare(_alarm, "type", Alarm.Repeating, 3000, "Alarm type did not change to Repeating despite enabling a switch")

            mouseClick(dayListItem, centerOf(dayListItem).x, centerOf(dayListItem).y)
            tryCompare(_alarm, "type", Alarm.OneTime, 3000, "Alarm type is not OneTime despite all switches disabled")
        }

        /*
         Test to enable all switches and check if the alarm object has been
         updated correctly
        */
        function test_switchStatusUpdatesAlarmObject() {
            waitForRendering(alarmRepeatPageLoader.item);

            for(var i=0; i<repeater.count; i++) {
                var dayListItem = findChild(alarmRepeatPageLoader.item, "alarmDayHolder"+i)
                var currentDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+i)

                if(!currentDaySwitch.checked) {
                    mouseClick(dayListItem, dayListItem.width/2, dayListItem.height/2)
                }
            }

            compare(alarmRepeatPageLoader.item.alarm.daysOfWeek, 127, "Alarm Object daysOfWeek value is incorrect w.r.t to the UI")
        }

        /*
         Test to check if the switches are properly toggled based on the alarm
         days of week. This is required when editing an alarm where the switch
         should properly show the days previously selected by the user.
        */
        function test_alarmObjectSetsSwitchStatus() {
            _alarm.type = Alarm.Repeating
            _alarm.daysOfWeek = 96 // Enabled saturday and sunday

            for(var i=0; i<repeater.count; i++) {
                var currentDayLabel = findChild(alarmRepeatPageLoader.item, "alarmDay"+i)
                var currentDaySwitch = findChild(alarmRepeatPageLoader.item, "daySwitch"+i)

                if(currentDayLabel.text === Qt.locale().standaloneDayName(6, Locale.LongFormat) ||
                        currentDayLabel.text === Qt.locale().standaloneDayName(0, Locale.LongFormat)) {
                    compare(currentDaySwitch.checked, true, "Switches in the alarm daysOfWeek are not enabled!")
                }

                else {
                    compare(currentDaySwitch.checked, false, "Switches other than those set in the alarm dayOfWeek are enabled")
                }
            }
        }
    }
}
