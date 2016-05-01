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
src/Base/ns_byteorder.h
src/Base/MulleObjCBaseFunctions.h
src/Base/MulleObjCFoundationBase.h
src/Base/NSMutableCopying.h
src/Base/ns_foundationconfiguration.h
src/Container/MulleObjCContainerCallback.h
src/Container/MulleObjCFoundationContainer.h
src/Container/NSArray/NSArray+NSString.h
src/Container/NSArray/NSArray.h
src/Container/NSArray/NSEnumerator+NSArray.h
src/Container/NSArray/NSMutableArray.h
src/Container/NSDictionary/NSDictionary+NSArray.h
src/Container/NSDictionary/NSDictionary.h
src/Container/NSDictionary/NSMapTable+NSArray+NSString.h
src/Container/NSDictionary/NSMutableDictionary+NSArray.h
src/Container/NSDictionary/NSMutableDictionary.h
src/Container/NSDictionary/NSThread+NSMutableDictionary.h
src/Container/NSDictionary/ns_map_table.h
src/Container/NSEnumerator.h
src/Container/NSSet/NSHashTable+NSArray+NSString.h
src/Container/NSSet/NSMutableSet.h
src/Container/NSSet/NSMutableSet+NSArray.h
src/Container/NSSet/NSSet.h
src/Container/NSSet/NSSet+NSArray.h
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
src/MulleObjCFoundation.h
src/MulleObjCFoundationCore.h
src/Notification/MulleObjCFoundationNotification.h
src/Notification/NSNotification.h
src/Notification/NSNotificationCenter.h
src/String/MulleObjCFoundationString.h
src/String/NSCharacterSet.h
src/String/NSConstantString.h
src/String/NSMutableString.h
src/String/NSScanner.h
src/String/NSString+NSCharacterSet.h
src/String/NSString+ClassCluster.h
src/String/NSString+Components.h
src/String/NSString+Escaping.h
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
src/PropertyList/MulleObjCFoundationPropertyList.h
src/PropertyList/NSPropertyListSerialization.h
src/PropertyList/Parsing/NSObject+PropertyListParsing.h
src/PropertyList/Printing/NSArray+PropertyListPrinting.h
src/Locale/MulleObjCFoundationLocale.h
src/Locale/NSFormatter+NSLocale.h
src/Locale/NSLocale.h
src/Locale/NSDate+NSLocale.h
src/Locale/NSNumber+NSLocale.h
src/Locale/NSTimeZone.h
src/Locale/NSTimeZone+NSDate.h
src/Locale/NSString+Localization.h
src/Locale/NSArray+NSLocale.h
src/Locale/NSDictionary+NSLocale.h
)


add_library(MulleObjCFoundation STATIC
src/Archiver/MulleObjCArchiver.m
src/Archiver/MulleObjCUnarchiver.m
src/Archiver/NSArchiver.m
src/Archiver/NSKeyedArchiver.m
src/Archiver/NSKeyedUnarchiver.h
src/Archiver/NSUnarchiver.m
src/Base/ns_foundationconfiguration.c
src/Base/MulleObjCBaseFunctions.m
src/Container/MulleObjCContainerCallback.m
src/Container/NSArray/NSArray+NSString.m
src/Container/NSArray/NSArray.m
src/Container/NSArray/NSEnumerator+NSArray.m
src/Container/NSArray/NSMutableArray.m
src/Container/NSArray/_MulleObjCArrayEnumerator.m
src/Container/NSArray/_MulleObjCConcreteArray.m
src/Container/NSArray/_MulleObjCEmptyArray.m
src/Container/NSDictionary/NSDictionary+NSArray.m
src/Container/NSDictionary/NSDictionary.m
src/Container/NSDictionary/NSMapTable+NSArray+NSString.m
src/Container/NSDictionary/NSMutableDictionary+NSArray.m
src/Container/NSDictionary/NSMutableDictionary.m
src/Container/NSDictionary/NSThread+NSMutableDictionary.m
src/Container/NSDictionary/_MulleObjCConcreteDictionary.m
src/Container/NSDictionary/ns_map_table.c
src/Container/NSEnumerator.m
src/Container/NSSet/NSHashTable+NSArray+NSString.m
src/Container/NSSet/NSMutableSet+NSArray.m
src/Container/NSSet/NSMutableSet.m
src/Container/NSSet/NSSet+NSArray.m
src/Container/NSSet/NSSet.m
src/Container/NSSet/_MulleObjCConcreteSet.m
src/Container/NSSet/_MulleObjCConcreteMutableSet.m
src/Container/NSSet/ns_hash_table.c
src/Data/NSData.m
src/Data/NSMutableData.m
src/Data/_MulleObjCConcreteMutableData.m
src/Data/_MulleObjCDataSubclasses.m
src/Exception/NSAssertionHandler.m
src/Exception/NSError.m
src/Exception/NSException.m
src/KVC/NSArray+KeyValueCoding.m
src/KVC/NSDictionary+KeyValueCoding.m
src/KVC/NSMutableDictionary+KeyValueCoding.m
src/KVC/NSObject+KeyValueCoding.m
src/KVC/NSObject+_MulleObjCKVCCache.m
src/KVC/NSObject+_MulleObjCKVCInformation.m
src/KVC/NSProxy+_MulleObjCKVCInformation.m
src/KVC/_MulleObjCInstanceVariableAccess.m
src/KVC/_MulleObjCKVCCache.m
src/KVC/_MulleObjCKVCInformation.m
src/KVC/_MulleObjCKVCKeybasedCache.m
src/Notification/NSNotification.m
src/Notification/NSNotificationCenter.m
src/String/NSCharacterSet.m
src/String/NSConstantString.m
src/String/NSMutableString.m
src/String/NSScanner.m
src/String/NSString+ClassCluster.m
src/String/NSString+Components.m
src/String/NSString+Escaping.m
src/String/NSString+NSCharacterSet.m
src/String/NSString+NSData.m
src/String/NSString+Search.m
src/String/NSString+Sprintf.m
src/String/NSString.m
src/String/NSURL.m
src/String/_MulleObjCASCIIString.m
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
src/Value/_MulleObjCConcreteNumber+NSString.m
src/Value/_MulleObjCConcreteNumber.m
src/Value/_MulleObjCConcreteValue.m
src/Locale/NSFormatter+NSLocale.m
src/Locale/NSLocale.m
src/Locale/NSNumber+NSLocale.m
src/Locale/NSTimeZone.m
src/Locale/NSTimeZone+NSDate.m
src/Locale/NSString+Localization.m
src/Locale/NSArray+NSLocale.m
src/Locale/NSDate+NSLocale.m
src/Locale/NSDictionary+NSLocale.m
src/PropertyList/Stream/_MulleObjCBufferedDataInputStream.m
src/PropertyList/Stream/_MulleObjCBufferedDataOutputStream.m
src/PropertyList/Stream/_MulleObjCDataStream.m
src/PropertyList/Stream/_MulleObjCUTF8StreamReader.m
src/PropertyList/Stream/_MulleObjCPropertyListReader.m
src/PropertyList/NSPropertyListSerialization.m
src/PropertyList/NSData+Unicode.m
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

