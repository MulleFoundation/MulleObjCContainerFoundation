cmake_minimum_required( VERSION 3.0)

project( MulleObjCStandardFoundation C)


set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration/cmake)
message(STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

set( MULLE_LANGUAGE "ObjC")

if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()


##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT
## MEMO: recreate this with mulle-xcode-to-cmake 0.5.2 or better
##       mulle-xcode-to-cmake -t MulleObjCStandardFoundation \
##                            -t MulleObjCStandardFoundatioStandalone \
##                            -t MulleObjCArchiver \
##                            -t MulleObjCCore \
##                            -t MulleObjCLocale \
##                            -t MulleObjCNotification \
##                            -t MulleObjCPropertyList \
##                            sexport  \
##                            MulleObjCStandardFoundation.xcodeproj > CMakeSourcesAndHeaders.txt
##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT

set( MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY ON)

include( CMakeDependencies.txt)
include( CMakeSourcesAndHeaders.txt)

include_directories( ${INCLUDE_DIRS})

set( PUBLIC_HEADERS
${MULLE_OBJC_STANDARD_FOUNDATION_PUBLIC_HEADERS}
${MULLE_OBJC_ARCHIVER_PUBLIC_HEADERS}
${MULLE_OBJC_CORE_PUBLIC_HEADERS}
${MULLE_OBJC_LOCALE_PUBLIC_HEADERS}
${MULLE_OBJC_NOTIFICATION_PUBLIC_HEADERS}
${MULLE_OBJC_PROPERTY_LIST_PUBLIC_HEADERS}
)

set( PRIVATE_HEADERS
${MULLE_OBJC_STANDARD_FOUNDATION_PRIVATE_HEADERS}
${MULLE_OBJC_ARCHIVER_PRIVATE_HEADERS}
${MULLE_OBJC_CORE_PRIVATE_HEADERS}
${MULLE_OBJC_LOCALE_PRIVATE_HEADERS}
${MULLE_OBJC_NOTIFICATION_PRIVATE_HEADERS}
${MULLE_OBJC_PROPERTY_LIST_PRIVATE_HEADERS}
)

set( SOURCES
${MULLE_OBJC_STANDARD_FOUNDATION_SOURCES}
${MULLE_OBJC_ARCHIVER_SOURCES}
${MULLE_OBJC_CORE_SOURCES}
${MULLE_OBJC_LOCALE_SOURCES}
${MULLE_OBJC_NOTIFICATION_SOURCES}
${MULLE_OBJC_PROPERTY_LIST_SOURCES}
)


set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)

add_library( MulleObjCStandardFoundation STATIC
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
CMakeSourcesAndHeaders.txt
)

set( OBJC_LIBRARY_NAME "MulleObjCStandardFoundation")

include( DependenciesIncObjC)

#
# produce a standalone dll/dylib/so for testing mainly
# though testing could go static at some point in time
# (shared is more frugal though)
#
set( STANDALONE_SOURCES ${MULLE_OBJC_STANDARD_FOUNDATION_STANDALONE_SOURCES})
set( STANDALONE_BASE_NAME "MulleObjCStandardFoundation")
set( STANDALONE_NAME "MulleObjCStandardFoundationStandalone")
set( STANDALONE_DEFINITIONS ${MULLE_OBJC_STANDARD_FOUNDATION_DEFINITIONS})
set( STANDALONE_ALL_LOAD_LIBRARIES
    $<TARGET_FILE:${STANDALONE_BASE_NAME}>
    ${OBJC_DEPENDENCY_LIBRARIES}
    ${OBJC_STARTUP_LIBRARY}
    ${C_DEPENDENCY_LIBRARIES}
)

include( Standalone)

install( TARGETS MulleObjCStandardFoundation MulleObjCStandardFoundationStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjCStandardFoundation")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjCStandardFoundation/private")

include( MulleTest)
