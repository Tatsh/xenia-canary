project_root = "../../../.."
include(project_root.."/tools/build")

group("src")
project("xenia-gpu-null")
  uuid("42FCA0B3-4C20-4532-95E9-07D297013BE4")
  kind("StaticLib")
  language("C++")
  if use_system_xxhash then
    pkg_config.all("libxxhash")
  end
  links({
    "xenia-base",
    "xenia-gpu",
    "xenia-ui",
    "xenia-ui-vulkan",
    "xxhash",
  })
  if not use_system_vulkan_headers then
    includedirs({
      project_root.."/third_party/Vulkan-Headers/include",
    })
  end
  local_platform_files()
