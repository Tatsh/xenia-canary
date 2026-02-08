// Wrapper so Xenia can use either bundled fmt or system libfmt (XENIA_USE_SYSTEM_FMT).
#ifndef XENIA_BASE_FMT_INCLUDE_H_
#define XENIA_BASE_FMT_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_FMT
#include <fmt/format.h>
#include <fmt/printf.h>
#include <fmt/xchar.h>
#include <fmt/std.h>
#else
#include "third_party/fmt/include/fmt/format.h"
#include "third_party/fmt/include/fmt/printf.h"
#include "third_party/fmt/include/fmt/xchar.h"
#include "third_party/fmt/include/fmt/std.h"
#endif

#endif  // XENIA_BASE_FMT_INCLUDE_H_
