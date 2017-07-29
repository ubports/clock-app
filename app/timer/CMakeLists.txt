set(TIMER_QML_JS_FILES
    TimerFace.qml
    TimerPage.qml
    TimerListDelegate.qml
    TimerListView.qml
)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_timer_QMlFiles ALL SOURCES ${TIMER_QML_JS_FILES})

install(FILES ${TIMER_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/timer)
