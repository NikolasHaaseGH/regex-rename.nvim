local M = {}

local currentVirtualCursors = {}

local virtualCursor = require("regex-rename.virtual-cursor")

-- Callback for the CursorMoved event
-- Set editable to false for any virtual cursors that collide with the real
-- cursor
function M.cursorMoved()

  -- Get real cursor position
  local pos = vim.fn.getcurpos() -- [0, lnum, col, off, curswant]

  for idx = #currentVirtualCursors, 1, -1 do
    local vc = currentVirtualCursors[idx]

    -- First update the virtual cursor position from the extmark in case there
    -- was a change due to editing
    virtualCursor.updatePosition(vc)

    -- Mark editable to false if coincident with the real cursor
    --vc.editable = not (vc.lnum == pos[2] and vc.col == pos[3])

    -- Update the extmark (extmark is invisible if editable == false)
    virtualCursor.updateExtmark(vc)
  end
end


-- Add a new virtual cursor with a visual area
-- add_seq indicates that a sequence number should be added to store the order that cursors have being added
function M.addCursorWithVisualArea(lnum, col, curswant, visual_start_lnum, visual_start_col, add_seq, tokenLength)
    -- Check for existing virtual cursor
    for _, vc in ipairs(currentVirtualCursors) do
        if vc.col == col and vc.lnum == lnum then
            return
        end
    end

    -- local first = set_first and #virtualCursors == 0

    local seq = 0 -- 0 is ignored for restoring position

    if add_seq then
        -- seq = next_seq
        -- next_seq = next_seq + 1
    end

    table.insert(currentVirtualCursors, virtualCursor.new(lnum, col, curswant, visual_start_lnum, visual_start_col, seq))

    -- Create an extmark
    virtualCursor.updateExtmark(currentVirtualCursors[#currentVirtualCursors], tokenLength, true)
end

-- Add a new virtual cursor
-- add_seq indicates that a sequence number should be added to store the order that cursors have being added
function M.addCusor(lnum, col, curswant, add_seq, tokenLength)
    M.addCursorWithVisualArea(lnum, col, curswant, 0, 0, add_seq, tokenLength)
end

-- Clear all virtual cursors
function M.clear()
    currentVirtualCursors = {}
    --next_seq = 1
    --locked = false
    virtualCursor.setLocked(false)
end

function M.update_extmarks()
    for _, vc in ipairs(currentVirtualCursors) do
        virtualCursor.updateExtmark(vc)
    end
end

return M
