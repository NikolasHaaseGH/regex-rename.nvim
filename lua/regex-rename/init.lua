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

    for i = 1, #matches do
        local line = matches[i][1]
        local column = matches[i][2]
        local endOfWord = column + offset

        virtualCursor.add_with_visual_area(line, endOfWord, 1, line, column, false, #token)
        vim.fn.cursor({line, endOfWord, 0, -1})
    end
end

function M.setup()
    extmark.setup()
end

return M
