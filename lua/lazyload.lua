-- Lazy-loading helper: queues plugin setup behind VimEnter.
-- Inspired by https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/
--
-- Usage:
--   require("lazyload").on_vim_enter(fn)            -- async (default)
--   require("lazyload").on_vim_enter(fn, { sync = true })  -- runs inline before async callbacks
--   require("lazyload").on_override(fn)             -- runs after all vim_enter callbacks (for exrc)

local M = {}

local vim_enter_queue = {}
local override_queue = {}

local function drain(queue)
  -- First pass: schedule async callbacks (FIFO)
  for _, entry in ipairs(queue) do
    if not entry.sync then
      vim.schedule(entry.fn)
    end
  end
  -- Second pass: run synchronous callbacks inline
  for _, entry in ipairs(queue) do
    if entry.sync then
      entry.fn()
    end
  end
end

local function drain_override()
  if not override_queue then return end
  for _, entry in ipairs(override_queue) do
    vim.schedule(function()
      local ok, err = pcall(entry.fn)
      if not ok then
        vim.notify(('.nvim.lua override error:\n%s'):format(err), vim.log.levels.ERROR)
      end
    end)
  end
  override_queue = nil
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    drain(vim_enter_queue)
    vim_enter_queue = nil
    drain_override()
  end,
})

--- Queue a function to run at VimEnter (after all plugin/ files have been sourced).
--- If VimEnter has already fired, executes immediately (sync) or via vim.schedule (async).
---@param fn function
---@param opts? { sync: boolean }
function M.on_vim_enter(fn, opts)
  local sync = opts and opts.sync or false
  if vim_enter_queue then
    table.insert(vim_enter_queue, { fn = fn, sync = sync })
  elseif sync then
    fn()
  else
    vim.schedule(fn)
  end
end

--- Queue a function to run after all VimEnter callbacks (for per-project overrides).
--- Always runs last, ensuring overrides have the final say.
---@param fn function
function M.on_override(fn)
  if override_queue then
    table.insert(override_queue, { fn = fn })
  else
    vim.schedule(fn)
  end
end

return M
