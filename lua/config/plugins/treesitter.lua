return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup({
      install_dir = vim.fn.stdpath('data') .. '/site',
      ensure_installed = {
        'c', 'cpp', 'cmake', 'javascript', 'typescript', 'tsx',
        'html', 'css', 'python', 'lua', 'json', 'bash',
      },
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'cpp', 'cmake',
        'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
        'html', 'css', 'python', 'lua', 'json', 'bash',
      },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end
}
