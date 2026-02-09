project_root = "../../.."
include(project_root.."/tools/build")

project("xenia-base")
  uuid("aeadaf22-2b20-4941-b05f-a802d5679c11")
  kind("StaticLib")
  language("C++")
  if use_system_fmt then
    pkg_config.all("fmt")
  end
  links({
    "fmt",
  })
  filter("platforms:Linux or platforms:Mac")
    sdl2_include()
  filter({})
  local_platform_files()
  removefiles({
    "console_app_main_*.cc",
    "main_init_*.cc",
  })
  files({
    "debug_visualizers.natvis",
  })

if enableTests then
  include("testing")
end
