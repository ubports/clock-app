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
    datetime_SRCS
    modules/DateTime/backend.cpp
    modules/DateTime/datetime.cpp
)

set(
    alarm_SRCS
    modules/Alarm/backend.cpp
    modules/Alarm/settings.cpp
)

set(
    geolocation_SRCS
    modules/GeoLocation/backend.cpp
    modules/GeoLocation/geolocation.cpp
)

set(
    clockutility_SRCS
    modules/Clock/Utility/backend.cpp
    modules/Clock/Utility/alarmsound.cpp
)

set(
    stopwatchlaphistory_SRCS
    modules/Stopwatch/LapHistory/backend.cpp
    modules/Stopwatch/LapHistory/history.cpp
)

add_library(timezone MODULE
    ${timezone_SRCS}
)

add_library(datetime MODULE
    ${datetime_SRCS}
)

add_library(alarm MODULE
    ${alarm_SRCS}
)

add_library(geolocation MODULE
    ${geolocation_SRCS}
)

add_library(clockutility MODULE
    ${clockutility_SRCS}
)

add_library(stopwatchlaphistory MODULE
    ${stopwatchlaphistory_SRCS}
)

set_target_properties(timezone PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timezone
)

set_target_properties(datetime PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY DateTime
)

set_target_properties(alarm PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Alarm
)

set_target_properties(geolocation PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY GeoLocation
)

set_target_properties(clockutility PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Clock/Utility
)

set_target_properties(stopwatchlaphistory PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Stopwatch/LapHistory
)

qt5_use_modules(datetime Gui Qml Quick)
qt5_use_modules(timezone Gui Qml Quick)
qt5_use_modules(alarm Gui Qml Quick DBus)
qt5_use_modules(geolocation Gui Qml Quick)
qt5_use_modules(clockutility Qml)
qt5_use_modules(stopwatchlaphistory Qml)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(timezone-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timezone/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timezone
    DEPENDS ${QMLFILES}
)

add_custom_target(datetime-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/DateTime/qmldir ${CMAKE_CURRENT_BINARY_DIR}/DateTime
    DEPENDS ${QMLFILES}
)

add_custom_target(alarm-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Alarm/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Alarm
    DEPENDS ${QMLFILES}
)

add_custom_target(geolocation-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/GeoLocation/qmldir ${CMAKE_CURRENT_BINARY_DIR}/GeoLocation
    DEPENDS ${QMLFILES}
)

add_custom_target(clockutility-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Clock/Utility/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Clock/Utility
    DEPENDS ${QMLFILES}
)

add_custom_target(stopwatchlaphistory-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Stopwatch/LapHistory/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Stopwatch/LapHistory
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS timezone DESTINATION ${MODULE_PATH}/Timezone/)
install(FILES   modules/Timezone/qmldir DESTINATION ${MODULE_PATH}/Timezone/)

install(TARGETS datetime DESTINATION ${MODULE_PATH}/DateTime/)
install(FILES   modules/DateTime/qmldir DESTINATION ${MODULE_PATH}/DateTime/)

install(TARGETS alarm DESTINATION ${MODULE_PATH}/Alarm/)
install(FILES   modules/Alarm/qmldir DESTINATION ${MODULE_PATH}/Alarm/)

install(TARGETS geolocation DESTINATION ${MODULE_PATH}/GeoLocation/)
install(FILES   modules/GeoLocation/qmldir DESTINATION ${MODULE_PATH}/GeoLocation/)

install(TARGETS clockutility DESTINATION ${MODULE_PATH}/Clock/Utility/)
install(FILES   modules/Clock/Utility/qmldir DESTINATION ${MODULE_PATH}/Clock/Utility/)

install(TARGETS stopwatchlaphistory DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)
install(FILES   modules/Stopwatch/LapHistory/qmldir DESTINATION ${MODULE_PATH}/Stopwatch/LapHistory/)

