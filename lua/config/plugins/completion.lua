return {
  "saghen/blink.cmp",
  version = "*",
  opts = {
    keymap = {
      ["<Tab>"] = {
        function(cmp)
          local col = vim.fn.col(".") - 1
          local has_text = col > 0 and vim.fn.getline("."):sub(col, col):match("%S")
          if cmp.is_visible() then return cmp.accept() end
          if has_text then return cmp.show() end
        end,
        "fallback",
      },
      ["<Up>"]   = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-e>"]  = { "hide", "fallback" },
    },
    completion = {
      documentation = { auto_show = false },
      menu = { auto_show = false },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
