project_root = "../../../.."
include(project_root.."/tools/build")

group("src")
project("xenia-app-discord")
  uuid("d14c0885-22d2-40de-ab28-7b234ef2b949")
  kind("StaticLib")
  language("C++")
  if use_system_discord_rpc then
    pkg_config.all("discord-rpc")
  else
    links({ "discord-rpc" })
    includedirs({
      project_root.."/third_party/discord-rpc/src"
    })
  end
  files({
    "discord_presence.cc",
    "discord_presence.h"
  })
