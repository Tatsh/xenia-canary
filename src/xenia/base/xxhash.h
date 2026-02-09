/**
 ******************************************************************************
 * Xenia : Xbox 360 Emulator Research Project                                 *
 ******************************************************************************
 * Copyright 2020 Ben Vanik. All rights reserved.                             *
 * Released under the BSD license - see LICENSE in the root for more details. *
 ******************************************************************************
 */

#ifndef XENIA_BASE_XXHASH_H_
#define XENIA_BASE_XXHASH_H_

#ifdef XENIA_USE_SYSTEM_XXHASH
/* Expose XXH3_state_s definition so stack-allocated XXH3_state_t is valid. */
#define XXH_STATIC_LINKING_ONLY
#include <xxhash.h>
#else
#define XXH_INLINE_ALL

// Can't use XXH_X86DISPATCH because XXH is calculated on multiple threads,
// while the dispatch writes the result (multiple pointers without any
// synchronization) to XXH_g_dispatch at the first call.

#include "third_party/xxhash/xxhash.h"
#endif

#endif  // XENIA_BASE_XXHASH_H_
