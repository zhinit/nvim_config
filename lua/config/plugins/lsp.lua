-- Diagnostics: underlines + gutter signs only, no inline virtual text
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Auto-detect uv .venv for pyright by walking up from the buffer's file
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "pyright" then return end

    local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":h")
    while dir ~= "/" do
      local venv_python = dir .. "/.venv/bin/python"
      if vim.fn.executable(venv_python) == 1 then
        client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
          python = { pythonPath = venv_python },
        })
        client:notify("workspace/didChangeConfiguration", { settings = nil })
        break
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
  end,
})

-- Mouse hover: show LSP type info when mouse rests over a symbol
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true

local hover_timer = nil

vim.keymap.set("n", "<MouseMove>", function()
  if hover_timer then
    hover_timer:stop()
    hover_timer:close()
    hover_timer = nil
  end

  hover_timer = vim.defer_fn(function()
    hover_timer = nil

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then return end
    end

    local mousepos = vim.fn.getmousepos()
    local win = mousepos.winid
    if win == 0 then return end
    if vim.api.nvim_win_get_config(win).relative ~= "" then return end

    local buf = vim.api.nvim_win_get_buf(win)
    if #vim.lsp.get_clients({ bufnr = buf }) == 0 then return end

    pcall(vim.api.nvim_win_set_cursor, win, { mousepos.line, mousepos.column - 1 })
    vim.lsp.buf.hover()
  end, 700)
end)

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = { "prettier", "clang-format", "black" },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig    = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "cmake",
          "ts_ls",
          "pyright",
          "html",
          "cssls",
          "lua_ls",
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({ capabilities = capabilities })
          end,
          ["pyright"] = function()
            lspconfig.pyright.setup({ capabilities = capabilities })
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = { diagnostics = { globals = { "vim" } } },
              },
            })
          end,
        },
      })
    end,
  },
}
