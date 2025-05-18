local M = {}

local virtualCursor = require("regex-rename.virtualCursor")
local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")

local autocmd_group_id = nil

function M.rename()
    local token = common.getWordUnderCursor()
    if token == "" then
        return
    end

    local matches = common.scanFileForMatches(token, 1, -1)
    local offset = true and #token or 0

    local cursorLine, cursorCol = unpack(vim.api.nvim_win_get_cursor(0))
    local tokenSize = #token

    for i = 1, #matches do
        local line = matches[i][1]
        local column = matches[i][2]
        local newCursorPosition = column + offset


        if line == cursorLine then
            if math.abs(cursorCol - column) < tokenSize then
                vim.fn.cursor({ line, newCursorPosition, 0, -1 })
            end
        else
            virtualCursor.add_with_visual_area(line, newCursorPosition, 1, line, column, false, tokenSize)
        end
    end
end

-- create autocmds used by this plug-in
local function create_autocmds()
    -- monitor cursor movement to check for virtual cursors colliding with the real cursor
    vim.api.nvim_create_autocmd({ "cursormoved", "cursormovedi" },
        { group = autocmd_group_id, callback = virtualCursor.cursor_moved }
    )

    --[[
    -- mode changed from normal to insert or visual
    vim.api.nvim_create_autocmd({ "modechanged" }, {
        group = autocmd_group_id,
        pattern = "n:{i,v}",
        callback = normal_mode_mode_change.mode_changed,
    })

    -- mode changed from insert to normal
    vim.api.nvim_create_autocmd({ "modechanged" }, {
        group = autocmd_group_id,
        pattern = "i:n",
        callback = insert_mode_escape.mode_changed,
    })

    -- insert characters
    vim.api.nvim_create_autocmd({ "insertcharpre" },
        { group = autocmd_group_id, callback = insert_mode_character.insert_char_pre }
    )

    vim.api.nvim_create_autocmd({"textchangedi"},
      { group = autocmd_group_id, callback = insert_mode_character.text_changed_i }
    )

    vim.api.nvim_create_autocmd({"completedonepre"},
      { group = autocmd_group_id, callback = insert_mode_completion.complete_done_pre }
    )

    -- if there are custom key maps, reset the custom key maps on the lazyload
    -- event (when a plugin has been loaded)
    -- this is to fix an issue with using a command from a plugin that was lazy
    -- loaded while multi-cursors is active
    if key_maps.has_custom_keys_maps() then
      vim.api.nvim_create_autocmd({"user"}, {
        group = autocmd_group_id,
        pattern = "lazyload",
        callback = key_maps.set_custom,
      })
    end

    vim.api.nvim_create_autocmd({"bufleave"},
      { group = autocmd_group_id, callback = buf_leave }
    )

    vim.api.nvim_create_autocmd({"bufdelete"},
      { group = autocmd_group_id, callback = buf_delete }
    )
    ]] --
end

function M.setup()
    extmark.setup()
    create_autocmds()

    autocmd_group_id = vim.api.nvim_create_augroup("MultipleCursors", {})
end

return M
