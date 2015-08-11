set(CLOCK_QML_JS_FILES
    ClockPage.qml
    MainClock.qml
)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_clock_QMlFiles ALL SOURCES ${CLOCK_QML_JS_FILES})

install(FILES ${CLOCK_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/clock)
