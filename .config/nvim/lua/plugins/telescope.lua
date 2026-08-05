return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- Fall back to a vertical preview when the window is too narrow
        layout_strategy = "flex",
        layout_config = {
          width = 0.9,
          height = 0.9,
          -- Use the vertical layout below this picker width
          flip_columns = 140,
          horizontal = {
            preview_width = 0.55,
            preview_cutoff = 1, -- effectively never hide the preview
          },
          vertical = {
            preview_height = 0.5,
            preview_cutoff = 1, -- effectively never hide the preview
          },
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    })
    telescope.load_extension("fzf")

    -- telescope 0.1.x expects the nvim-treesitter master API (parsers.ft_to_lang,
    -- configs.is_enabled), which the main branch we pin no longer provides, so the
    -- preview highlighter throws. Drive the built-in treesitter API instead and
    -- return false when there is no parser so telescope falls back to :syntax.
    local putils = require("telescope.previewers.utils")
    putils.ts_highlighter = function(bufnr, ft)
      local lang = vim.treesitter.language.get_lang(ft)
      if not lang then
        return false
      end
      return pcall(vim.treesitter.start, bufnr, lang)
    end
  end,
}
