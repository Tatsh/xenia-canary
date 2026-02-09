-- Helper methods to use the system pkg-config utility

pkg_config = {}

local function pkg_config_call(lib, what)
  local result, code = os.outputof("pkg-config --"..what.." "..lib)
  if result then
    return result
  else
    error("Failed to run 'pkg-config' for library '"..lib.."'. Are the development files installed?")
  end
end

function pkg_config.cflags(lib)
  if not os.istarget("linux") then
    return
  end
  buildoptions({
    pkg_config_call(lib, "cflags"),
  })
end

function pkg_config.lflags(lib)
  if not os.istarget("linux") then
    return
  end
  linkoptions({
    pkg_config_call(lib, "libs-only-L"),
    pkg_config_call(lib, "libs-only-other"),
  })
  -- We can't just drop the stdout of the `--libs` command in
  -- linkoptions because library order matters
  local output = pkg_config_call(lib, "libs-only-l")
  for k, flag in next, string.explode(output, " ") do
    -- remove "-l"
    if flag ~= "" then
        links(string.sub(flag, 3))
    end
  end
end

function pkg_config.all(lib)
  -- When glslang has no pkg-config (e.g. Gentoo), use fallback include/links.
  if lib == "glslang" and use_system_glslang and glslang_system_include and glslang_system_links then
    includedirs(glslang_system_include)
    links(glslang_system_links)
    return
  end
  -- When snappy has no pkg-config (e.g. Gentoo), use fallback include/links.
  if lib == "snappy" and use_system_snappy and snappy_system_include and snappy_system_links then
    includedirs(snappy_system_include)
    links(snappy_system_links)
    return
  end
  -- When pugixml has no pkg-config (e.g. Gentoo), use fallback include/links.
  if lib == "pugixml" and use_system_pugixml and pugixml_system_include and pugixml_system_links then
    includedirs(pugixml_system_include)
    links(pugixml_system_links)
    return
  end
  -- When zlib-ng has no pkg-config (e.g. Gentoo), use fallback include/links.
  if lib == "zlib-ng" and use_system_zlib_ng and zlib_ng_system_include and zlib_ng_system_links then
    includedirs(zlib_ng_system_include)
    links(zlib_ng_system_links)
    defines({ "WITH_GZFILEOP" })
    return
  end
  -- When discord-rpc has no pkg-config (e.g. Gentoo), use fallback include/links.
  if lib == "discord-rpc" and use_system_discord_rpc and discord_rpc_system_include and discord_rpc_system_links then
    includedirs(discord_rpc_system_include)
    links(discord_rpc_system_links)
    return
  end
  pkg_config.cflags(lib)
  pkg_config.lflags(lib)
end
