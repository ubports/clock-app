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

    AlarmRepeat {
        id: alarmRepeatPage
        alarm: _alarm
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

        function initTestCase() {
            alarmRepeatPage.visible = true
            header = findChild(mainView, "MainView_Header")
            backButton = findChild(header, "customBackButton")
            repeater = findChild(alarmRepeatPage, "alarmDays")
        }

        function cleanup() {
            for(var i=0; i<repeater.count; i++) {
                var currentDaySwitch = findChild(alarmRepeatPage, "daySwitch"+i)
                var currentDayLabel = findChild(alarmRepeatPage, "alarmDay"+i)

                if(today === currentDayLabel.text) {
                    currentDaySwitch.checked = true
                }

                else {
                    currentDaySwitch.checked = false
                }
            }
        }

        /*
         Test to check if the checkbox for today is checked by default
        */
        function test_todaySwitchIsChecked() {
            for(var i=0; i<repeater.count; i++) {
                var currentDayLabel = findChild(alarmRepeatPage, "alarmDay"+i)
                var currentDaySwitch = findChild(alarmRepeatPage, "daySwitch"+i)

                if(today === currentDayLabel.text) {
                    compare(currentDaySwitch.checked, true, "Today's Switch is not checked by default")
                }
                else {
                    compare(currentDaySwitch.checked, false, "Switch for days other than today are checked incorrectly")
                }
            }
        }

        function test_switchStatusUpdatesAlarmObject() {
            for(var i=0; i<repeater.count; i++) {
                var dayListItem = findChild(alarmRepeatPage, "alarmDayHolder"+i)
                var currentDaySwitch = findChild(alarmRepeatPage, "daySwitch"+i)

                if(!currentDaySwitch.checked) {
                    // #FIXME: Without this wait, it fails when running ctest -V
                    wait(2000)
                    mouseClick(dayListItem, dayListItem.width/2, dayListItem.height/2)
                }
            }

            compare(alarmRepeatPage.alarm.daysOfWeek, 127, "Alarm Object daysOfWeek value is incorrect w.r.t to the UI")
        }
    }
}
