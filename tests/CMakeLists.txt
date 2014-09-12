add_subdirectory(unit)

if(NOT CLICK_MODE)
  add_subdirectory(autopilot)
endif(NOT CLICK_MODE)

