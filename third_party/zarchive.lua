group("third_party")
project("zarchive")
  uuid("d32f03aa-f0c9-11ed-a05b-0242ac120003")
  kind("StaticLib")
  language("C++")
  if use_system_zstd then
    pkg_config.all("libzstd")
  end
  links(use_system_zstd and {} or {"zstd"})
  includedirs({
    "zarchive/include",
  })
  if not use_system_zstd then
    includedirs({
      "zstd/lib",
    })
  end
  files({
    "zarchive/include/zarchive/zarchivecommon.h",
    "zarchive/include/zarchive/zarchivereader.h",
    "zarchive/include/zarchive/zarchivewriter.h",
    "zarchive/src/zarchivereader.cpp",
    "zarchive/src/zarchivewriter.cpp",
    "zarchive/src/sha_256.c",
    "zarchive/src/sha_256.h",
  })
