// Wrapper so Xenia can use either bundled glslang SPIRV subset or system glslang (XENIA_USE_SYSTEM_GLSLANG).
#ifndef XENIA_BASE_GLSLANG_INCLUDE_H_
#define XENIA_BASE_GLSLANG_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_GLSLANG
#include <glslang/SPIRV/GLSL.std.450.h>
#include <glslang/SPIRV/SpvBuilder.h>
#include <glslang/SPIRV/disassemble.h>
#else
#include "third_party/glslang/SPIRV/GLSL.std.450.h"
#include "third_party/glslang/SPIRV/SpvBuilder.h"
#include "third_party/glslang/SPIRV/disassemble.h"
#endif

#endif  // XENIA_BASE_GLSLANG_INCLUDE_H_
