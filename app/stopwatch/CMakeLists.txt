file(GLOB STOPWATCH_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_stopwatch_QMlFiles ALL SOURCES ${STOPWATCH_QML_JS_FILES})

install(FILES ${STOPWATCH_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/stopwatch)
