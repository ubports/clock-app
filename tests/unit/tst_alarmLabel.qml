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

    AlarmLabel {
        id: alarmLabelPage
        alarm: _alarm
    }

    UbuntuTestCase {
        id: alarmLabelPageTest
        name: "AlarmLabelPage"

        when: windowShown

        property var header
        property var alarmLabel
        property var backButton

        function initTestCase() {
            alarmLabelPage.visible = true
            header = findChild(mainView, "MainView_Header")
            alarmLabel = findChild(alarmLabelPage, "labelEntry")
            backButton = findChild(header, "customBackButton")
        }

        function cleanup() {
            clearTextField(alarmLabel)
            typeString("Alarm")
            alarmLabelPage.alarm.message = "Alarm"
        }

        function clearTextField(textfield) {
            // Get textfield focus by clicking once
            mouseClick(textfield, textfield.width - units.gu(2), textfield.height/2)

            // Click on the clear button shown on the right
            mouseClick(textfield, textfield.width - units.gu(2), textfield.height/2)
        }

        function test_backButtonEnabled_data() {
            return [
                        {tag: "EmptyAlarmLabel",       string: "",           enableStatus: false},
                        {tag: "BlankSpacesAlarmLabel", string: "   ",        enableStatus: false},
                        {tag: "FilledAlarmLabel",      string: "Test Label", enableStatus: true}
                    ]
        }

        /*
         Test to check if the back header button is enabled/disabled correctly
         for different alarm label scenarios.
        */
        function test_backButtonEnabled(data) {
            compare(alarmLabel.text, "Alarm", "Default alarm label is not Alarm")
            compare(backButton.enabled, true, "Back header button is not enabled by default")

            clearTextField(alarmLabel)
            typeString(data.string)

            compare(alarmLabel.text, data.string, "Alarm label is not what was type in the textfield")
            compare(backButton.enabled, data.enableStatus, "Back Button enable status is not as expected")
        }

        /*
         Test to check if the alarm label text is set to the alarm message
         when the page is loaded.
        */
        function test_alarmLabelIsSameAsAlarmMessage() {
            alarmLabelPage.alarm.message = "Random Alarm Label"
            compare(alarmLabel.text, "Random Alarm Label", "Alarm label set is not the same as alarm message")
        }
    }
}
