cmake_minimum_required (VERSION 3.0)

project (MulleObjCFoundation)

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration)
message(STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

set( MULLE_LANGUAGE "ObjC")

if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()


include_directories(
src
src/Archiver
src/Base
src/Container
src/Container/NSArray
src/Container/NSDictionary
src/Container/NSSet
src/Data
src/Exception
src/Locale
src/PropertyList
src/Notification
src/PropertyList
src/PropertyList/Parsing
src/PropertyList/Printing
src/PropertyList/Stream
src/String
src/Value
)

##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT
## MEMO: recreate this with mulle-xcode-to-cmake 0.5.2 or better
##       mulle-xcode-to-cmake -t MulleObjCFoundation \
##                            -t MulleObjCArchiver \
##                            -t MulleObjCCore \
##                            -t MulleObjCLocale \
##                            -t MulleObjCNotification \
##                            -t MulleObjCPropertyList \
##                            sexport  \
##                            MulleObjCFoundation.xcodeproj > CMakeSourcesAndHeaders.txt
##### CMakeSourcesAndHeaders.txt GENERATED FROM XCODE PROJECT

include( CMakeSourcesAndHeaders.txt)



set( HEADERS
${MULLE_OBJC_FOUNDATION_PUBLIC_HEADERS}
${MULLE_OBJC_ARCHIVER_PUBLIC_HEADERS}
${MULLE_OBJC_CORE_PUBLIC_HEADERS}
${MULLE_OBJC_LOCALE_PUBLIC_HEADERS}
${MULLE_OBJC_NOTIFICATION_PUBLIC_HEADERS}
${MULLE_OBJC_PROPERTY_LIST_PUBLIC_HEADERS}
)

set( PRIVATE_HEADERS
${MULLE_OBJC_FOUNDATION_PRIVATE_HEADERS}
${MULLE_OBJC_ARCHIVER_PRIVATE_HEADERS}
${MULLE_OBJC_CORE_PRIVATE_HEADERS}
${MULLE_OBJC_LOCALE_PRIVATE_HEADERS}
${MULLE_OBJC_NOTIFICATION_PRIVATE_HEADERS}
${MULLE_OBJC_PROPERTY_LIST_PRIVATE_HEADERS}
)

set( SOURCES
${MULLE_OBJC_FOUNDATION_SOURCES}
${MULLE_OBJC_ARCHIVER_SOURCES}
${MULLE_OBJC_CORE_SOURCES}
${MULLE_OBJC_LOCALE_SOURCES}
${MULLE_OBJC_NOTIFICATION_SOURCES}
${MULLE_OBJC_PROPERTY_LIST_SOURCES}
)


add_library( MulleObjCFoundation STATIC
${SOURCES}
# for IDEs
${HEADERS}
${PRIVATE_HEADERS}
)

add_library( MulleObjCFoundationStandalone SHARED
src/MulleObjCFoundationStandalone.m
)

add_dependencies( MulleObjCFoundationStandalone MulleObjCFoundation)

find_library( MULLE_ABA_LIBRARY            NAMES mulle_aba)
find_library( MULLE_ALLOCATOR_LIBRARY      NAMES mulle_allocator)
find_library( MULLE_BUFFER_LIBRARY         NAMES mulle_buffer)
find_library( MULLE_CONCURRENT_LIBRARY     NAMES mulle_concurrent)
find_library( MULLE_CONTAINER_LIBRARY      NAMES mulle_container)
find_library( MULLE_OBJC_RUNTIME_LIBRARY   NAMES mulle_objc)
find_library( MULLE_OBJC_LIBRARY           NAMES MulleObjC)
find_library( MULLE_SPRINTF_LIBRARY        NAMES mulle_sprintf)
find_library( MULLE_TEST_ALLOCATOR_LIBRARY NAMES mulle_test_allocator)
find_library( MULLE_THREAD_LIBRARY         NAMES mulle_thread)
find_library( MULLE_UTF_LIBRARY            NAMES mulle_utf)

message(STATUS "MULLE_ABA_LIBRARY is ${MULLE_ABA_LIBRARY}")
message(STATUS "MULLE_ALLOCATOR_LIBRARY is ${MULLE_ALLOCATOR_LIBRARY}")
message(STATUS "MULLE_BUFFER_LIBRARY is ${MULLE_BUFFER_LIBRARY}")
message(STATUS "MULLE_CONCURRENT_LIBRARY is ${MULLE_CONCURRENT_LIBRARY}")
message(STATUS "MULLE_CONTAINER_LIBRARY is ${MULLE_CONTAINER_LIBRARY}")
message(STATUS "MULLE_OBJC_RUNTIME_LIBRARY is ${MULLE_OBJC_RUNTIME_LIBRARY}")
message(STATUS "MULLE_SPRINTF_LIBRARY is ${MULLE_SPRINTF_LIBRARY}")
message(STATUS "MULLE_TEST_ALLOCATOR_LIBRARY is ${MULLE_TEST_ALLOCATOR_LIBRARY}")
message(STATUS "MULLE_THREAD_LIBRARY is ${MULLE_THREAD_LIBRARY}")
message(STATUS "MULLE_UTF_LIBRARY is ${MULLE_UTF_LIBRARY}")


set( DEPENDENCY_LIBRARIES
${MULLE_ABA_LIBRARY}
${MULLE_ALLOCATOR_LIBRARY}
${MULLE_BUFFER_LIBRARY}
${MULLE_CONCURRENT_LIBRARY}
${MULLE_CONTAINER_LIBRARY}
${MULLE_OBJC_RUNTIME_LIBRARY}
${MULLE_OBJC_LIBRARY}
${MULLE_SPRINTF_LIBRARY}
${MULLE_TEST_ALLOCATOR_LIBRARY}
${MULLE_THREAD_LIBRARY}
${MULLE_UTF_LIBRARY}
)

TARGET_LINK_LIBRARIES( MulleObjCFoundationStandalone
${BEGIN_ALL_LOAD}
MulleObjCFoundation
${DEPENDENCY_LIBRARIES}
${END_ALL_LOAD}
)

INSTALL( TARGETS MulleObjCFoundation MulleObjCFoundationStandalone DESTINATION "lib")
INSTALL( FILES ${HEADERS} DESTINATION "include/MulleObjCFoundation")
INSTALL( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjCFoundation/Private")

