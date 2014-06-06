file(GLOB CLOCK_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_clock_QMlFiles ALL SOURCES ${CLOCK_QML_JS_FILES})

install(FILES ${CLOCK_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK-APP_DIR}/clock)
