return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require("conform").setup({
      formatters = {
        clang_format = {
          prepend_args = { "--style=Mozilla" },
        },
      },
      formatters_by_ft = {
        cpp             = { "clang_format" },
        cmake           = { "cmake_format" },
        python          = { "black" },
        javascript      = { "prettier" },
        typescript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html            = { "prettier" },
        css             = { "prettier" },
        json            = { "prettier" },
      },
      format_on_save = function(bufnr)
        -- disable format-on-save for C files
        if vim.bo[bufnr].filetype == "c" then return nil end
        return { timeout_ms = 2000, lsp_fallback = false }
      end,
    })
  end,
}
