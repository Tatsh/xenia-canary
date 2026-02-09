// Wrapper so Xenia can use either bundled Vulkan-Headers or system (XENIA_USE_SYSTEM_VULKAN_HEADERS). Header-only.
#ifndef XENIA_BASE_VULKAN_HEADERS_INCLUDE_H_
#define XENIA_BASE_VULKAN_HEADERS_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_VULKAN_HEADERS
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_hpp_macros.hpp>
#include <vulkan/vulkan_to_string.hpp>
#else
#include "third_party/Vulkan-Headers/include/vulkan/vulkan.h"
#include "third_party/Vulkan-Headers/include/vulkan/vulkan_hpp_macros.hpp"
#include "third_party/Vulkan-Headers/include/vulkan/vulkan_to_string.hpp"
#endif

#endif  // XENIA_BASE_VULKAN_HEADERS_INCLUDE_H_
