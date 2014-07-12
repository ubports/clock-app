file(GLOB QML_JS_FILES *.qml *.js *.png)

# make the files visible on qtcreator
add_custom_target(ubuntu-clock-app_QMlFiles ALL SOURCES ${QML_JS_FILES})

# substitute variables in the desktop file
set(DESKTOP_FILE "ubuntu-clock-app.desktop")
configure_file(${DESKTOP_FILE}.in ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE} DESTINATION ${DESKTOP_DIR})
install(FILES ${QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK-APP_DIR})

add_subdirectory(clock)
add_subdirectory(alarm)
add_subdirectory(graphics)
add_subdirectory(components)
