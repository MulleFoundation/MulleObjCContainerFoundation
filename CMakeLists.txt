cmake_minimum_required (VERSION 3.0)

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


add_library( MulleObjCStandardFoundation STATIC
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
CMakeDependencies.txt
CMakeSourcesAndHeaders.txt
)


target_link_libraries( MulleObjCStandardFoundation
)


add_library( MulleObjCStandardFoundationStandalone SHARED
${MULLE_OBJC_STANDARD_FOUNDATION_STANDALONE_SOURCES}
)

add_dependencies( MulleObjCStandardFoundationStandalone MulleObjCStandardFoundation)


set( TARGET_ALL_LOAD_LIBRARIES
$<TARGET_FILE:MulleObjCStandardFoundation>
${OBJC_DEPENDENCY_LIBRARIES}
${C_DEPENDENCY_LIBRARIES}
)

if( FORCE_LOAD)
   set( TMP)
   foreach( library ${TARGET_ALL_LOAD_LIBRARIES})
      list( APPEND TMP "${FORCE_LOAD} ${library}")
   endforeach( library)
   set( TARGET_ALL_LOAD_LIBRARIES ${TMP})
endif()


#
# If you add DEPENDENCY_LIBRARIES to the static, adding them again to
# MulleObjCStandardFoundationStandalone confuses cmake it seems. But they are
# implicitly added.
#
target_link_libraries( MulleObjCStandardFoundationStandalone
${BEGIN_ALL_LOAD}
${TARGET_ALL_LOAD_LIBRARIES}
${END_ALL_LOAD}
${OS_SPECIFIC_LIBRARIES}
)

message( STATUS "OBJC_DEPENDENCY_NAMES is ${OBJC_DEPENDENCY_NAMES}")

# runs in build dir
add_custom_command( TARGET MulleObjCStandardFoundationStandalone
   POST_BUILD
   COMMAND ${DEPENDENCIES_DIR}/bin/mulle-objc-create-dependencies-inc -v -o ${CMAKE_SOURCE_DIR}/src/dependencies.inc MulleObjCStandardFoundation ${OBJC_DEPENDENCY_NAMES}
)

set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)


install( TARGETS MulleObjCStandardFoundation MulleObjCStandardFoundationStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjCStandardFoundation")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjCStandardFoundation/private")
