set(ALARM_QML_JS_FILES
    AlarmDelegate.qml
    AlarmLabel.qml
    AlarmList.qml
    AlarmModelComponent.qml
    AlarmPage.qml
    AlarmRepeat.qml
    AlarmSettingsPage.qml
    AlarmSound.qml
    AlarmUtils.qml
    EditAlarmPage.qml
    SoundPeerPicker.qml
)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_alarm_QMlFiles ALL SOURCES ${ALARM_QML_JS_FILES})

install(FILES ${ALARM_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/alarm)
