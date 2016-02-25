set(UPSTREAM_COMPONENTS_QML_JS_FILES
    FastScroll.js
    FastScroll.qml
)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_upstream_components_QMlFiles ALL SOURCES ${UPSTREAM_COMPONENTS_QML_JS_FILES})

install(FILES ${UPSTREAM_COMPONENTS_QML_JS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/upstreamcomponents)
