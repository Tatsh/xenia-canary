// Wrapper so Xenia can use either bundled imgui_internal.h or system (XENIA_USE_SYSTEM_IMGUI).
#ifndef XENIA_BASE_IMGUI_INTERNAL_INCLUDE_H_
#define XENIA_BASE_IMGUI_INTERNAL_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_IMGUI
#include <imgui/imgui_internal.h>
#else
#include "third_party/imgui/imgui_internal.h"
#endif

#endif  // XENIA_BASE_IMGUI_INTERNAL_INCLUDE_H_
