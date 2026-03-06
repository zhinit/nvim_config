return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  config = function()
    require("nightfox").setup({ options = { transparent = true } })
    vim.cmd.colorscheme("carbonfox")
    vim.api.nvim_set_hl(0, "Comment", { fg = "#7a8a9e", italic = true })
  end
}
