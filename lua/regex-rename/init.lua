local M = {}

local normalMode = require("regex-rename.normalMode")

function M.rename()
    local result = normalMode.rename()
    print(result[0][0])
end

return M
