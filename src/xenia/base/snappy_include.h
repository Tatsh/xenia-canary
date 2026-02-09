// Wrapper so Xenia can use either bundled snappy or system libsnappy (XENIA_USE_SYSTEM_SNAPPY).
#ifndef XENIA_BASE_SNAPPY_INCLUDE_H_
#define XENIA_BASE_SNAPPY_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_SNAPPY
#include <snappy.h>
#include <snappy-sinksource.h>
#else
#include "third_party/snappy/snappy.h"
#include "third_party/snappy/snappy-sinksource.h"
#endif

#endif  // XENIA_BASE_SNAPPY_INCLUDE_H_
