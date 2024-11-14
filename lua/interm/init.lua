-- interm/init.lua

local M = {}

M.setup = function()
    -- Attempt to load term.lua and log the result
    local term_ok, term = pcall(require, "interm.term")
    if not term_ok then
        print("Failed to load interm.term:", term)
        return
    else
        print("Loaded interm.term successfully")
    end

    -- Key mappings
    vim.api.nvim_set_keymap('n', 'Q', ':lua require("interm.term").cd_and_open_term()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>q', ':lua require("interm.term").cd_and_open_term_mod()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<C-q>', [[<C-\><C-n>i exit<CR>]], { noremap = true, silent = true })
end

return M
