include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_definitions(
  -DGETTEXT_PACKAGE=\"${PROJECT_NAME}\"
  -DGETTEXT_LOCALEDIR=\"${CMAKE_INSTALL_LOCALEDIR}\"
)

set(
    alarm_SRCS
    modules/Alarm/backend.cpp
    modules/Alarm/settings.cpp
    modules/Alarm/sound.cpp
)

set(
    clock_SRCS
    modules/Clock/backend.cpp
    modules/Clock/geolocation.cpp
    modules/Clock/datetime.cpp
    modules/Clock/timezonemodel.cpp
    modules/Clock/generictimezonemodel.cpp
    modules/Clock/jsontimezonemodel.cpp
    modules/Clock/statictimezonemodel.cpp
)

set(
    stopwatchlaphistory_SRCS
    modules/Stopwatch/LapHistory/backend.cpp
    modules/Stopwatch/LapHistory/history.cpp
)

add_library(alarm MODULE
    ${alarm_SRCS}
)

add_library(clock MODULE
    ${clock_SRCS}
)

add_library(stopwatchlaphistory MODULE
    ${stopwatchlaphistory_SRCS}
)

set_target_properties(alarm PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Alarm
)

set_target_properties(clock PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Clock
)

set_target_properties(stopwatchlaphistory PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Stopwatch/LapHistory
)

qt5_use_modules(alarm Gui Qml Quick DBus)
qt5_use_modules(clock Gui Qml Quick)
qt5_use_modules(stopwatchlaphistory Qml)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(alarm-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Alarm/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Alarm
    DEPENDS ${QMLFILES}
)

add_custom_target(clock-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Clock/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Clock
    DEPENDS ${QMLFILES}
)

add_custom_target(stopwatchlaphistory-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Stopwatch/LapHistory/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Stopwatch/LapHistory
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS alarm DESTINATION ${MODULE_PATH}/Alarm/)
install(FILES   modules/Alarm/qmldir DESTINATION ${MODULE_PATH}/Alarm/)

install(TARGETS clock DESTINATION ${MODULE_PATH}/Clock/)
install(FILES   modules/Clock/qmldir DESTINATION ${MODULE_PATH}/Clock/)

install(TARGETS stopwatchlaphistory DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)
install(FILES   modules/Stopwatch/LapHistory/qmldir DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)

