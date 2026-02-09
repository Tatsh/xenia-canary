// Wrapper so Xenia can use either bundled VulkanMemoryAllocator or system (XENIA_USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR). Header-only.
#ifndef XENIA_BASE_VULKAN_MEMORY_ALLOCATOR_INCLUDE_H_
#define XENIA_BASE_VULKAN_MEMORY_ALLOCATOR_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR
#include <vk_mem_alloc.h>
#else
#include "third_party/VulkanMemoryAllocator/include/vk_mem_alloc.h"
#endif

#endif  // XENIA_BASE_VULKAN_MEMORY_ALLOCATOR_INCLUDE_H_
