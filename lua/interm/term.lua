-- term.lua

local M = {}

function M.cd_and_open_term()
    local original_dir = vim.fn.getcwd()
    vim.cmd('cd %:p:h')
    vim.cmd('term')
    vim.cmd('autocmd TermClose * ++once lua vim.cmd("cd ' .. original_dir .. '")')
end

local term_win_id

function M.cd_and_open_term_mod()
    local original_win = vim.api.nvim_get_current_win()
    local original_dir = vim.fn.getcwd()

    vim.cmd('lcd %:p:h')
    vim.cmd('vsplit')
    vim.cmd('term')

    local new_win = vim.api.nvim_get_current_win()
    term_win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(original_win)
    vim.cmd('lcd ' .. original_dir)
    vim.api.nvim_set_current_win(new_win)

    vim.cmd('autocmd TermClose * ++once lua vim.api.nvim_set_current_win(' .. new_win .. ')')
end

function M.DisableLineNumbers()
    vim.wo.number = false
    vim.wo.relativenumber = false
end

function M.EnableLineNumbers()
    vim.wo.number = true
    vim.wo.relativenumber = true
end

function M.SetTermStatusLineHighlight()
    vim.wo.statusline = '%#TermStatusLine#' .. vim.o.statusline
end

-- Autocommands
vim.api.nvim_exec([[
  augroup TermNumberToggle
    autocmd!
    autocmd TermOpen * lua require("interm.term").DisableLineNumbers()
    autocmd TermClose * lua require("interm.term").EnableLineNumbers()
  augroup END
]], false)

vim.api.nvim_exec([[
  augroup TermColorschemeToggle
    autocmd!
    autocmd TermOpen * setlocal winhighlight=Normal:TermNormal
  augroup END
]], false)

vim.api.nvim_exec([[
  augroup TermStatusLineHighlight
    autocmd!
    autocmd TermOpen * lua require("interm.term").SetTermStatusLineHighlight()
  augroup END
]], false)
--
-- vim.api.nvim_create_autocmd("TermClose", {
--     pattern = "*",
--     callback = function(args)
--         vim.schedule(function()
--             if vim.api.nvim_buf_is_valid(args.buf) then
--                 local success, err = pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
--                 if not success then
--                     vim.notify("Error deleting buffer: " .. err, vim.log.levels.ERROR)
--                 end
--             end
--         end)
--     end,
-- })

vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*",
    callback = function()
        vim.schedule(function()
            if term_win_id and vim.api.nvim_win_is_valid(term_win_id) then
                vim.api.nvim_set_current_win(term_win_id)
            else
                vim.notify("Term window already closed.", vim.log.levels.WARN)
            end
        end)
    end,
})

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

return M

