include("tools/build")
if _ACTION == "export-compile-commands" then
  require("third_party/premake-export-compile-commands/export-compile-commands")
end
if os.istarget("android") then
  require("third_party/premake-androidndk/androidndk")
end
if _ACTION == "cmake" then
  require("third_party/premake-cmake/cmake")
end

location(build_root)
targetdir(build_bin)
objdir(build_obj)

-- Define variables for enabling specific submodules
-- Todo: Add changing from xb command
enableTests = false
enableMiscSubprojects = false

-- USE_SYSTEM_XXHASH: use system libxxhash when set (Linux only). Fail if set and not found.
use_system_xxhash = false
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_XXHASH") or ""
  if env ~= "" and env ~= "0" then
    use_system_xxhash = true
    if not os.execute("pkg-config --exists libxxhash") then
      error("USE_SYSTEM_XXHASH is set but libxxhash was not found. Install dev-libs/xxhash or unset USE_SYSTEM_XXHASH.")
    end
  end
end

-- USE_SYSTEM_FMT: use system libfmt when set (Linux only). Fail if set and not found.
use_system_fmt = false
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_FMT") or ""
  if env ~= "" and env ~= "0" then
    use_system_fmt = true
    if not os.execute("pkg-config --exists fmt") then
      error("USE_SYSTEM_FMT is set but fmt was not found. Install dev-libs/libfmt or unset USE_SYSTEM_FMT.")
    end
  end
end

-- USE_SYSTEM_ZSTD: use system libzstd when set (Linux only). Fail if set and not found.
use_system_zstd = false
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_ZSTD") or ""
  if env ~= "" and env ~= "0" then
    use_system_zstd = true
    if not os.execute("pkg-config --exists libzstd") then
      error("USE_SYSTEM_ZSTD is set but libzstd was not found. Install app-arch/zstd or unset USE_SYSTEM_ZSTD.")
    end
  end
end

-- USE_SYSTEM_ZARCHIVE: use system zarchive when set (Linux only). Fail if set and not found.
use_system_zarchive = false
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_ZARCHIVE") or ""
  if env ~= "" and env ~= "0" then
    use_system_zarchive = true
    if not os.execute("pkg-config --exists zarchive") then
      error("USE_SYSTEM_ZARCHIVE is set but zarchive was not found. Install app-arch/zarchive or unset USE_SYSTEM_ZARCHIVE.")
    end
  end
end

-- USE_SYSTEM_GLSLANG: use system glslang when set (Linux only). Fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo dev-util/glslang only installs CMake config),
-- fall back to detecting /usr/include/glslang.
use_system_glslang = false
glslang_pkg_config_available = false
glslang_system_include = nil
glslang_system_links = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_GLSLANG") or ""
  if env ~= "" and env ~= "0" then
    use_system_glslang = true
    glslang_pkg_config_available = os.execute("pkg-config --exists glslang")
    if not glslang_pkg_config_available then
      -- Gentoo and some distros install glslang without a .pc file; check for headers.
      if os.isdir("/usr/include/glslang") or os.isdir("/usr/include/glslang/SPIRV") then
        glslang_system_include = "/usr/include"
        -- Many distros (e.g. Gentoo) build glslang without exporting the C++ spv::Builder API;
        -- link may then fail with undefined spv::Builder. Unset USE_SYSTEM_GLSLANG to use bundled.
        glslang_system_links = { "glslang", "SPIRV" }
      else
        error("USE_SYSTEM_GLSLANG is set but glslang was not found (no pkg-config and no /usr/include/glslang). Install dev-util/glslang or unset USE_SYSTEM_GLSLANG.")
      end
    end
  end
end

-- USE_SYSTEM_CAPSTONE: use system capstone when set (Linux only). Fail if set and not found.
use_system_capstone = false
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_CAPSTONE") or ""
  if env ~= "" and env ~= "0" then
    use_system_capstone = true
    if not os.execute("pkg-config --exists capstone") then
      error("USE_SYSTEM_CAPSTONE is set but capstone was not found. Install dev-libs/capstone or unset USE_SYSTEM_CAPSTONE.")
    end
  end
end

-- USE_SYSTEM_SNAPPY: use system snappy when set (Linux only). Fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo app-arch/snappy without .pc), fall back to /usr/include/snappy.h.
use_system_snappy = false
snappy_pkg_config_available = false
snappy_system_include = nil
snappy_system_links = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_SNAPPY") or ""
  if env ~= "" and env ~= "0" then
    use_system_snappy = true
    snappy_pkg_config_available = os.execute("pkg-config --exists snappy")
    if not snappy_pkg_config_available then
      if os.isfile("/usr/include/snappy.h") or os.isfile("/usr/include/snappy/snappy.h") then
        snappy_system_include = "/usr/include"
        snappy_system_links = { "snappy" }
      else
        error("USE_SYSTEM_SNAPPY is set but snappy was not found (no pkg-config and no /usr/include/snappy.h). Install app-arch/snappy or unset USE_SYSTEM_SNAPPY.")
      end
    end
  end
end

-- USE_SYSTEM_PUGIXML: use system pugixml when set (Linux only). Fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo without .pc), fall back to /usr/include/pugixml.hpp.
use_system_pugixml = false
pugixml_pkg_config_available = false
pugixml_system_include = nil
pugixml_system_links = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_PUGIXML") or ""
  if env ~= "" and env ~= "0" then
    use_system_pugixml = true
    pugixml_pkg_config_available = os.execute("pkg-config --exists pugixml")
    if not pugixml_pkg_config_available then
      if os.isfile("/usr/include/pugixml.hpp") then
        pugixml_system_include = "/usr/include"
        pugixml_system_links = { "pugixml" }
      else
        error("USE_SYSTEM_PUGIXML is set but pugixml was not found (no pkg-config and no /usr/include/pugixml.hpp). Install dev-libs/pugixml or unset USE_SYSTEM_PUGIXML.")
      end
    end
  end
end

-- USE_SYSTEM_ZLIB_NG: use system zlib-ng when set (Linux only). Fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo without .pc), fall back to /usr/include/zlib-ng.h.
use_system_zlib_ng = false
zlib_ng_pkg_config_available = false
zlib_ng_system_include = nil
zlib_ng_system_links = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_ZLIB_NG") or ""
  if env ~= "" and env ~= "0" then
    use_system_zlib_ng = true
    zlib_ng_pkg_config_available = os.execute("pkg-config --exists zlib-ng")
    if not zlib_ng_pkg_config_available then
      if os.isfile("/usr/include/zlib-ng.h") then
        zlib_ng_system_include = "/usr/include"
        zlib_ng_system_links = { "z-ng" }
      else
        error("USE_SYSTEM_ZLIB_NG is set but zlib-ng was not found (no pkg-config and no /usr/include/zlib-ng.h). Install sys-libs/zlib-ng or unset USE_SYSTEM_ZLIB_NG.")
      end
    end
  end
end

-- USE_SYSTEM_CXXOPTS: use system cxxopts when set (Linux only). Header-only; fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo without .pc), fall back to /usr/include/cxxopts.hpp.
use_system_cxxopts = false
cxxopts_pkg_config_available = false
cxxopts_system_include = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_CXXOPTS") or ""
  if env ~= "" and env ~= "0" then
    use_system_cxxopts = true
    cxxopts_pkg_config_available = os.execute("pkg-config --exists cxxopts")
    if not cxxopts_pkg_config_available then
      if os.isfile("/usr/include/cxxopts.hpp") or os.isdir("/usr/include/cxxopts") then
        cxxopts_system_include = "/usr/include"
      else
        error("USE_SYSTEM_CXXOPTS is set but cxxopts was not found (no pkg-config and no /usr/include/cxxopts.hpp). Install dev-libs/cxxopts or unset USE_SYSTEM_CXXOPTS.")
      end
    end
  end
end

-- USE_SYSTEM_XBYAK: use system xbyak when set (Linux only). Header-only; fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo without .pc), fall back to /usr/include/xbyak.
use_system_xbyak = false
xbyak_pkg_config_available = false
xbyak_system_include = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_XBYAK") or ""
  if env ~= "" and env ~= "0" then
    use_system_xbyak = true
    xbyak_pkg_config_available = os.execute("pkg-config --exists xbyak")
    if not xbyak_pkg_config_available then
      if os.isfile("/usr/include/xbyak/xbyak.h") or os.isdir("/usr/include/xbyak") then
        xbyak_system_include = "/usr/include"
      else
        error("USE_SYSTEM_XBYAK is set but xbyak was not found (no pkg-config and no /usr/include/xbyak). Install dev-libs/xbyak or unset USE_SYSTEM_XBYAK.")
      end
    end
  end
end

-- USE_SYSTEM_TOMLPLUSPLUS: use system toml++ when set (Linux only). Header-only; fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo without .pc), fall back to /usr/include/toml++.
use_system_tomlplusplus = false
tomlplusplus_pkg_config_available = false
tomlplusplus_system_include = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_TOMLPLUSPLUS") or ""
  if env ~= "" and env ~= "0" then
    use_system_tomlplusplus = true
    tomlplusplus_pkg_config_available = os.execute("pkg-config --exists tomlplusplus")
    if not tomlplusplus_pkg_config_available then
      if os.isfile("/usr/include/toml++/toml.hpp") or os.isdir("/usr/include/toml++") then
        tomlplusplus_system_include = "/usr/include"
      else
        error("USE_SYSTEM_TOMLPLUSPLUS is set but tomlplusplus was not found (no pkg-config and no /usr/include/toml++). Install dev-cpp/tomlplusplus or unset USE_SYSTEM_TOMLPLUSPLUS.")
      end
    end
  end
end

-- USE_SYSTEM_UTFCPP: use system utfcpp (utf8-cpp) when set (Linux only). Header-only; fail if set and not found.
-- Prefer pkg-config; if unavailable (e.g. Gentoo without .pc), fall back to /usr/include/utf8.h or /usr/include/utf8cpp/utf8.h (CMake install).
use_system_utfcpp = false
utfcpp_pkg_config_available = false
utfcpp_system_include = nil
utfcpp_system_use_utf8cpp_dir = false  -- true when headers are in include/utf8cpp/ (e.g. Gentoo dev-libs/utfcpp)
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_UTFCPP") or ""
  if env ~= "" and env ~= "0" then
    use_system_utfcpp = true
    utfcpp_pkg_config_available = os.execute("pkg-config --exists utfcpp") or os.execute("pkg-config --exists utf8cpp")
    if not utfcpp_pkg_config_available then
      if os.isfile("/usr/include/utf8.h") or (os.isdir("/usr/include/utf8") and os.isfile("/usr/include/utf8/core.h")) then
        utfcpp_system_include = "/usr/include"
      elseif os.isfile("/usr/include/utf8cpp/utf8.h") or (os.isdir("/usr/include/utf8cpp/utf8") and os.isfile("/usr/include/utf8cpp/utf8/core.h")) then
        utfcpp_system_include = "/usr/include"
        utfcpp_system_use_utf8cpp_dir = true
      else
        error("USE_SYSTEM_UTFCPP is set but utfcpp was not found (no pkg-config, no /usr/include/utf8.h, no /usr/include/utf8cpp/utf8.h). Install dev-libs/utfcpp or unset USE_SYSTEM_UTFCPP.")
      end
    end
  end
end

-- USE_SYSTEM_VULKAN_HEADERS: use system Vulkan headers when set (Linux only). Header-only; fail if set and not found.
use_system_vulkan_headers = false
vulkan_headers_pkg_config_available = false
vulkan_headers_system_include = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_VULKAN_HEADERS") or ""
  if env ~= "" and env ~= "0" then
    use_system_vulkan_headers = true
    vulkan_headers_pkg_config_available = os.execute("pkg-config --exists vulkan-headers") or os.execute("pkg-config --exists VulkanHeaders")
    if not vulkan_headers_pkg_config_available then
      if os.isfile("/usr/include/vulkan/vulkan.h") or os.isdir("/usr/include/vulkan") then
        vulkan_headers_system_include = "/usr/include"
      else
        error("USE_SYSTEM_VULKAN_HEADERS is set but Vulkan headers were not found (no pkg-config and no /usr/include/vulkan). Install dev-util/vulkan-headers or unset USE_SYSTEM_VULKAN_HEADERS.")
      end
    end
  end
end

-- USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR: use system VulkanMemoryAllocator when set (Linux only). Header-only; fail if set and not found.
use_system_vulkan_memory_allocator = false
vulkan_memory_allocator_pkg_config_available = false
vulkan_memory_allocator_system_include = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR") or ""
  if env ~= "" and env ~= "0" then
    use_system_vulkan_memory_allocator = true
    vulkan_memory_allocator_pkg_config_available = os.execute("pkg-config --exists VulkanMemoryAllocator") or os.execute("pkg-config --exists vk_mem_alloc")
    if not vulkan_memory_allocator_pkg_config_available then
      if os.isfile("/usr/include/vk_mem_alloc.h") or os.isdir("/usr/include/VulkanMemoryAllocator") then
        vulkan_memory_allocator_system_include = "/usr/include"
      else
        error("USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR is set but VulkanMemoryAllocator was not found (no pkg-config and no /usr/include/vk_mem_alloc.h). Install media-libs/VulkanMemoryAllocator or unset USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR.")
      end
    end
  end
end

-- USE_SYSTEM_DISCORD_RPC: use system discord-rpc when set (Linux only). Link lib; fail if set and not found.
use_system_discord_rpc = false
discord_rpc_pkg_config_available = false
discord_rpc_system_include = nil
discord_rpc_system_links = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_DISCORD_RPC") or ""
  if env ~= "" and env ~= "0" then
    use_system_discord_rpc = true
    discord_rpc_pkg_config_available = os.execute("pkg-config --exists discord-rpc") or os.execute("pkg-config --exists discord_rpc")
    if not discord_rpc_pkg_config_available then
      if os.isfile("/usr/include/discord_rpc.h") and (os.isfile("/usr/lib/libdiscord-rpc.so") or os.isfile("/usr/lib64/libdiscord-rpc.so")) then
        discord_rpc_system_include = "/usr/include"
        discord_rpc_system_links = "discord-rpc"
      else
        error("USE_SYSTEM_DISCORD_RPC is set but discord-rpc was not found (no pkg-config and no /usr/include/discord_rpc.h + libdiscord-rpc.so). Install dev-libs/discord-rpc or unset USE_SYSTEM_DISCORD_RPC.")
      end
    end
  end
end

-- USE_SYSTEM_IMGUI: use system imgui when set (Linux only). Link lib; fail if set and not found.
use_system_imgui = false
imgui_pkg_config_available = false
imgui_system_include = nil
imgui_system_links = nil
if os.istarget("linux") then
  local env = os.getenv("USE_SYSTEM_IMGUI") or ""
  if env ~= "" and env ~= "0" then
    use_system_imgui = true
    imgui_pkg_config_available = os.execute("pkg-config --exists imgui")
    if not imgui_pkg_config_available then
      if (os.isfile("/usr/include/imgui/imgui.h") or os.isdir("/usr/include/imgui")) and (os.isfile("/usr/lib/libimgui.a") or os.isfile("/usr/lib/libimgui.so") or os.isfile("/usr/lib64/libimgui.a") or os.isfile("/usr/lib64/libimgui.so")) then
        imgui_system_include = "/usr/include"
        imgui_system_links = "imgui"
      else
        error("USE_SYSTEM_IMGUI is set but imgui was not found (no pkg-config and no /usr/include/imgui + libimgui). Install media-libs/imgui or unset USE_SYSTEM_IMGUI.")
      end
    end
  end
end

-- Define an ARCH variable
-- Only use this to enable architecture-specific functionality.
if os.istarget("linux") then
  ARCH = os.outputof("uname -p")
else
  ARCH = "unknown"
end

includedirs({
  ".",
  "src",
  "third_party",
})
if use_system_cxxopts then
  if cxxopts_system_include then
    includedirs(cxxopts_system_include)
  else
    local cflags = os.outputof("pkg-config --cflags cxxopts")
    if cflags then
      for _, flag in next, string.explode(cflags, " ") do
        if flag and flag:sub(1, 2) == "-I" then
          includedirs(flag:sub(3))
        end
      end
    end
  end
end
if use_system_xbyak then
  if xbyak_system_include then
    includedirs(xbyak_system_include)
  else
    local cflags = os.outputof("pkg-config --cflags xbyak")
    if cflags then
      for _, flag in next, string.explode(cflags, " ") do
        if flag and flag:sub(1, 2) == "-I" then
          includedirs(flag:sub(3))
        end
      end
    end
  end
end
if use_system_tomlplusplus then
  if tomlplusplus_system_include then
    includedirs(tomlplusplus_system_include)
  else
    local cflags = os.outputof("pkg-config --cflags tomlplusplus")
    if cflags then
      for _, flag in next, string.explode(cflags, " ") do
        if flag and flag:sub(1, 2) == "-I" then
          includedirs(flag:sub(3))
        end
      end
    end
  end
end
if use_system_utfcpp then
  if utfcpp_system_include then
    includedirs(utfcpp_system_include)
  else
    local cflags = os.outputof("pkg-config --cflags utfcpp") or os.outputof("pkg-config --cflags utf8cpp")
    if cflags and cflags ~= "" then
      for _, flag in next, string.explode(cflags, " ") do
        if flag and flag:sub(1, 2) == "-I" then
          includedirs(flag:sub(3))
        end
      end
    end
  end
end
if use_system_vulkan_headers then
  if vulkan_headers_system_include then
    includedirs(vulkan_headers_system_include)
  else
    local cflags = os.outputof("pkg-config --cflags vulkan-headers") or os.outputof("pkg-config --cflags VulkanHeaders")
    if cflags and cflags ~= "" then
      for _, flag in next, string.explode(cflags, " ") do
        if flag and flag:sub(1, 2) == "-I" then
          includedirs(flag:sub(3))
        end
      end
    end
  end
end
if use_system_vulkan_memory_allocator then
  if vulkan_memory_allocator_system_include then
    includedirs(vulkan_memory_allocator_system_include)
  else
    local cflags = os.outputof("pkg-config --cflags VulkanMemoryAllocator") or os.outputof("pkg-config --cflags vk_mem_alloc")
    if cflags and cflags ~= "" then
      for _, flag in next, string.explode(cflags, " ") do
        if flag and flag:sub(1, 2) == "-I" then
          includedirs(flag:sub(3))
        end
      end
    end
  end
end

defines({
  "VULKAN_HPP_NO_TO_STRING",
  "IMGUI_DISABLE_DEFAULT_FONT",
  --"IMGUI_USE_WCHAR32",
  "IMGUI_USE_STB_SPRINTF",
  --"IMGUI_ENABLE_FREETYPE",
  "USE_CPP17", -- Tabulate
})
if use_system_xxhash then
  defines({ "XENIA_USE_SYSTEM_XXHASH" })
end
if use_system_fmt then
  defines({ "XENIA_USE_SYSTEM_FMT" })
end
if use_system_zstd then
  defines({ "XENIA_USE_SYSTEM_ZSTD" })
end
if use_system_zarchive then
  defines({ "XENIA_USE_SYSTEM_ZARCHIVE" })
end
if use_system_glslang then
  defines({ "XENIA_USE_SYSTEM_GLSLANG" })
end
if use_system_capstone then
  defines({ "XENIA_USE_SYSTEM_CAPSTONE" })
  defines({ "CAPSTONE_X86_ATT_DISABLE", "CAPSTONE_HAS_X86", "CAPSTONE_USE_SYS_DYN_MEM" })
end
if use_system_snappy then
  defines({ "XENIA_USE_SYSTEM_SNAPPY" })
end
if use_system_pugixml then
  defines({ "XENIA_USE_SYSTEM_PUGIXML" })
end
if use_system_zlib_ng then
  defines({ "XENIA_USE_SYSTEM_ZLIB_NG" })
end
if use_system_cxxopts then
  defines({ "XENIA_USE_SYSTEM_CXXOPTS" })
end
if use_system_xbyak then
  defines({ "XENIA_USE_SYSTEM_XBYAK" })
end
if use_system_tomlplusplus then
  defines({ "XENIA_USE_SYSTEM_TOMLPLUSPLUS" })
end
if use_system_utfcpp then
  defines({ "XENIA_USE_SYSTEM_UTFCPP" })
  if utfcpp_system_use_utf8cpp_dir then
    defines({ "XENIA_USE_SYSTEM_UTFCPP_UTF8CPP_HEADER" })
  end
end
if use_system_vulkan_headers then
  defines({ "XENIA_USE_SYSTEM_VULKAN_HEADERS" })
end
if use_system_vulkan_memory_allocator then
  defines({ "XENIA_USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR" })
end
if use_system_discord_rpc then
  defines({ "XENIA_USE_SYSTEM_DISCORD_RPC" })
end
if use_system_imgui then
  defines({ "XENIA_USE_SYSTEM_IMGUI" })
end

cdialect("C17")
cppdialect("C++20")
symbols("On")

-- TODO(DrChat): Find a way to disable this on other architectures.
if ARCH ~= "ppc64" then
  filter("architecture:x86_64")
    vectorextensions("AVX")
  filter({})
end

filter("kind:StaticLib")
  defines({
    "_LIB",
  })

filter("configurations:Checked")
  runtime("Debug")
  sanitize("Address")
  flags("NoIncrementalLink")
  editandcontinue("Off")
  staticruntime("Off")
  optimize("Off")
  removedefines({
    "IMGUI_USE_STB_SPRINTF",
  })
  defines({
    "DEBUG",
  })

filter({"configurations:Checked", "platforms:Windows"}) -- "toolset:msc"
  buildoptions({
    "/RTCsu",           -- Full Run-Time Checks.
  })

filter({"configurations:Checked or Debug", "platforms:Linux"})
  defines({
    "_GLIBCXX_DEBUG",   -- libstdc++ debug mode
  })

filter({"configurations:Checked or Debug", "platforms:Windows"}) -- "toolset:msc"
  symbols("Full")

filter("configurations:Debug")
  runtime("Release")
  optimize("Off")
  defines({
    "DEBUG",
    "_NO_DEBUG_HEAP=1",
  })

filter("configurations:Release")
  runtime("Release")
  defines({
    "NDEBUG",
    "_NO_DEBUG_HEAP=1",
  })
  flags({
    "NoBufferSecurityCheck"
  })
  inlining("Auto")
  editandcontinue("Off")
  -- Not using floatingpoint("Fast") - NaN checks are used in some places
  -- (though rarely), overall preferable to avoid any functional differences
  -- between debug and release builds, and to have calculations involved in GPU
  -- (especially anything that may affect vertex position invariance) and CPU
  -- (such as constant propagation) emulation as predictable as possible,
  -- including handling of specials since games make assumptions about them.

filter({"configurations:Release", "platforms:not Windows"})
  symbols("Off")

filter({"configurations:Release", "platforms:Windows"}) -- "toolset:msc"
  linktimeoptimization("On")
  buildoptions({
    "/Gw",
    "/Ob3",
--    "/Qpar",   -- TODO: Test this.
  })

filter("configurations:RelWithDebInfo")
  runtime("Release")
  defines({
    "NDEBUG",
    "_NO_DEBUG_HEAP=1",
  })
  flags({
    "NoBufferSecurityCheck"
  })
  inlining("Auto")
  editandcontinue("Off")
filter({"configurations:RelWithDebInfo", "platforms:not Windows"})
  symbols("On")
filter({"configurations:RelWithDebInfo", "platforms:Windows"}) -- "toolset:msc"
  linktimeoptimization("On")
  buildoptions({
    "/Gw",
    "/Ob3",
  })

filter("platforms:Linux")
  system("linux")
  toolset("clang")
  -- Unused-result: warn only, do not promote to error (e.g. readlink, ftruncate, fread).
  buildoptions({ "-Wno-error=unused-result" })
  --buildoptions({
  --    "-mlzcnt",   -- (don't) Assume lzcnt is supported.
  --})
  pkg_config.all("gtk+-x11-3.0")
  links({
    "stdc++fs",
    "dl",
    "fontconfig",
    "lz4",
    "pthread",
    "rt",
  })

filter({"platforms:Linux", "kind:*App"})
  linkgroups("On")

filter({"language:C++", "toolset:clang or gcc"}) -- "platforms:Linux"
  disablewarnings({
    "switch",
    "attributes",
  })

filter({"language:C++", "toolset:gcc"}) -- "platforms:Linux"
  disablewarnings({
    "unused-result",
    "volatile",
    "template-id-cdtor",
    "return-type",
    "deprecated",
  })

filter("toolset:gcc") -- "platforms:Linux"
  removefatalwarnings("All") -- HACK
  if ARCH == "ppc64" then
    buildoptions({
      "-m32",
      "-mpowerpc64"
    })
    linkoptions({
      "-m32",
      "-mpowerpc64"
    })
  else
    buildoptions({
      "-fpermissive", -- HACK
    })
    linkoptions({
      "-fpermissive", -- HACK
    })
  end

filter({"language:C++", "toolset:clang"}) -- "platforms:Linux"
  disablewarnings({
    "deprecated-register",
    "deprecated-volatile",
    "deprecated-enum-enum-conversion",
  })
CLANG_BIN = os.getenv("CC") or _OPTIONS["cc"] or "clang"
if os.istarget("linux") and string.contains(CLANG_BIN, "clang") then
  CLANG_VER = tonumber(string.match(os.outputof(CLANG_BIN.." --version"), "version (%d%d)"))
  if CLANG_VER >= 20 then
    filter({"language:C++", "toolset:clang"}) -- "platforms:Linux"
      disablewarnings({
        "deprecated-literal-operator",   -- Needed only for tabulate
        "nontrivial-memcall",
      })
  end
  if CLANG_VER >= 21 then
    filter({"language:C++", "toolset:clang"}) -- "platforms:Linux"
      disablewarnings({
        "character-conversion",          -- Needed for utfcpp third-party library
      })
  end
end

filter({"language:C", "toolset:clang or gcc"}) -- "platforms:Linux"
  disablewarnings({
    "implicit-function-declaration",
  })

if os.istarget("android") then
  filter("platforms:Android-*")
    system("android")
    systemversion("24")
    cppstl("c++")
    staticruntime("On")
    -- Hidden visibility is needed to prevent dynamic relocations in FFmpeg
    -- AArch64 Neon libavcodec assembly with PIC (accesses extern lookup tables
    -- using `adrp` and `add`, without the Global Object Table, expecting that all
    -- FFmpeg symbols that aren't a part of the FFmpeg API are hidden by FFmpeg's
    -- original build system) by resolving those relocations at link time instead.
    visibility("Hidden")
    links({
      "android",
      "dl",
      "log",
    })
end

filter("platforms:Windows")
  system("windows")
  toolset("msc")
  buildoptions({
    "/utf-8",   -- 'build correctly on systems with non-Latin codepages'.
    -- Disable warnings
    "/wd4201",   -- Nameless struct/unions are ok.
  })
  flags({
    "MultiProcessorCompile",   -- Multiprocessor compilation.
    "NoMinimalRebuild",        -- Required for /MP above.
  })

  defines({
    "_CRT_NONSTDC_NO_DEPRECATE",
    "_CRT_SECURE_NO_WARNINGS",
    "WIN32",
    "_WIN64=1",
    "_AMD64=1",
    "IMGUI_DISABLE_OBSOLETE_FUNCTIONS",
  })
  linkoptions({
    "/ignore:4006",  -- Ignores complaints about empty obj files.
    "/ignore:4221",
  })
  links({
    "ntdll",
    "wsock32",
    "ws2_32",
    "xinput",
    "comctl32",
    "shcore",
    "shlwapi",
    "dxguid",
    "bcrypt",
  })

-- Embed the manifest for things like dependencies and DPI awareness.
filter({"platforms:Windows", "kind:ConsoleApp or WindowedApp"})
  files({
    "src/xenia/base/app_win32.manifest"
  })

-- Create scratch/ path
if not os.isdir("scratch") then
  os.mkdir("scratch")
end

workspace("xenia")
  uuid("931ef4b0-6170-4f7a-aaf2-0fece7632747")
  startproject("xenia-app")
  if os.istarget("android") then
    platforms({"Android-ARM64", "Android-x86_64"})
    filter("platforms:Android-ARM64")
      architecture("ARM64")
    filter("platforms:Android-x86_64")
      architecture("x86_64")
    filter({})
  else
    architecture("x86_64")
    if os.istarget("linux") then
      platforms({"Linux"})
    elseif os.istarget("macosx") then
      platforms({"Mac"})
      xcodebuildsettings({
        ["ARCHS"] = "x86_64"
      })
    elseif os.istarget("windows") then
      platforms({"Windows"})
      -- 10.0.15063.0: ID3D12GraphicsCommandList1::SetSamplePositions.
      -- 10.0.19041.0: D3D12_HEAP_FLAG_CREATE_NOT_ZEROED.
      -- 10.0.22000.0: DWMWA_WINDOW_CORNER_PREFERENCE.
      systemversion("latest")
      filter({})
    end
  end
  configurations({"Checked", "Debug", "Release", "RelWithDebInfo"})

  include("third_party/aes_128.lua")
  if not use_system_capstone then
    include("third_party/capstone.lua")
  end
  include("third_party/dxbc.lua")
  if not use_system_discord_rpc then
    include("third_party/discord-rpc.lua")
  end
  if not use_system_cxxopts then
    include("third_party/cxxopts.lua")
  end
  if not use_system_tomlplusplus then
    include("third_party/tomlplusplus.lua")
  end
  include("third_party/FFmpeg/premake5.lua")
  if not use_system_fmt then
    include("third_party/fmt.lua")
  end
  if not use_system_glslang then
    include("third_party/glslang-spirv.lua")
  end
  if not use_system_imgui then
    include("third_party/imgui.lua")
  end
  include("third_party/mspack.lua")
  if not use_system_snappy then
    include("third_party/snappy.lua")
  end
  if not use_system_xxhash then
    include("third_party/xxhash.lua")
  end
  if not use_system_zarchive then
    include("third_party/zarchive.lua")
  end
  if not use_system_zstd then
    include("third_party/zstd.lua")
  end
  if not use_system_zlib_ng then
    include("third_party/zlib-ng.lua")
  end
  if not use_system_pugixml then
    include("third_party/pugixml.lua")
  end

  if os.istarget("windows") then
    include("third_party/libusb.lua")
  end

  if not os.istarget("android") then
    -- SDL2 requires sdl2-config, and as of November 2020 isn't high-quality on
    -- Android yet, most importantly in game controllers - the keycode and axis
    -- enums are being ruined during conversion to SDL2 enums resulting in only
    -- one controller (Nvidia Shield) being supported, digital triggers are also
    -- not supported; lifecycle management (especially surface loss) is also
    -- complicated.
    include("third_party/SDL2.lua")
  end

  -- Disable treating warnings as fatal errors for all third party projects, as
  -- well as other things relevant only to Xenia itself.
  for _, prj in ipairs(premake.api.scope.current.solution.projects) do
    project(prj.name)
    removefiles({
      "src/xenia/base/app_win32.manifest"
    })
    removefatalwarnings("All")
  end

  include("src/xenia")
  include("src/xenia/app")
  include("src/xenia/app/discord")
  include("src/xenia/apu")
  include("src/xenia/apu/nop")
  include("src/xenia/base")
  include("src/xenia/cpu")
  include("src/xenia/cpu/backend/x64")
  include("src/xenia/debug/ui")
  include("src/xenia/gpu")
  include("src/xenia/gpu/null")
  include("src/xenia/gpu/vulkan")
  include("src/xenia/hid")
  include("src/xenia/hid/nop")
  include("src/xenia/hid/skylander")
  include("src/xenia/kernel")
  include("src/xenia/patcher")
  include("src/xenia/ui")
  include("src/xenia/ui/vulkan")
  include("src/xenia/vfs")

  if not os.istarget("android") then
    include("src/xenia/apu/sdl")
    include("src/xenia/helper/sdl")
    include("src/xenia/hid/sdl")
  end

  if os.istarget("windows") then
    include("src/xenia/apu/xaudio2")
    include("src/xenia/gpu/d3d12")
    include("src/xenia/hid/winkey")
    include("src/xenia/hid/xinput")
    include("src/xenia/ui/d3d12")
  end

  -- Generate build/version.h so sources that include it can find it (trace_writer, etc.).
  if not os.istarget("android") then
    os.execute("python3 xenia-build.py version-h 2>/dev/null")
  end
