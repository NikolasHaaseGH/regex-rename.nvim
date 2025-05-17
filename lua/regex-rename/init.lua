local M = {}

local virtualCursor = require("regex-rename.virtualCursor")
local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")

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

        virtualCursor.add_with_visual_area(line, newCursorPosition, 1, line, column, false, tokenSize)

        if line == cursorLine then
            if math.abs(cursorCol - column) < tokenSize then
                vim.fn.cursor({line, newCursorPosition - 1, 0, -1})
            end 
        end 
    end

end

function M.setup()
    extmark.setup()
end

return M
