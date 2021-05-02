cmake_minimum_required(VERSION 3.15)
project(project VERSION 1.0.0 LANGUAGES CXX)

include(GNUInstallDirs)

configure_file(cmake/config.h.in include/config.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include)

find_package(fmt REQUIRED)

################################################################################
# lib targets section

set(COMPONENT lib)
set(TARGET lib)

add_library(${TARGET})
target_sources(${TARGET}
PRIVATE
    lib/lib.cpp
    lib/include/lib.hpp
    ${CMAKE_CURRENT_BINARY_DIR}/include/config.h
)

target_include_directories(${TARGET}
PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${TARGET}/include/>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
target_compile_features(${TARGET} PRIVATE cxx_std_17)
target_link_libraries(${TARGET} PUBLIC fmt::fmt)

install(TARGETS ${TARGET}
        EXPORT ${COMPONENT}-config
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/${TARGET}/include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/${COMPONENT}/${TARGET})

################################################################################
# lib component section

install(EXPORT ${COMPONENT}-config
        NAMESPACE ${PROJECT_NAME}::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

################################################################################
# project section

configure_file(cmake/${PROJECT_NAME}-config.cmake.in ${PROJECT_NAME}-config.cmake @ONLY)

install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

################################################################################
# packaging support

set(CPACK_PACKAGE_VENDOR "Thomas Harrison")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "An awesome library")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
# set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENCE")
# set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_SOURCE_IGNORE_FILES
    /.git
    /.vscode
    /.*build.*
)

include(CPack)
