require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

require("tokyonight").setup({
    transparent = true,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    },
})
vim.cmd([[colorscheme tokyonight-night]])
