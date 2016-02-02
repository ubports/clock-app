set(GRAPHICS_FILES
    Background_Texture.jpg
    Hour_Hand@27.png
    Inner_Clock_Texture@27.png
    Knob@27.png
    Minute_Hand@27.png
    Second_Hand@27.png
    select-none.svg
    select.svg
    Stopwatch_Placeholder.svg
    WorldClock_Placeholder.svg
)

# make the files visible in the qtcreator tree
if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
  add_custom_target(ubuntu-clock-app_graphics_PNGFiles ALL SOURCES ${GRAPHICS_FILES})
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

install(FILES ${GRAPHICS_FILES} DESTINATION ${UBUNTU-CLOCK_APP_DIR}/graphics)
