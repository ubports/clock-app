find_program(QMLTESTRUNNER_BIN
    NAMES qmltestrunner
    PATHS /usr/lib/*/qt5/bin
    NO_DEFAULT_PATH
)

find_program(XVFB_RUN_BIN
    NAMES xvfb-run
)

macro(DECLARE_QML_TEST TST_NAME TST_QML_FILE)
    if(USE_XVFB AND XVFB_RUN_BIN)
        set(COMMAND_PREFIX ${XVFB_RUN_BIN} -a -s "-screen 0 400x600x24")
    else()
        set(COMMAND_PREFIX "")
    endif()
    add_test(NAME ${TST_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMAND ${COMMAND_PREFIX} ${QMLTESTRUNNER_BIN} -import ${CMAKE_BINARY_DIR}/backend -input ${CMAKE_CURRENT_SOURCE_DIR}/${TST_QML_FILE}
    )
endmacro()

if(QMLTESTRUNNER_BIN)
    declare_qml_test("AlarmLabel" tst_alarmLabel.qml)
    declare_qml_test("AlarmRepeat" tst_alarmRepeat.qml)
    declare_qml_test("Alarm" tst_alarm.qml)
    declare_qml_test("AlarmSound" tst_alarmSound.qml)
    declare_qml_test("AlarmUtils" tst_alarmUtils.qml)
    #Disabling tests as it is causing segmentation fault. Most propably LP: #1475223
    #declare_qml_test("WorldClock" tst_worldClock.qml)
    declare_qml_test("StopwatchUtils" tst_stopwatchUtils.qml)
else()
    if (NOT QMLTESTRUNNER_BIN)
        message(WARNING "Qml tests disabled: qmltestrunner not found")
    else()
        message(WARNING "Qml tests disabled: xvfb-run not found")
    endif()
endif()

set(QML_TST_FILES
    tst_alarmLabel.qml
    tst_alarmRepeat.qml
    tst_alarm.qml
    tst_alarmSound.qml
    tst_alarmUtils.qml
    tst_worldClock.qml
    tst_stopwatchUtils.qml
)
add_custom_target(tst_QmlFiles ALL SOURCES ${QML_TST_FILES})

set(QML_TST_UTILS
    MockClockApp.qml
    ClockTestCase.qml
)

add_custom_target(tst_Utils ALL SOURCES ${QML_TST_UTILS})
