include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    ubuntu-clock-appbackend_SRCS
    modules/Timezone/backend.cpp
    modules/Timezone/timezonemodel.cpp
    modules/Timezone/xmltimezonemodel.cpp
)

set(
    alarm-settingsbackend_SRCS
    modules/Clock/Alarm/Settings/backend.cpp
    modules/Clock/Alarm/Settings/alarmsettings.cpp
)

add_library(ubuntu-clock-appbackend MODULE
    ${ubuntu-clock-appbackend_SRCS}
)

add_library(alarm-settingsbackend MODULE
    ${alarm-settingsbackend_SRCS}
)

set_target_properties(ubuntu-clock-appbackend PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timezone
)

set_target_properties(alarm-settingsbackend PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Clock/Alarm/Settings
)

qt5_use_modules(ubuntu-clock-appbackend Gui Qml Quick)
qt5_use_modules(alarm-settingsbackend Gui Qml Quick DBus)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(ubuntu-clock-appbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timezone/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timezone
    DEPENDS ${QMLFILES}
)

add_custom_target(alarm-settingsbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Clock/Alarm/Settings/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Clock/Alarm/Settings
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS ubuntu-clock-appbackend DESTINATION ${QT_IMPORTS_DIR}/Timezone/)
install(FILES   modules/Timezone/qmldir DESTINATION ${QT_IMPORTS_DIR}/Timezone/)

install(TARGETS alarm-settingsbackend DESTINATION ${QT_IMPORTS_DIR}/Clock/Alarm/Settings/)
install(FILES   modules/Alarm/Settings/qmldir DESTINATION ${QT_IMPORTS_DIR}/Clock/Alarm/Settings/)
