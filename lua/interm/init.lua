-- Opening shell instance on the edited directory (whole screen)
_G.cd_and_open_term = function()
    local original_dir = vim.fn.getcwd()
    vim.cmd('cd %:p:h')
    vim.cmd('term')

    vim.cmd('autocmd TermClose * ++once lua vim.cmd("cd ' .. original_dir .. '")')
end

-- Opening shell instance on the edited directory (split screen)
_G.cd_and_open_term_mod = function()
    local original_win = vim.api.nvim_get_current_win()
    local original_dir = vim.fn.getcwd()

    vim.cmd('lcd %:p:h')
    vim.cmd('vsplit')
    vim.cmd('term')

    local new_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(original_win)
    vim.cmd('lcd ' .. original_dir)
    vim.api.nvim_set_current_win(new_win)

    vim.cmd('autocmd TermClose * ++once lua vim.api.nvim_set_current_win(' .. new_win .. ')')
end

-- Calls the function to open a new shell instance in a whole window
vim.api.nvim_set_keymap('n', 'Q', ':lua cd_and_open_term()<CR>', { noremap = true, silent = true })

-- Calls the function to open a new shell instance in a split window
vim.api.nvim_set_keymap('n', '<leader>q', ':lua _G.cd_and_open_term_mod()<CR>', { noremap = true, silent = true })

-- Autocompletion key to exit the terminal automatically
vim.api.nvim_set_keymap('t', '<C-q>', [[<C-\><C-n>i exit<CR>]], { noremap = true, silent = true })





--- TERM.LUA

-- Disables line numbers in terminal mode
function DisableLineNumbers()
  vim.wo.number = false
  vim.wo.relativenumber = false
end

-- Enables line numbers in normal mode
function EnableLineNumbers()
  vim.wo.number = true
  vim.wo.relativenumber = true
end

-- Toggles line numbers in terminal mode
vim.api.nvim_exec([[
  augroup TermNumberToggle
    autocmd!
    autocmd TermOpen * lua DisableLineNumbers()
    autocmd TermClose * lua EnableLineNumbers()
  augroup END
]], false)

-- Custom highlight group for terminal windows
vim.cmd('hi TermNormal guibg=#1e1e1e guifg=white ctermbg=0 ctermfg=white')

-- Autocommand to set winhighlight in terminal windows
vim.api.nvim_exec([[
  augroup TermColorschemeToggle
    autocmd!
    autocmd TermOpen * setlocal winhighlight=Normal:TermNormal
  augroup END
]], false)

-- Command to get rid of the neovim status line
vim.cmd('hi TermStatusLine guibg=#1e1e1e guifg=white ctermbg=0 ctermfg=white')

-- Implements the modified status line
function _G.SetTermStatusLineHighlight()
    vim.wo.statusline = '%#TermStatusLine#' .. vim.o.statusline
end

-- Executes status line code to remove it
vim.api.nvim_exec([[
    augroup TermStatusLineHighlight
        autocmd!
        autocmd TermOpen * lua _G.SetTermStatusLineHighlight()
    augroup END
]], false)

-- Skips unnecesary terminal instance closing sequence
vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*",
    callback = function(args)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                local success, err = pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
                if not success then
                    vim.notify("Error deleting buffer: " .. err, vim.log.levels.ERROR)
                end
            end
        end)
    end,
})

-- Lower timeoutlen when entering terminal mode
vim.api.nvim_create_autocmd("TermEnter", {
    pattern = "*",
    callback = function()
        vim.opt.timeoutlen = 200
    end,
})

-- Restore timeoutlen when leaving terminal mode
vim.api.nvim_create_autocmd("TermLeave", {
    pattern = "*",
    callback = function()
        vim.opt.timeoutlen = 1000
    end,
})
