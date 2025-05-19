local M = {}

local virtualCursor = require("regex-rename.virtual-cursor")
local common = require("regex-rename.common")
local cursors = require("regex-rename.cursors")

local normal_mode_mode_change = require("regex-rename.normalMode")
local insert_mode_escape = require("regex-rename.insertMode")

local autocommands = require("regex-rename.autocommands")

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

        if line == cursorLine then
            if math.abs(cursorCol - column) < tokenSize then
                vim.fn.cursor({ line, column, 0, -1 })
            end
        else
            cursors.addCursorWithVisualArea(line, column, 1, line, column, false, tokenSize)
        end
    end
end


function M.setup()
    virtualCursor.setup()
    autocommands.init()
end

return M
