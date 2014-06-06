file(GLOB IMAGES_PNG_FILES *.png *.jpg)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-clock-app_graphics_PNGFiles ALL SOURCES ${IMAGES_PNG_FILES})

install(FILES ${IMAGES_PNG_FILES} DESTINATION ${UBUNTU-CLOCK-APP_DIR}/graphics)
