cmake_minimum_required (VERSION 3.0)

project (MulleObjCFoundation)

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration)
message(STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")
if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()


include_directories(
src
src/Base
src/Container
src/Container/NSArray
src/Container/NSDictionary
src/Container/NSSet
src/Data
src/Exception
src/Notification
src/String
src/Value
)


set(HEADERS
src/MulleObjCFoundation.h
src/Base/MulleObjCBaseFunctions.h
src/Base/MulleObjCFoundationBase.h
src/Base/ns_foundationconfiguration.h
src/Base/NSMutableCopying.h
src/Container/MulleObjCFoundationContainer.h
src/Container/NSArray/NSArray+NSString.h
src/Container/NSArray/NSArray.h
src/Container/NSArray/NSEnumerator+NSArray.h
src/Container/NSArray/NSMutableArray.h
src/Container/NSDictionary/ns_map_table.h
src/Container/NSDictionary/NSDictionary+NSArray.h
src/Container/NSDictionary/NSDictionary.h
src/Container/NSDictionary/NSMutableDictionary+NSArray.h
src/Container/NSDictionary/NSMutableDictionary.h
src/Container/NSEnumerator.h
src/Container/NSSet/ns_hash_table.h
src/Container/NSSet/NSSet.h
src/Data/MulleObjCFoundationData.h
src/Data/NSData.h
src/Data/NSMutableData.h
src/Exception/MulleObjCFoundationException.h
src/Exception/NSAssert.h
src/Exception/NSException.h
src/Notification/MulleObjCFoundationNotification.h
src/Notification/NSNotification.h
src/Notification/NSNotificationCenter.h
src/String/mulle_sprintf_object.h
src/String/MulleObjCFoundationString.h
src/String/NSCharacterSet.h
src/String/NSConstantString.h
src/String/NSMutableString.h
src/String/NSString+ClassCluster.h
src/String/NSString+Search.h
src/String/NSString+Sprintf.h
src/String/NSString.h
src/Value/MulleObjCFoundationValue.h
src/Value/NSDate.h
src/Value/NSLock+Date.h
src/Value/NSNull.h
src/Value/NSNumber.h
src/Value/NSValue.h
)


add_library(MulleObjCFoundation STATIC
src/Base/ns_foundationconfiguration.c
src/Container/NSArray/NSArray+NSString.m
src/Container/NSArray/NSArray.m
src/Container/NSArray/NSEnumerator+NSArray.m
src/Container/NSArray/NSMutableArray.m
src/Container/NSArray/_MulleObjCArrayEnumerator.m
src/Container/NSArray/_MulleObjCConcreteArray.m
src/Container/NSArray/_MulleObjCEmptyArray.m
src/Container/NSDictionary/NSDictionary+NSArray.m
src/Container/NSDictionary/NSDictionary.m
src/Container/NSDictionary/NSMutableDictionary+NSArray.m
src/Container/NSDictionary/NSMutableDictionary.m
src/Container/NSDictionary/_MulleObjCConcreteDictionary.m
src/Container/NSDictionary/ns_map_table.c
src/Container/NSEnumerator.m
src/Container/NSSet/NSSet.m
src/Container/NSSet/_MulleObjCConcreteSet.m
src/Container/NSSet/ns_hash_table.c
src/Container/_MulleObjCContainerCallback.m
src/Data/NSData.m
src/Data/NSMutableData.m
src/Data/_MulleObjCConcreteMutableData.m
src/Data/_MulleObjCDataSubclasses.m
src/Exception/NSAssert.m
src/Exception/NSException.m
src/Notification/NSNotification.m
src/Notification/NSNotificationCenter.m
src/String/NSCharacterSet.m
src/String/NSConstantString.m
src/String/NSMutableString.m
src/String/NSString+ClassCluster.m
src/String/NSString+Search.m
src/String/NSString+Sprintf.m
src/String/NSString.m
src/String/_MulleObjCASCIIString.m
src/String/_MulleObjCEmptyString.m
src/String/_MulleObjCUTF16String.m
src/String/_MulleObjCUTF32String.m
src/String/mulle_sprintf_object.m
src/Value/NSDate.m
src/Value/NSLock+Date.m
src/Value/NSNull.m
src/Value/NSNumber.m
src/Value/NSNumber+NSString.m
src/Value/NSValue.m
src/Value/_MulleObjCConcreteNumber.m
src/Value/_MulleObjCConcreteNumber+NSString.m
src/Value/_MulleObjCConcreteValue.m
)



add_library( MulleStandaloneObjCFoundation SHARED
src/MulleStandaloneObjCFoundation.m
src/ns_test_allocation.c
)

add_dependencies( MulleStandaloneObjCFoundation MulleObjCFoundation)

TARGET_LINK_LIBRARIES( MulleStandaloneObjCFoundation
MulleObjCFoundation
MulleObjC
mulle_utf
mulle_sprintf
mulle_objc_runtime
mulle_container
mulle_concurrent
mulle_aba
mulle_allocator
mulle_test_allocator )


INSTALL( TARGETS MulleObjCFoundation MulleStandaloneObjCFoundation DESTINATION "lib")
INSTALL( FILES ${HEADERS} DESTINATION "include/MulleObjCFoundation")
INSTALL( FILES src/MulleStandaloneObjCFoundation.h src/ns_test_allocation.h DESTINATION "include/MulleStandaloneObjCFoundation")

