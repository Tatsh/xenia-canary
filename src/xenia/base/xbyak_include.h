// Wrapper so Xenia can use either bundled xbyak or system xbyak (XENIA_USE_SYSTEM_XBYAK). Header-only.
#ifndef XENIA_BASE_XBYAK_INCLUDE_H_
#define XENIA_BASE_XBYAK_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_XBYAK
#include <xbyak/xbyak.h>
#include <xbyak/xbyak_util.h>
#else
#include "third_party/xbyak/xbyak/xbyak.h"
#include "third_party/xbyak/xbyak/xbyak_util.h"
#endif

#endif  // XENIA_BASE_XBYAK_INCLUDE_H_
