local VirtualCursor = {}

local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")

local virtualCursors = {}

function createCursor(lnum, col, curswant, visual_start_lnum, visual_start_col, seq)
    local self = setmetatable({}, VirtualCursor)

    self.lnum = lnum
    self.col = col
    self.curswant = curswant

    self.seq = seq -- Sequence number to store the order that cursors were added
    -- When cursors are added with an up/down motion, at exit the
    -- real cursor is returned to the position of the oldest
    -- virtual cursor

    self.visual_start_lnum = visual_start_lnum -- lnum for the start of the visual area
    self.visual_start_col = visual_start_col -- col for the start of the visual area

    self.mark_id = 0                         -- extmark ID
    self.visual_start_mark_id = 0            -- ID of the hidden extmark that stores the start of the visual area
    self.visual_multiline_mark_id = 0        -- ID of the visual area extmark then spans multiple lines
    self.visual_empty_line_mark_ids = {}     -- IDs of the visual area extmarks for empty lines

    self.editable = true                     -- To disable editing the virtual cursor when
    -- in collision with the real cursor
    self.delete = false                      -- To mark the virtual cursor for deletion

    self.registers = {}

    return self
end


-- Add a new virtual cursor with a visual area
-- add_seq indicates that a sequence number should be added to store the order that cursors have being added
function VirtualCursor.add_with_visual_area(lnum, col, curswant, visual_start_lnum, visual_start_col, add_seq, tokenLength)

  -- Check for existing virtual cursor
  for _, vc in ipairs(virtualCursors) do
    if vc.col == col and vc.lnum == lnum then
      return
    end
  end

  -- local first = set_first and #virtualCursors == 0

  local seq = 0  -- 0 is ignored for restoring position

  if add_seq then
    -- seq = next_seq
    -- next_seq = next_seq + 1
  end

  table.insert(virtualCursors, createCursor(lnum, col, curswant, visual_start_lnum, visual_start_col, seq, tokenLength))

  -- Create an extmark
  extmark.update_virtual_cursor_extmark(virtualCursors[#virtualCursors])

end

-- Add a new virtual cursor
-- add_seq indicates that a sequence number should be added to store the order that cursors have being added
function VirtualCursor.add(lnum, col, curswant, add_seq, tokenLength)
  VirtualCursor.add_with_visual_area(lnum, col, curswant, lnum, col, add_seq, tokenLength)
end

return VirtualCursor

