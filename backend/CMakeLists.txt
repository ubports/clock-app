include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_definitions(
  -DGETTEXT_PACKAGE=\"${PROJECT_NAME}\"
  -DGETTEXT_LOCALEDIR=\"${CMAKE_INSTALL_LOCALEDIR}\"
)

set(
    timezone_SRCS
    modules/Timezone/backend.cpp
    modules/Timezone/timezonemodel.cpp
    modules/Timezone/generictimezonemodel.cpp
    modules/Timezone/jsontimezonemodel.cpp
    modules/Timezone/statictimezonemodel.cpp
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
)

set(
    stopwatchlaphistory_SRCS
    modules/Stopwatch/LapHistory/backend.cpp
    modules/Stopwatch/LapHistory/history.cpp
)

add_library(timezone MODULE
    ${timezone_SRCS}
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

set_target_properties(timezone PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timezone
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

qt5_use_modules(timezone Gui Qml Quick)
qt5_use_modules(alarm Gui Qml Quick DBus)
qt5_use_modules(clock Gui Qml Quick)
qt5_use_modules(stopwatchlaphistory Qml)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(timezone-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timezone/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timezone
    DEPENDS ${QMLFILES}
)

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
install(TARGETS timezone DESTINATION ${MODULE_PATH}/Timezone/)
install(FILES   modules/Timezone/qmldir DESTINATION ${MODULE_PATH}/Timezone/)

install(TARGETS alarm DESTINATION ${MODULE_PATH}/Alarm/)
install(FILES   modules/Alarm/qmldir DESTINATION ${MODULE_PATH}/Alarm/)

install(TARGETS clock DESTINATION ${MODULE_PATH}/Clock/)
install(FILES   modules/Clock/qmldir DESTINATION ${MODULE_PATH}/Clock/)

install(TARGETS stopwatchlaphistory DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)
install(FILES   modules/Stopwatch/LapHistory/qmldir DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)

