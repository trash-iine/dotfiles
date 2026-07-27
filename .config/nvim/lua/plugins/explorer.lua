return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
    { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal current file in explorer" },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    popup_border_style = "rounded",
    default_component_configs = {
      indent = {
        with_markers = true,
        with_expanders = true,
      },
      git_status = {
        symbols = {
          added     = "+",
          modified  = "~",
          deleted   = "✖",
          renamed   = "➜",
          untracked = "?",
          ignored   = "◌",
          unstaged  = "U",
          staged    = "S",
          conflict  = "!",
        },
      },
    },
    window = {
      width = 35,
      mappings = {
        ["<space>"] = "none",
        ["o"] = "open",
        ["h"] = "close_node",
        ["l"] = "open",
        ["H"] = "toggle_hidden",
        ["P"] = { "toggle_preview", config = { use_float = true } },
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      group_empty_dirs = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
    },
    buffers = {
      follow_current_file = { enabled = true },
      group_empty_dirs = true,
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
  },
}
