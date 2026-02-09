project_root = "../../../.."
include(project_root.."/tools/build")

group("src")
project("xenia-debug-ui")
  uuid("9193a274-f4c2-4746-bd85-93fcfc5c3e38")
  kind("StaticLib")
  language("C++")
  if use_system_imgui then
    pkg_config.all("imgui")
  else
    links({ "imgui" })
  end
  links({
    "xenia-base",
    "xenia-cpu",
    "xenia-ui",
  })
  local_platform_files()
