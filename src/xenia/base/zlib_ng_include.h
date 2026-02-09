// Wrapper so Xenia can use either bundled zlib-ng or system libz-ng (XENIA_USE_SYSTEM_ZLIB_NG).
#ifndef XENIA_BASE_ZLIB_NG_INCLUDE_H_
#define XENIA_BASE_ZLIB_NG_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_ZLIB_NG
#include <zlib-ng.h>
#else
#include "third_party/zlib-ng/zlib-ng.h"
#endif

#endif  // XENIA_BASE_ZLIB_NG_INCLUDE_H_
