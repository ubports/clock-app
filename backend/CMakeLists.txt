include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    timezone_SRCS
    modules/Timezone/backend.cpp
    modules/Timezone/timezonemodel.cpp
    modules/Timezone/xmltimezonemodel.cpp
    modules/Timezone/u1dbtimezonemodel.cpp
)

set(
    alarmsettings_SRCS
    modules/Alarm/Settings/backend.cpp
    modules/Alarm/Settings/alarmsettings.cpp
)

add_library(timezone MODULE
    ${timezone_SRCS}
)

add_library(alarmsettings MODULE
    ${alarmsettings_SRCS}
)

set_target_properties(timezone PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timezone
)

set_target_properties(alarmsettings PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Alarm/Settings
)

qt5_use_modules(timezone Gui Qml Quick)
qt5_use_modules(alarmsettings Gui Qml Quick DBus)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(timezone-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timezone/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timezone
    DEPENDS ${QMLFILES}
)

add_custom_target(alarmsettings-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Alarm/Settings/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Alarm/Settings
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS timezone DESTINATION ${QT_IMPORTS_DIR}/Timezone/)
install(FILES   modules/Timezone/qmldir DESTINATION ${QT_IMPORTS_DIR}/Timezone/)

install(TARGETS alarmsettings DESTINATION ${QT_IMPORTS_DIR}/Alarm/Settings/)
install(FILES   modules/Alarm/Settings/qmldir DESTINATION ${QT_IMPORTS_DIR}/Alarm/Settings/)
