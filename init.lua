vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

require("config.lazy")

-- Show the current line's diagnostic message in the statusline
local function diagnostic_stl()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags == 0 then return "" end
  table.sort(diags, function(a, b) return a.severity < b.severity end)
  local icons = { "E", "W", "I", "H" }
  local d = diags[1]
  return icons[d.severity] .. ": " .. d.message
end

vim.opt.statusline = "%f %m%=%{v:lua._G.diagnostic_stl()} %l:%c "
_G.diagnostic_stl = diagnostic_stl

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.statuscolumn = "%{v:lnum} %{v:relnum} "

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.statuscolumn = ""
  end,
})

local api = vim.api

-- set default spacing to 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- set spacing to 4 for Python
api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
})

