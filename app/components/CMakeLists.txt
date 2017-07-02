set(COMPONENTS_QML_JS_FILES
    AlarmBottomEdge.qml
    ActionIcon.qml
    AnalogMode.qml
    AnalogShadow.qml
    Circle.qml
    Clock.qml
    ClockCircle.qml
    DigitalMode.qml
    DigitalShadow.qml
    EmptyState.qml
    ExpandableListItem.qml
    NavigationRow.qml
    Information.qml
    Shadow.qml
)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_components_QMlFiles ALL SOURCES ${COMPONENTS_QML_JS_FILES})

install(FILES ${COMPONENTS_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/components)
