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
    stopwatch_SRCS
    modules/Stopwatch/backend.cpp
    modules/Stopwatch/engine.cpp
    modules/Stopwatch/formattime.cpp
)

set(
    timer_SRCS
    modules/Timer/backend.cpp
    modules/Timer/timerengine.cpp
)

add_library(alarm MODULE
    ${alarm_SRCS}
)

add_library(worldclock MODULE
    ${worldclock_SRCS}
)

add_library(stopwatch MODULE
    ${stopwatch_SRCS}
)

add_library(timer MODULE
    ${timer_SRCS}
)

set_target_properties(alarm PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Alarm
)

set_target_properties(worldclock PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY WorldClock
)

set_target_properties(stopwatch PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Stopwatch/
)


set_target_properties(timer PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timer/
)

qt5_use_modules(alarm Gui Qml Quick DBus)
qt5_use_modules(worldclock Gui Qml Quick)
qt5_use_modules(stopwatch Qml)
qt5_use_modules(timer Qml)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(alarm-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Alarm/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Alarm
    DEPENDS ${QMLFILES}
)

add_custom_target(worldclock-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/WorldClock/qmldir ${CMAKE_CURRENT_BINARY_DIR}/WorldClock
    DEPENDS ${QMLFILES}
)

add_custom_target(stopwatch-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Stopwatch/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Stopwatch
    DEPENDS ${QMLFILES}
)

add_custom_target(timer-qmldir ALL
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timer/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timer
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS alarm DESTINATION ${MODULE_PATH}/Alarm/)
install(FILES   modules/Alarm/qmldir DESTINATION ${MODULE_PATH}/Alarm/)

install(TARGETS worldclock DESTINATION ${MODULE_PATH}/WorldClock/)
install(FILES   modules/WorldClock/qmldir DESTINATION ${MODULE_PATH}/WorldClock/)

install(TARGETS stopwatch DESTINATION ${MODULE_PATH}/Stopwatch/)
install(FILES   modules/Stopwatch/qmldir DESTINATION ${MODULE_PATH}/Stopwatch/)

install(TARGETS timer DESTINATION ${MODULE_PATH}/Timer/)
install(FILES   modules/Timer/qmldir DESTINATION ${MODULE_PATH}/Timer/)
