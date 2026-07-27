return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    numhl = true,
    word_diff = true,

    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = false,
    },

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]c", function() gs.nav_hunk("next") end, "Next hunk")
      map("n", "[c", function() gs.nav_hunk("prev") end, "Previous hunk")

      -- Preview
      map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk (float)")

      -- Stage / reset (hunk)
      map("n", "<leader>hs", gs.stage_hunk, "Stage hunk (toggle)")
      map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected hunk")

      -- Stage / reset (buffer)
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

      -- Blame / diff
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
      map("n", "<leader>hd", gs.diffthis, "Diff against index")
      map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")

      -- Text object
      map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")

      -- Toggles
      map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
      map("n", "<leader>tw", gs.toggle_word_diff, "Toggle word diff")
      map("n", "<leader>tn", gs.toggle_numhl, "Toggle number highlight")
    end,
  },
}
