local M = {}


local cursor_hl_group = "MultipleCursorsCursor"
local locked_cursor_hl_group = "MultipleCursorsLockedCursor"
local visual_hl_group = "MultipleCursorsVisual"
local locked_visual_hl_group = "MultipleCursorsLockedVisual"

local highlight_namespace_id = nil
local locked = false


local function set_extmark(lnum, col, mark_id, hl_group, priority, tokenLength)
    local opts = {}

    if mark_id ~= 0 then
        opts.id = mark_id
    end

    -- Highlight the entire token
    opts.end_col = col + (tokenLength - 1)
    opts.hl_group = hl_group

    if priority ~= 0 then
        opts.priority = priority
    end

    return vim.api.nvim_buf_set_extmark(0, highlight_namespace_id, lnum - 1, col - 1, opts)
end

function M.update_virtual_cursor_extmark(vc, tokenLength, reverse)
    local startCol = reverse and vc.col - tokenLength or vc.col

    if vc.editable then
        local hl_group = locked and locked_cursor_hl_group or cursor_hl_group
        vc.mark_id = set_extmark(vc.lnum, startCol, vc.mark_id, hl_group, 9999, tokenLength)
    else
        -- Invisible mark when the virtual cursor isn't editable (in collision with the real cursor)
        vc.mark_id = set_extmark(vc.lnum, startCol, vc.mark_id, "", 9999, tokenLength)
    end
end

function M.setup()

  -- Global highlight groups which can be overridden by the user

  -- Check if the Cursor highlight group is defined
  if next(vim.api.nvim_get_hl(0, {name="Cursor"})) then
    vim.api.nvim_set_hl(0, cursor_hl_group, {link = "Cursor", default = true})
    vim.api.nvim_set_hl(0, locked_cursor_hl_group, {link = "Cursor", default = true})

  else
    -- Use TermCursor if Cursor isn't defined
    vim.api.nvim_set_hl(0, cursor_hl_group, {link = "TermCursor", default = true})
    vim.api.nvim_set_hl(0, locked_cursor_hl_group, {link = "TermCursor", default = true})

  end

  vim.api.nvim_set_hl(0, visual_hl_group, {link = "Visual", default = true})
  vim.api.nvim_set_hl(0, locked_visual_hl_group, {link = "Visual", default = true})

  -- Create a namespace for the extmarks
  highlight_namespace_id = vim.api.nvim_create_namespace("multiple-cursors")

end

return M
