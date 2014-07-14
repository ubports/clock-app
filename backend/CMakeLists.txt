include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    ubuntu-clock-appbackend_SRCS
    modules/Timezone/backend.cpp
    modules/Timezone/zone.cpp
    modules/Timezone/timezonemodel.cpp
)

add_library(ubuntu-clock-appbackend MODULE
    ${ubuntu-clock-appbackend_SRCS}
)

set_target_properties(ubuntu-clock-appbackend PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY Timezone
)

qt5_use_modules(ubuntu-clock-appbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(ubuntu-clock-appbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Timezone/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Timezone
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS ubuntu-clock-appbackend DESTINATION ${QT_IMPORTS_DIR}/Timezone/)
install(FILES   modules/Timezone/qmldir DESTINATION ${QT_IMPORTS_DIR}/Timezone/)
