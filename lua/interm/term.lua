-- term.lua

-- Opens a shell instance in the edited directory (whole screen)
_G.cd_and_open_term = function()
    local original_dir = vim.fn.getcwd()
    vim.cmd('cd %:p:h')
    vim.cmd('term')
    vim.cmd('autocmd TermClose * ++once lua vim.cmd("cd ' .. original_dir .. '")')
end

-- Opens a shell instance in the edited directory (split screen)
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

-- Disable line numbers in terminal mode
function DisableLineNumbers()
    vim.wo.number = false
    vim.wo.relativenumber = false
end

-- Enable line numbers in normal mode
function EnableLineNumbers()
    vim.wo.number = true
    vim.wo.relativenumber = true
end

-- Autocommand to toggle line numbers in terminal mode
vim.api.nvim_exec([[
    augroup TermNumberToggle
        autocmd!
        autocmd TermOpen * lua DisableLineNumbers()
        autocmd TermClose * lua EnableLineNumbers()
    augroup END
]], false)

-- Custom highlight group for terminal windows
vim.cmd('hi TermNormal guibg=#1e1e1e guifg=white ctermbg=0 ctermfg=white')

-- Set winhighlight for terminal windows
vim.api.nvim_exec([[
    augroup TermColorschemeToggle
        autocmd!
        autocmd TermOpen * setlocal winhighlight=Normal:TermNormal
    augroup END
]], false)

-- Hide status line in terminal
vim.cmd('hi TermStatusLine guibg=#1e1e1e guifg=white ctermbg=0 ctermfg=white')
function _G.SetTermStatusLineHighlight()
    vim.wo.statusline = '%#TermStatusLine#' .. vim.o.statusline
end
vim.api.nvim_exec([[
    augroup TermStatusLineHighlight
        autocmd!
        autocmd TermOpen * lua _G.SetTermStatusLineHighlight()
    augroup END
]], false)

-- Automatically close terminal buffer without confirmation
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

-- Adjust timeoutlen when entering/leaving terminal mode
vim.api.nvim_create_autocmd("TermEnter", {
    pattern = "*",
    callback = function()
        vim.opt.timeoutlen = 200
    end,
})
vim.api.nvim_create_autocmd("TermLeave", {
    pattern = "*",
    callback = function()
        vim.opt.timeoutlen = 1000
    end,
})
