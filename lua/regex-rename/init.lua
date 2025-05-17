local M = {}

local virtualCursor = require("regex-rename.virtualCursor")
local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")


function M.rename()
    local matches = common.scanFileForMatches("if", 1, "$")

    for i = 1, #matches do
        local column = matches[i][1]
        local line = matches[i][2]

       --virtualCursor.add(line, column, 1, false)
    end
end

function M.setup()
    extmark.setup()
end

return M
