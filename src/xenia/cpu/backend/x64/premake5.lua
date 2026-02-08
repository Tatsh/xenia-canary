project_root = "../../../../.."
include(project_root.."/tools/build")

group("src")
project("xenia-cpu-backend-x64")
  uuid("7d8d5dce-4696-4197-952a-09506f725afe")
  kind("StaticLib")
  language("C++")
  if use_system_fmt then
    pkg_config.all("fmt")
  end
  if use_system_capstone then
    pkg_config.all("capstone")
  end
  links({
    "capstone",
    "fmt",
    "xenia-base",
    "xenia-cpu",
  })
  defines({
    "XBYAK_NO_OP_NAMES",
    "XBYAK_ENABLE_OMITTED_OPERAND",
  })
  if not use_system_capstone then
    defines({
      "CAPSTONE_X86_ATT_DISABLE",
      "CAPSTONE_HAS_X86",
      "CAPSTONE_USE_SYS_DYN_MEM",
    })
  end
  -- Enable VTune, if it's installed.
  if os.isdir(project_root.."/third_party/vtune") then
    defines { "ENABLE_VTUNE=1" }
  end

  if not use_system_capstone then
    includedirs({
      project_root.."/third_party/capstone/include",
    })
  end
  local_platform_files()
