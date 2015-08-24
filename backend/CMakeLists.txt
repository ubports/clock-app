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
    alarmsettings_SRCS
    modules/Alarm/Settings/backend.cpp
    modules/Alarm/Settings/alarmsettings.cpp
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
    stopwatch_SRCS
    modules/Stopwatch/backend.cpp
    modules/Stopwatch/history.cpp
)

add_library(timezone MODULE
    ${timezone_SRCS}
)

add_library(datetime MODULE
    ${datetime_SRCS}
)

add_library(alarmsettings MODULE
    ${alarmsettings_SRCS}
)

add_library(geolocation MODULE
    ${geolocation_SRCS}
)

add_library(clockutility MODULE
    ${clockutility_SRCS}
)

add_library(stopwatch MODULE
    ${stopwatch_SRCS}
)

set_target_properties(timezone PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timezone
)

set_target_properties(datetime PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY DateTime
)

set_target_properties(alarmsettings PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Alarm/Settings
)

set_target_properties(geolocation PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY GeoLocation
)

set_target_properties(clockutility PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Clock/Utility
)

set_target_properties(stopwatch PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Stopwatch/
)

qt5_use_modules(datetime Gui Qml Quick)
qt5_use_modules(timezone Gui Qml Quick)
qt5_use_modules(alarmsettings Gui Qml Quick DBus)
qt5_use_modules(geolocation Gui Qml Quick)
qt5_use_modules(clockutility Qml)
qt5_use_modules(stopwatch Qml)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(timezone-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timezone/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timezone
    DEPENDS ${QMLFILES}
)

add_custom_target(datetime-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/DateTime/qmldir ${CMAKE_CURRENT_BINARY_DIR}/DateTime
    DEPENDS ${QMLFILES}
)

add_custom_target(alarmsettings-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Alarm/Settings/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Alarm/Settings
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

add_custom_target(stopwatch-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Stopwatch/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Stopwatch
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS timezone DESTINATION ${MODULE_PATH}/Timezone/)
install(FILES   modules/Timezone/qmldir DESTINATION ${MODULE_PATH}/Timezone/)

install(TARGETS datetime DESTINATION ${MODULE_PATH}/DateTime/)
install(FILES   modules/DateTime/qmldir DESTINATION ${MODULE_PATH}/DateTime/)

install(TARGETS alarmsettings DESTINATION ${MODULE_PATH}/Alarm/Settings/)
install(FILES   modules/Alarm/Settings/qmldir DESTINATION ${MODULE_PATH}/Alarm/Settings/)

install(TARGETS geolocation DESTINATION ${MODULE_PATH}/GeoLocation/)
install(FILES   modules/GeoLocation/qmldir DESTINATION ${MODULE_PATH}/GeoLocation/)

install(TARGETS clockutility DESTINATION ${MODULE_PATH}/Clock/Utility/)
install(FILES   modules/Clock/Utility/qmldir DESTINATION ${MODULE_PATH}/Clock/Utility/)

install(TARGETS stopwatch DESTINATION ${MODULE_PATH}/Stopwatch/)
install(FILES   modules/Stopwatch/qmldir DESTINATION ${MODULE_PATH}/Stopwatch/)

