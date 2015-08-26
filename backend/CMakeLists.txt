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
    worldclock_SRCS
    modules/WorldClock/backend.cpp
    modules/WorldClock/geolocation.cpp
    modules/WorldClock/datetime.cpp
    modules/WorldClock/timezonemodel.cpp
    modules/WorldClock/generictimezonemodel.cpp
    modules/WorldClock/jsontimezonemodel.cpp
    modules/WorldClock/statictimezonemodel.cpp
)

set(
    stopwatchlaphistory_SRCS
    modules/Stopwatch/LapHistory/backend.cpp
    modules/Stopwatch/LapHistory/history.cpp
)

add_library(alarm MODULE
    ${alarm_SRCS}
)

add_library(worldclock MODULE
    ${worldclock_SRCS}
)

add_library(stopwatchlaphistory MODULE
    ${stopwatchlaphistory_SRCS}
)

set_target_properties(alarm PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Alarm
)

set_target_properties(worldclock PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY WorldClock
)

set_target_properties(stopwatchlaphistory PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Stopwatch/LapHistory
)

qt5_use_modules(alarm Gui Qml Quick DBus)
qt5_use_modules(worldclock Gui Qml Quick)
qt5_use_modules(stopwatchlaphistory Qml)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(alarm-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Alarm/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Alarm
    DEPENDS ${QMLFILES}
)

add_custom_target(worldclock-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/WorldClock/qmldir ${CMAKE_CURRENT_BINARY_DIR}/WorldClock
    DEPENDS ${QMLFILES}
)

add_custom_target(stopwatchlaphistory-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Stopwatch/LapHistory/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Stopwatch/LapHistory
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS alarm DESTINATION ${MODULE_PATH}/Alarm/)
install(FILES   modules/Alarm/qmldir DESTINATION ${MODULE_PATH}/Alarm/)

install(TARGETS worldclock DESTINATION ${MODULE_PATH}/WorldClock/)
install(FILES   modules/WorldClock/qmldir DESTINATION ${MODULE_PATH}/WorldClock/)

install(TARGETS stopwatchlaphistory DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)
install(FILES   modules/Stopwatch/LapHistory/qmldir DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)

