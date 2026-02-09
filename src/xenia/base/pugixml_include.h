// Wrapper so Xenia can use either bundled pugixml or system libpugixml (XENIA_USE_SYSTEM_PUGIXML).
#ifndef XENIA_BASE_PUGIXML_INCLUDE_H_
#define XENIA_BASE_PUGIXML_INCLUDE_H_

#ifdef XENIA_USE_SYSTEM_PUGIXML
#include <pugixml.hpp>
#else
#include "third_party/pugixml/src/pugixml.hpp"
#endif

#endif  // XENIA_BASE_PUGIXML_INCLUDE_H_
