local Extmark = {}


local cursor_hl_group = "MultipleCursorsCursor"
local locked_cursor_hl_group = "MultipleCursorsLockedCursor"
local visual_hl_group = "MultipleCursorsVisual"
local locked_visual_hl_group = "MultipleCursorsLockedVisual"

local highlight_namespace_id = nil
local locked = false


local function set_extmark(lnum, col, mark_id, hl_group, priority)
    local opts = {}

    if mark_id ~= 0 then
        opts.id = mark_id
    end

    -- Otherwise highlight the character
    opts.end_col = col
    opts.hl_group = hl_group

    if priority ~= 0 then
        opts.priority = priority
    end

    return vim.api.nvim_buf_set_extmark(0, highlight_namespace_id, lnum - 1, col - 1, opts)
end

function Extmark.update_virtual_cursor_extmark(vc)
    if vc.editable then
        local hl_group = locked and locked_cursor_hl_group or cursor_hl_group
        vc.mark_id = set_extmark(vc.lnum, vc.col, vc.mark_id, hl_group, 9999)
    else
        -- Invisible mark when the virtual cursor isn't editable (in collision with the real cursor)
        vc.mark_id = set_extmark(vc.lnum, vc.col, vc.mark_id, "", 9999)
    end
end


return Extmark
