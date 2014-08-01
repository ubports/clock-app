project(com.ubuntu.clock C CXX)
cmake_minimum_required(VERSION 2.8.9)

set (UBUNTU_PROJECT_TYPE "ClickApp" CACHE INTERNAL "Tells QtCreator this is a Click application project")
set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
#find_package(ubuntu-sdk-libs)

#automatically create moc files
set(CMAKE_AUTOMOC ON)

option(INSTALL_TESTS "Install the tests on make install" on)
option(CLICK_MODE "Build as a click package" on)

set(APP_NAME                clock)
set(APP_HARDCODE            ubuntu-clock-app)
set(MAIN_QML                ${APP_HARDCODE}.qml)
set(ICON                    "share/app/clock_app@30.png")

#set install paths
if(${CLICK_MODE})
  set(CMAKE_INSTALL_PREFIX /)
  set(DATA_DIR /)
  set(DESKTOP_DIR ${DATA_DIR})
  set(ICON ".${DATA_DIR}/${ICON}")
  set(UBUNTU-CLOCK-APP_DIR    "share/qml/ubuntu-clock-app")

  execute_process(
      COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
      OUTPUT_VARIABLE ARCH_TRIPLET
      OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  set(QT_IMPORTS_DIR "lib/${ARCH_TRIPLET}")
else()
  set(DATA_DIR "share/clockapp")
  set(DESKTOP_DIR ${DATA_DIR})
  set(ICON ".${DATA_DIR}/${ICON}")
  set(UBUNTU-CLOCK-APP_DIR    "share/ubuntu-clock-app/qml")
  include(GNUInstallDirs)
  set(QT_IMPORTS_DIR "${CMAKE_INSTALL_LIBDIR}")
endif()

set(EXEC "qmlscene $@ ${UBUNTU-CLOCK-APP_DIR}/${MAIN_QML}")

if(${CLICK_MODE})
  install(FILES manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
endif()
install(DIRECTORY "app/graphics" DESTINATION ${DATA_DIR})
install(FILES "${APP_HARDCODE}.json" DESTINATION ${DATA_DIR})

add_subdirectory(app)
add_subdirectory(backend)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    COMMAND ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    DEPENDS ubuntu-clock-appbackend ubuntu-clock-appbackend-qmldir
                    WORKING_DIRECTORY ./app)

enable_testing()
add_test(NAME basic
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/app
  COMMAND /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/app/tests/unit -import ${CMAKE_BINARY_DIR}/backend
)

add_custom_target("run" /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/backend  ${CMAKE_SOURCE_DIR}/app/ubuntu-clock-app.qml
                    DEPENDS ubuntu-clock-appbackend ubuntu-clock-appbackend-qmldir
                    WORKING_DIRECTORY ./app)
