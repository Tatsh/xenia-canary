// Wrapper so Xenia can use either bundled toml++ or system toml++ (XENIA_USE_SYSTEM_TOMLPLUSPLUS). Header-only.
#ifndef XENIA_BASE_TOMLPLUSPLUS_INCLUDE_H_
#define XENIA_BASE_TOMLPLUSPLUS_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_TOMLPLUSPLUS
#include <toml++/toml.hpp>
#else
#include "third_party/tomlplusplus/include/toml++/toml.hpp"
#endif

#endif  // XENIA_BASE_TOMLPLUSPLUS_INCLUDE_H_
