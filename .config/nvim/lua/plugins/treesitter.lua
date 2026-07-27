local ensure_installed = {
  "lua",
  "vim",
  "vimdoc",
  "python",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "html",
  "css",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})

    -- Install parsers (runs async, only missing ones)
    require("nvim-treesitter").install(ensure_installed)

    -- Enable highlighting and indentation for installed filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        pcall(function()
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
      end,
    })
  end,
}
