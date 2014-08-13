project(com.ubuntu.clock.devel C CXX)
cmake_minimum_required(VERSION 2.8.9)

set (UBUNTU_PROJECT_TYPE "ClickApp" CACHE INTERNAL "Tells QtCreator this is a Click application project")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fno-permissive -pedantic -Wall -Wextra")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
find_package(Qt5DBus)
#find_package(ubuntu-sdk-libs)

#automatically create moc files
set(CMAKE_AUTOMOC ON)

option(INSTALL_TESTS "Install the tests on make install" on)
option(CLICK_MODE "Build as a click package" on)

set(APP_NAME                clock)
set(APP_HARDCODE            ubuntu-clock-app)
set(MAIN_QML                ${APP_HARDCODE}.qml)
set(ICON                    clock-app)
SET(AUTOPILOT_DIR           ubuntu_clock_app)

# Standard install paths 
include(GNUInstallDirs) 

#set install paths
if(CLICK_MODE)
  set(CMAKE_INSTALL_PREFIX "/")
  set(UBUNTU-CLOCK_APP_DIR    "${CMAKE_INSTALL_DATADIR}/qml")

  set(QT_IMPORTS_DIR "${CMAKE_INSTALL_LIBDIR}")
  set(EXEC "qmlscene $@ ${UBUNTU-CLOCK_APP_DIR}/${MAIN_QML}")
  set(MODULE_PATH ${QT_IMPORTS_DIR})
  if(NOT BZR_REVNO)
    execute_process( 
      COMMAND bzr revno
              OUTPUT_VARIABLE BZR_REVNO 
              WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
              OUTPUT_STRIP_TRAILING_WHITESPACE 
      )
  endif(NOT BZR_REVNO)
  if(NOT BZR_SOURCE)
    set(BZR_SOURCE lp:${APP_HARDCODE})
    message("-- Setting BZR_SOURCE to ${BZR_SOURCE}")
  endif(NOT BZR_SOURCE)
else(CLICK_MODE)
  set(UBUNTU-CLOCK_APP_DIR "${CMAKE_INSTALL_DATADIR}/ubuntu-clock-app")
  execute_process( 
    COMMAND qmake -query QT_INSTALL_QML 
            OUTPUT_VARIABLE QT_IMPORTS_DIR 
            OUTPUT_STRIP_TRAILING_WHITESPACE 
    )
set(MODULE_PATH ${QT_IMPORTS_DIR}/ClockApp)
endif(CLICK_MODE)

if(${CLICK_MODE})
  message("-- Configuring manifest.json")
  configure_file(manifest.json manifest.json)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
  install(FILES "${APP_HARDCODE}.json" DESTINATION ${CMAKE_INSTALL_PREFIX})
else(CLICK_MODE)
  set(EXEC "qmlscene $@ -I ${MODULE_PATH}  ${CMAKE_INSTALL_PREFIX}/${UBUNTU-CLOCK_APP_DIR}/${MAIN_QML}")
endif()

add_subdirectory(app)
add_subdirectory(backend)
if(NOT CLICK_MODE)
  add_subdirectory(tests)
endif(NOT CLICK_MODE)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/tests/autopilot/run
                    COMMAND ${CMAKE_SOURCE_DIR}/tests/autopilot/run
                    DEPENDS timezone timezone-qmldir alarmsettings alarmsettings-qmldir datetime datetime-qmldir
                    WORKING_DIRECTORY ./app)

enable_testing()
add_test(NAME basic
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/app
  COMMAND /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/tests/unit -import ${CMAKE_BINARY_DIR}/backend
)

add_custom_target("run" /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/backend  ${CMAKE_SOURCE_DIR}/app/ubuntu-clock-app.qml
                    DEPENDS timezone timezone-qmldir alarmsettings alarmsettings-qmldir datetime datetime-qmldir
                    WORKING_DIRECTORY ./app)
