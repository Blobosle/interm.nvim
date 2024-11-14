-- term.lua

local M = {}

M.cd_and_open_term = function()
    local original_dir = vim.fn.getcwd()
    vim.cmd('cd %:p:h')
    vim.cmd('term')

    vim.cmd('autocmd TermClose * ++once lua vim.cmd("cd ' .. original_dir .. '")')
end

M.cd_and_open_term_mod = function()
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

M.disable_line_numbers = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
end

M.enable_line_numbers = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
end

M.setup_term_number_toggle = function()
    vim.api.nvim_exec([[
      augroup TermNumberToggle
        autocmd!
        autocmd TermOpen * lua require("interm").disable_line_numbers()
        autocmd TermClose * lua require("interm").enable_line_numbers()
      augroup END
    ]], false)
end

M.setup_term_highlight = function()
    vim.cmd('hi TermNormal guibg=#1e1e1e guifg=white ctermbg=0 ctermfg=white')
    vim.api.nvim_exec([[
      augroup TermColorschemeToggle
        autocmd!
        autocmd TermOpen * setlocal winhighlight=Normal:TermNormal
      augroup END
    ]], false)
end

M.setup_term_statusline = function()
    vim.cmd('hi TermStatusLine guibg=#1e1e1e guifg=white ctermbg=0 ctermfg=white')
end

M.disable_line_numbers = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
end

M.enable_line_numbers = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
end

M.set_term_statusline_highlight = function()
    vim.wo.statusline = '%#TermStatusLine#' .. vim.o.statusline
end

M.setup_term_statusline_highlight = function()
    vim.api.nvim_exec([[
    augroup TermStatusLineHighlight
    autocmd!
    autocmd TermOpen * lua require("interm").set_term_statusline_highlight()
    augroup END
    ]], false)
end

M.setup_term_close_autocmd = function()
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
end

M.setup_term_enter_autocmd = function()
    vim.api.nvim_create_autocmd("TermEnter", {
        pattern = "*",
        callback = function()
            vim.opt.timeoutlen = 200
        end,
    })
end

M.setup_term_leave_autocmd = function()
    vim.api.nvim_create_autocmd("TermLeave", {
        pattern = "*",
        callback = function()
            vim.opt.timeoutlen = 1000
        end,
    })
end

return M
