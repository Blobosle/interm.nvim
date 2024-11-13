-- init.lua

-- Load term.lua
require("mytermplugin.term")

-- Key mappings
vim.api.nvim_set_keymap('n', 'Q', ':lua require("mytermplugin.term").cd_and_open_term()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':lua require("mytermplugin.term").cd_and_open_term_mod()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-q>', [[<C-\><C-n>i exit<CR>]], { noremap = true, silent = true })

