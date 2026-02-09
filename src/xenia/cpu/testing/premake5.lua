project_root = "../../../.."
include(project_root.."/tools/build")

local cpu_test_links = {
  "capstone",
  "fmt",
  "xenia-base",
    "xenia-core",
    "xenia-cpu",
    "xenia-gpu",
    "xenia-hid-skylander",

    -- TODO(benvanik): cut these dependencies?
    "xenia-kernel",
  "xenia-ui", -- needed by xenia-base
  "xenia-patcher",
}
if not use_system_imgui then
  table.insert(cpu_test_links, "imgui")
end
test_suite("xenia-cpu-tests", project_root, ".", {
  links = cpu_test_links,
  uses_imgui = true,
  filtered_links = {
    {
      filter = 'architecture:x86_64',
      links = {
        "xenia-cpu-backend-x64",
      },
    }
  },
})
