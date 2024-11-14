-- init.lua

require("interm.term")

vim.api.nvim_set_keymap('n', 'Q', ':lua require("interm.term").cd_and_open_term()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-q>', [[<C-\><C-n>i exit<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':lua require("interm.term").cd_and_open_term_mod()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-CR>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<S-CR>', '<C-\\><C-n><C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-N>', { noremap = true, silent = true })
