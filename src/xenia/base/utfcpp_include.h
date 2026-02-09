// Wrapper so Xenia can use either bundled utfcpp (utf8-cpp) or system (XENIA_USE_SYSTEM_UTFCPP). Header-only.
#ifndef XENIA_BASE_UTFCPP_INCLUDE_H_
#define XENIA_BASE_UTFCPP_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_UTFCPP
#ifdef XENIA_USE_SYSTEM_UTFCPP_UTF8CPP_HEADER
#include <utf8cpp/utf8.h>
#else
#include <utf8.h>
#endif
#else
#include "third_party/utfcpp/source/utf8.h"
#endif

#endif  // XENIA_BASE_UTFCPP_INCLUDE_H_
