local VirtualCursor = {}


local cursor_hl_group = "MultipleCursorsCursor"
local locked_cursor_hl_group = "MultipleCursorsLockedCursor"
local visual_hl_group = "MultipleCursorsVisual"
local locked_visual_hl_group = "MultipleCursorsLockedVisual"

local highlight_namespace_id = nil
local locked = false


function VirtualCursor.new(lnum, col, curswant, visual_start_lnum, visual_start_col, seq)
    local self = setmetatable({}, VirtualCursor)

    self.lnum = lnum
    self.col = col
    self.curswant = curswant

    self.seq = seq -- Sequence number to store the order that cursors were added
    -- When cursors are added with an up/down motion, at exit the
    -- real cursor is returned to the position of the oldest
    -- virtual cursor

    self.visual_start_lnum = visual_start_lnum -- lnum for the start of the visual area
    self.visual_start_col = visual_start_col   -- col for the start of the visual area

    self.mark_id = 0                           -- extmark ID
    self.visual_start_mark_id = 0              -- ID of the hidden extmark that stores the start of the visual area
    self.visual_multiline_mark_id = 0          -- ID of the visual area extmark then spans multiple lines
    self.visual_empty_line_mark_ids = {}       -- IDs of the visual area extmarks for empty lines

    self.editable = true                       -- To disable editing the virtual cursor when
    -- in collision with the real cursor
    self.delete = false                        -- To mark the virtual cursor for deletion

    self.registers = {}

    return self
end

local function setExtmark(lnum, col, mark_id, hl_group, priority, tokenLength)
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

function VirtualCursor.updateExtmark(vcursor, tokenLength, reverse)
    local startCol = reverse and vcursor.col - tokenLength or vcursor.col

    if vcursor.editable then
        local hl_group = locked and locked_cursor_hl_group or cursor_hl_group
        vcursor.mark_id = setExtmark(vcursor.lnum, startCol, vcursor.mark_id, hl_group, 9999, tokenLength)
    else
        -- Invisible mark when the virtual cursor isn't editable (in collision with the real cursor)
        vcursor.mark_id = setExtmark(vcursor.lnum, startCol, vcursor.mark_id, "", 9999, tokenLength)
    end
end

function VirtualCursor.setLocked(value)
    locked = value
end

function VirtualCursor.updatePosition(vcursor)
    -- Main extmark
    if vcursor.mark_id ~= 0 then
        -- Get position
        local extmark_pos = vim.api.nvim_buf_get_extmark_by_id(0, highlight_namespace_id, vcursor.mark_id, {})

        -- If the mark is valid
        if next(extmark_pos) ~= nil then
            -- Update the virtual cursor position
            vcursor.lnum = extmark_pos[1] + 1
            vcursor.col = extmark_pos[2] + 1
        else
            -- The extmark is gone, mark the virtual cursor for removal
            vcursor.delete = true
        end
    end

    if vcursor.delete then
        return
    end

    -- Visual area start extmark
    if vcursor.visual_start_mark_id ~= 0 then
        -- Get position
        local extmark_pos = vim.api.nvim_buf_get_extmark_by_id(0, highlight_namespace_id, vcursor.visual_start_mark_id,
            {})

        -- If the mark is valid
        if next(extmark_pos) ~= nil then
            -- Update the virtual cursor visual start position
            vcursor.visual_start_lnum = extmark_pos[1] + 1
            vcursor.visual_start_col = extmark_pos[2] + 1
        else
            -- The extmark is gone, mark the virtual cursor for removal
            vcursor.delete = true
        end
    end
end

function VirtualCursor.setup()
    -- Global highlight groups which can be overridden by the user

    -- Check if the Cursor highlight group is defined
    if next(vim.api.nvim_get_hl(0, { name = "Cursor" })) then
        vim.api.nvim_set_hl(0, cursor_hl_group, { link = "Cursor", default = true })
        vim.api.nvim_set_hl(0, locked_cursor_hl_group, { link = "Cursor", default = true })
    else
        -- Use TermCursor if Cursor isn't defined
        vim.api.nvim_set_hl(0, cursor_hl_group, { link = "TermCursor", default = true })
        vim.api.nvim_set_hl(0, locked_cursor_hl_group, { link = "TermCursor", default = true })
    end

    vim.api.nvim_set_hl(0, visual_hl_group, { link = "Visual", default = true })
    vim.api.nvim_set_hl(0, locked_visual_hl_group, { link = "Visual", default = true })

    -- Create a namespace for the extmarks
    highlight_namespace_id = vim.api.nvim_create_namespace("multiple-cursors")
end

return VirtualCursor
