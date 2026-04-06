-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- [[ Load Core Config ]]
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.lazy")
