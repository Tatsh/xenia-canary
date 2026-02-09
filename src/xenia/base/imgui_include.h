// Wrapper so Xenia can use either bundled imgui or system (XENIA_USE_SYSTEM_IMGUI).
#ifndef XENIA_BASE_IMGUI_INCLUDE_H_
#define XENIA_BASE_IMGUI_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_IMGUI
#include <imgui/imgui.h>
#else
#include "third_party/imgui/imgui.h"
#endif

#endif  // XENIA_BASE_IMGUI_INCLUDE_H_
