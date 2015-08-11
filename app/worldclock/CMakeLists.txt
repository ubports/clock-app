set(WORLDCLOCK_QML_JS_FILES
    AddWorldCityButton.qml
    UserWorldCityDelegate.qml
    UserWorldCityList.qml
    WorldCityList.qml
)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_worldclock_QMlFiles ALL SOURCES ${WORLDCLOCK_QML_JS_FILES})

install(FILES ${WORLDCLOCK_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/worldclock)
