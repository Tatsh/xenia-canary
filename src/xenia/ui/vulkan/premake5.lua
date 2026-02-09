project_root = "../../../.."
include(project_root.."/tools/build")

group("src")
project("xenia-ui-vulkan")
  uuid("4933d81e-1c2c-4d5d-b104-3c0eb9dc2f00")
  kind("StaticLib")
  language("C++")
  links({
    "xenia-base",
    "xenia-ui",
  })
  if not use_system_vulkan_headers then
    includedirs({
      project_root.."/third_party/Vulkan-Headers/include",
    })
  end
  local_platform_files()
  local_platform_files("functions")
  files({
    "../shaders/bytecode/vulkan_spirv/*.h",
  })

if enableMiscSubprojects then
  group("demos")
  project("xenia-ui-window-vulkan-demo")
    uuid("97598f13-3177-454c-8e58-c59e2b6ede27")
    single_library_windowed_app_kind()
    language("C++")
    if use_system_fmt then
      pkg_config.all("fmt")
    end
    if use_system_imgui then
      pkg_config.all("imgui")
    end
    links({
      "fmt",
      "xenia-base",
      "xenia-ui",
      "xenia-ui-vulkan",
    })
    if not use_system_imgui then
      links({ "imgui" })
    end
    if not use_system_vulkan_headers then
      includedirs({
        project_root.."/third_party/Vulkan-Headers/include",
      })
    end
    files({
      "../window_demo.cc",
      "vulkan_window_demo.cc",
      project_root.."/src/xenia/ui/windowed_app_main_"..platform_suffix..".cc",
    })
    resincludedirs({
      project_root,
    })

    filter("platforms:Linux")
      links({
        "X11",
        "xcb",
        "X11-xcb",
      })
end