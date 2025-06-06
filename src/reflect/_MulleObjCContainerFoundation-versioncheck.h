/*
 *   This file will be regenerated by `mulle-project-versioncheck`.
 *   Any edits will be lost.
 */
#ifndef mulle_objc_container_foundation_versioncheck_h__
#define mulle_objc_container_foundation_versioncheck_h__

#if defined( MULLE_OBJC_VERSION)
# ifndef MULLE_OBJC_VERSION_MIN
#  define MULLE_OBJC_VERSION_MIN  ((0UL << 20) | (26 << 8) | 0)
# endif
# ifndef MULLE_OBJC_VERSION_MAX
#  define MULLE_OBJC_VERSION_MAX  ((0UL << 20) | (27 << 8) | 0)
# endif
# if MULLE_OBJC_VERSION < MULLE_OBJC_VERSION_MIN || MULLE_OBJC_VERSION >= MULLE_OBJC_VERSION_MAX
#  pragma message("MULLE_OBJC_VERSION     is " MULLE_C_STRINGIFY_MACRO( MULLE_OBJC_VERSION))
#  pragma message("MULLE_OBJC_VERSION_MIN is " MULLE_C_STRINGIFY_MACRO( MULLE_OBJC_VERSION_MIN))
#  pragma message("MULLE_OBJC_VERSION_MAX is " MULLE_C_STRINGIFY_MACRO( MULLE_OBJC_VERSION_MAX))
#  if MULLE_OBJC_VERSION < MULLE_OBJC_VERSION_MIN
#   error "MulleObjC is too old"
#  else
#   error "MulleObjC is too new"
#  endif
# endif
#endif

#endif
