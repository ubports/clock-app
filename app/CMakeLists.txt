file(GLOB QML_JS_FILES *.qml *.js *.png)

# make the files visible on qtcreator
add_custom_target(ubuntu-clock-app_QMlFiles ALL SOURCES ${QML_JS_FILES})

install(FILES ${QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK-APP_DIR})

add_subdirectory(clock)
add_subdirectory(alarm)
add_subdirectory(graphics)
add_subdirectory(components)
add_subdirectory(worldclock)
add_subdirectory(upstreamcomponents)
