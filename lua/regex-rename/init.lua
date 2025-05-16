local M = {}

local normalMode = require("regex-rename.normalMode")

function M.rename()
    local result = normalMode.rename()
    print(result[1][1])
end

return M
