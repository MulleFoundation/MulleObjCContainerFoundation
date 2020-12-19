/*
 *   This file will be regenerated by `mulle-sde reflect` and any edits will be
 *   lost. Suppress generation of this file with:
 *      mulle-sde environment --global \
 *         set MULLE_SOURCETREE_TO_C_IMPORT_FILE DISABLE
 *
 *   To not generate any header files:
 *      mulle-sde environment --global \
 *         set MULLE_SOURCETREE_TO_C_RUN DISABLE
 */

#ifndef _MulleObjCContainerFoundation_import_h__
#define _MulleObjCContainerFoundation_import_h__

// How to tweak the following MulleObjC #import
//    remove:             `mulle-sourcetree mark MulleObjC no-header`
//    rename:             `mulle-sde dependency|library set MulleObjC include whatever.h`
//    toggle #import:     `mulle-sourcetree mark MulleObjC [no-]import`
//    toggle localheader: `mulle-sourcetree mark MulleObjC [no-]localheader`
//    toggle public:      `mulle-sourcetree mark MulleObjC [no-]public`
//    toggle optional:    `mulle-sourcetree mark MulleObjC [no-]require`
//    remove for os:      `mulle-sourcetree mark MulleObjC no-os-<osname>`
# if defined( __has_include) && __has_include("MulleObjC.h")
#   import "MulleObjC.h"   // MulleObjC
# else
#   import <MulleObjC/MulleObjC.h>   // MulleObjC
# endif

#ifdef __has_include
# if __has_include( "_MulleObjCContainerFoundation-include.h")
#  include "_MulleObjCContainerFoundation-include.h"
# endif
#endif


#endif
