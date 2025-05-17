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

    for i = 1, #matches do
        local line = matches[i][1]
        local column = matches[i][2]

        virtualCursor.add(line, column, 1, false, #token)
    end
end

function M.setup()
    extmark.setup()
end

return M
