file(GLOB ALARM_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_alarm_QMlFiles ALL SOURCES ${ALARM_QML_JS_FILES})

install(FILES ${ALARM_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK-APP_DIR}/alarm)
