// Wrapper so Xenia can use either bundled capstone or system libcapstone (XENIA_USE_SYSTEM_CAPSTONE).
#ifndef XENIA_BASE_CAPSTONE_INCLUDE_H_
#define XENIA_BASE_CAPSTONE_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_CAPSTONE
#include <capstone/capstone.h>
#include <capstone/x86.h>
#else
#include "third_party/capstone/include/capstone/capstone.h"
#include "third_party/capstone/include/capstone/x86.h"
#endif

#endif  // XENIA_BASE_CAPSTONE_INCLUDE_H_
