// Wrapper so Xenia can use either bundled zarchive or system lib (XENIA_USE_SYSTEM_ZARCHIVE).
#ifndef XENIA_BASE_ZARCHIVE_INCLUDE_H_
#define XENIA_BASE_ZARCHIVE_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_ZARCHIVE
#include <zarchive/zarchivecommon.h>
#include <zarchive/zarchivereader.h>
#include <zarchive/zarchivewriter.h>
#else
#include "third_party/zarchive/include/zarchive/zarchivecommon.h"
#include "third_party/zarchive/include/zarchive/zarchivereader.h"
#include "third_party/zarchive/include/zarchive/zarchivewriter.h"
#endif

#endif  // XENIA_BASE_ZARCHIVE_INCLUDE_H_
