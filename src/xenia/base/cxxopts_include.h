// Wrapper so Xenia can use either bundled cxxopts or system cxxopts (XENIA_USE_SYSTEM_CXXOPTS). Header-only.
#ifndef XENIA_BASE_CXXOPTS_INCLUDE_H_
#define XENIA_BASE_CXXOPTS_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_CXXOPTS
#include <cxxopts.hpp>
#else
#include "third_party/cxxopts/include/cxxopts.hpp"
#endif

#endif  // XENIA_BASE_CXXOPTS_INCLUDE_H_
