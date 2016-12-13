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
src/KVC
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


set(HEADERS
src/Archiver/MulleObjCArchiver.h
src/Archiver/MulleObjCFoundationArchiver.h
src/Archiver/MulleObjCUnarchiver.h
src/Archiver/NSArchiver.h
src/Archiver/NSKeyedArchiver.h
src/Archiver/NSKeyedUnarchiver.h
src/Archiver/NSUnarchiver.h
src/Archiver/mulle_buffer_archiver.h
src/Base/MulleObjCBaseFunctions.h
src/Base/MulleObjCFoundationBase.h
src/Base/NSMutableCopying.h
src/Base/ns_byteorder.h
src/Base/ns_foundationconfiguration.h
src/Container/MulleObjCContainerCallback.h
src/Container/MulleObjCFoundationContainer.h
src/Container/NSArray/NSArray+NSString.h
src/Container/NSArray/NSArray.h
src/Container/NSArray/NSEnumerator+NSArray.h
src/Container/NSArray/NSMutableArray.h
src/Container/NSArray/mulle_qsort_pointers.h
src/Container/NSDictionary/NSDictionary+NSArray.h
src/Container/NSDictionary/NSDictionary.h
src/Container/NSDictionary/NSMapTable+NSArray+NSString.h
src/Container/NSDictionary/NSMutableDictionary+NSArray.h
src/Container/NSDictionary/NSMutableDictionary.h
src/Container/NSDictionary/NSThread+NSMutableDictionary.h
src/Container/NSDictionary/ns_map_table.h
src/Container/NSEnumerator.h
src/Container/NSSet/NSHashTable+NSArray+NSString.h
src/Container/NSSet/NSMutableSet+NSArray.h
src/Container/NSSet/NSMutableSet.h
src/Container/NSSet/NSSet+NSArray.h
src/Container/NSSet/NSSet.h
src/Container/NSSet/ns_hash_table.h
src/Data/MulleObjCFoundationData.h
src/Data/NSData.h
src/Data/NSMutableData.h
src/Exception/MulleObjCFoundationException.h
src/Exception/NSAssertionHandler.h
src/Exception/NSError.h
src/Exception/NSException.h
src/KVC/MulleObjCFoundationKVC.h
src/KVC/NSObject+KeyValueCoding.h
src/KVC/NSSortDescriptor.h
src/KVC/NSArray+NSSortDescriptor.h
src/Locale/MulleObjCFoundationLocale.h
src/Locale/NSArray+NSLocale.h
src/Locale/NSDate+NSLocale.h
src/Locale/NSDateFormatter+NSTimeZone.h
src/Locale/NSDictionary+NSLocale.h
src/Locale/NSFormatter+NSLocale.h
src/Locale/NSLocale.h
src/Locale/NSNumber+NSLocale.h
src/Locale/NSString+Localization.h
src/Locale/NSTimeZone+NSDate.h
src/Locale/NSTimeZone.h
src/MulleObjCFoundation.h
src/MulleObjCFoundationCore.h
src/MulleObjCFoundationSetup.h
src/Notification/MulleObjCFoundationNotification.h
src/Notification/NSNotification.h
src/Notification/NSNotificationCenter.h
src/PropertyList/MulleObjCFoundationPropertyList.h
src/PropertyList/NSPropertyListSerialization.h
src/PropertyList/Parsing/NSObject+PropertyListParsing.h
src/PropertyList/Printing/NSArray+PropertyListPrinting.h
src/String/MulleObjCFoundationString.h
src/String/NSCharacterSet.h
src/String/NSConstantString.h
src/String/NSMutableString.h
src/String/NSScanner.h
src/String/NSString+ClassCluster.h
src/String/NSString+Components.h
src/String/NSString+Escaping.h
src/String/NSString+NSCharacterSet.h
src/String/NSString+NSData.h
src/String/NSString+Search.h
src/String/NSString+Sprintf.h
src/String/NSString.h
src/String/NSURL.h
src/String/mulle_sprintf_object.h
src/Value/MulleObjCFoundationValue.h
src/Value/NSDate.h
src/Value/NSDateFormatter.h
src/Value/NSFormatter.h
src/Value/NSLock+NSDate.h
src/Value/NSNull.h
src/Value/NSNumber.h
src/Value/NSNumberFormatter.h
src/Value/NSThread+NSDate.h
src/Value/NSValue.h
)


add_library(MulleObjCFoundation STATIC
src/Archiver/MulleObjCArchiver.m
src/Archiver/MulleObjCUnarchiver.m
src/Archiver/NSArchiver.m
src/Archiver/NSKeyedArchiver.m
src/Archiver/NSKeyedUnarchiver.m
src/Archiver/NSUnarchiver.m
src/Base/MulleObjCBaseFunctions.m
src/Base/ns_foundationconfiguration.c
src/Container/MulleObjCContainerCallback.m
src/Container/NSArray/NSArray+NSString.m
src/Container/NSArray/NSArray.m
src/Container/NSArray/NSEnumerator+NSArray.m
src/Container/NSArray/NSMutableArray.m
src/Container/NSArray/_MulleObjCArrayEnumerator.m
src/Container/NSArray/_MulleObjCConcreteArray.m
src/Container/NSArray/_MulleObjCEmptyArray.m
src/Container/NSArray/mulle_qsort_pointers.c
src/Container/NSDictionary/NSDictionary+NSArray.m
src/Container/NSDictionary/NSDictionary+NSString.m
src/Container/NSDictionary/NSDictionary.m
src/Container/NSDictionary/NSMapTable+NSArray+NSString.m
src/Container/NSDictionary/NSMutableDictionary+NSArray.m
src/Container/NSDictionary/NSMutableDictionary.m
src/Container/NSDictionary/NSThread+NSMutableDictionary.m
src/Container/NSDictionary/_MulleObjCConcreteDictionary.m
src/Container/NSDictionary/_MulleObjCConcreteMutableDictionary.m
src/Container/NSDictionary/_MulleObjCDictionary.m
src/Container/NSDictionary/ns_map_table.c
src/Container/NSEnumerator.m
src/Container/NSSet/NSHashTable+NSArray+NSString.m
src/Container/NSSet/NSMutableSet+NSArray.m
src/Container/NSSet/NSMutableSet.m
src/Container/NSSet/NSSet+NSArray.m
src/Container/NSSet/NSSet.m
src/Container/NSSet/_MulleObjCConcreteMutableSet.m
src/Container/NSSet/_MulleObjCConcreteSet.m
src/Container/NSSet/_MulleObjCSet.m
src/Container/NSSet/ns_hash_table.c
src/Data/NSData+NSString.m
src/Data/NSData.m
src/Data/NSMutableData.m
src/Data/_MulleObjCConcreteMutableData.m
src/Data/_MulleObjCDataSubclasses.m
src/Exception/NSAssertionHandler.m
src/Exception/NSError.m
src/Exception/NSException+String.m
src/Exception/NSException.m
src/KVC/NSArray+KeyValueCoding.m
src/KVC/NSArray+MulleObjCKVCArithmetic.m
src/KVC/NSArray+NSSortDescriptor.m
src/KVC/NSDictionary+KeyValueCoding.m
src/KVC/NSMutableDictionary+KeyValueCoding.m
src/KVC/NSNumber+MulleObjCKVCArithmetic.m
src/KVC/NSObject+KeyValueCoding.m
src/KVC/NSObject+_MulleObjCKVCInformation.m
src/KVC/NSProxy+_MulleObjCKVCInformation.m
src/KVC/NSSortDescriptor.m
src/KVC/_MulleObjCInstanceVariableAccess.m
src/KVC/_MulleObjCKVCInformation.m
src/Locale/NSArray+NSLocale.m
src/Locale/NSDate+NSLocale.m
src/Locale/NSDateFormatter+NSTimeZone.m
src/Locale/NSDictionary+NSLocale.m
src/Locale/NSFormatter+NSLocale.m
src/Locale/NSLocale.m
src/Locale/NSNumber+NSLocale.m
src/Locale/NSString+Localization.m
src/Locale/NSTimeZone+NSDate.m
src/Locale/NSTimeZone.m
src/MulleObjCFoundationSetup.m
src/Notification/NSNotification.m
src/Notification/NSNotificationCenter.m
src/PropertyList/NSData+Unicode.m
src/PropertyList/NSPropertyListSerialization.m
src/PropertyList/Parsing/NSArray+PropertyListParsing.m
src/PropertyList/Parsing/NSData+PropertyListParsing.m
src/PropertyList/Parsing/NSDictionary+PropertyListParsing.m
src/PropertyList/Parsing/NSObject+PropertyListParsing.m
src/PropertyList/Parsing/NSString+PropertyListParsing.m
src/PropertyList/Printing/NSArray+PropertyListPrinting.m
src/PropertyList/Printing/NSData+PropertyListPrinting.m
src/PropertyList/Printing/NSDate+PropertyListPrinting.m
src/PropertyList/Printing/NSDictionary+PropertyListPrinting.m
src/PropertyList/Printing/NSNumber+PropertyListPrinting.m
src/PropertyList/Printing/NSObject+PropertyListPrinting.m
src/PropertyList/Printing/NSString+PropertyListPrinting.m
src/PropertyList/Stream/_MulleObjCBufferedDataInputStream.m
src/PropertyList/Stream/_MulleObjCBufferedDataOutputStream.m
src/PropertyList/Stream/_MulleObjCDataStream.m
src/PropertyList/Stream/_MulleObjCPropertyListReader.m
src/PropertyList/Stream/_MulleObjCUTF8StreamReader.m
src/String/NSCharacterSet.m
src/String/NSConstantString.m
src/String/NSMutableString.m
src/String/NSMutableString+NSData.m
src/String/NSObject+NSString.m
src/String/NSMethodSignature+NSString.m
src/String/NSScanner.m
src/String/NSString+ClassCluster.m
src/String/NSString+Components.m
src/String/NSString+Escaping.m
src/String/NSString+NSCharacterSet.m
src/String/NSString+NSData.m
src/String/NSString+Search.m
src/String/NSString+Sprintf.m
src/String/NSString.m
src/String/http_parser.c
src/String/NSURL.m
src/String/_MulleObjCTaggedPointerChar5String.m
src/String/_MulleObjCTaggedPointerChar7String.m
src/String/_MulleObjCASCIIString.m
src/String/_MulleObjCCheatingASCIIString.m
src/String/_MulleObjCConcreteBitmapCharacterSet.m
src/String/_MulleObjCConcreteCharacterSet.m
src/String/_MulleObjCConcreteRangeCharacterSet.m
src/String/_MulleObjCEmptyString.m
src/String/_MulleObjCUTF16String.m
src/String/_MulleObjCUTF32String.m
src/String/mulle_sprintf_object.m
src/Value/NSDate.m
src/Value/NSDateFormatter.m
src/Value/NSFormatter.m
src/Value/NSLock+NSDate.m
src/Value/NSNull.m
src/Value/NSNumber+NSString.m
src/Value/NSNumber.m
src/Value/NSNumberFormatter.m
src/Value/NSThread+NSDate.m
src/Value/NSValue.m
src/Value/NSValue+NSString.m
src/Value/_MulleObjCConcreteNumber+NSString.m
src/Value/_MulleObjCConcreteNumber.m
src/Value/_MulleObjCConcreteValue.m
src/Value/_MulleObjCTaggedPointerIntegerNumber.m
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

