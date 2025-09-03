return {
  flags = {
    debounce_text_changes = 500,
  },
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
  init_options = {
    fallback_flags = { "-std=c++17" },
  },
}
