import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Test 1.0
import Ubuntu.Components 1.1
import "../../app/alarm"

Item {
    width: units.gu(40)
    height: units.gu(70)

    MainView {
        id: mainView

        anchors.fill: parent
        useDeprecatedToolbar: false

        Alarm {
            id: _alarm
        }

        AlarmLabel {
            id: alarmLabelPage
            alarm: _alarm
        }
    }

    UbuntuTestCase {
        id: alarmLabelPageTest
        name: "alarmLabelPage"

        when: windowShown

        property var header

        function initTestCase() {
            alarmLabelPage.visible = true
            alarmLabelPageTest.header = findChild(mainView, "MainView_Header")
        }

        function test_backButtonDisabledOnEmptyAlarmLabel() {
            var alarmLabel = findChild(alarmLabelPage, "labelEntry")
            var backButton = findChild(header, "customBackButton")

            compare(backButton.enabled, true, "Back Button is enabled by default due to placeholder alarm label")

            tryCompare(alarmLabel, "text", "Alarm", 0, "Default alarm label")

            // Get textfield focus by clicking once
            mouseClick(alarmLabel, alarmLabel.width - units.gu(2), alarmLabel.height/2)

            // When textfield is focused, click on the clear button shown on the right
            mouseClick(alarmLabel, alarmLabel.width - units.gu(2), alarmLabel.height/2)

            tryCompare(alarmLabel, "text", "", 0, "Alarm label is empty")

            compare(backButton.enabled, false, "Back Button is disabled since alarm label is empty")
        }
    }
}
