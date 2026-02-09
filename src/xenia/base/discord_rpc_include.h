// Wrapper so Xenia can use either bundled discord-rpc or system (XENIA_USE_SYSTEM_DISCORD_RPC).
#ifndef XENIA_BASE_DISCORD_RPC_INCLUDE_H_
#define XENIA_BASE_DISCORD_RPC_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_DISCORD_RPC
#include <discord_rpc.h>
#else
#include "third_party/discord-rpc/include/discord_rpc.h"
#endif

#endif  // XENIA_BASE_DISCORD_RPC_INCLUDE_H_
