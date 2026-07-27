return {
  { "numToStr/Comment.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = { "BufReadPre", "BufNewFile" }, opts = {} },
}
