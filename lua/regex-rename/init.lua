local M = {}

local normalMode = require("regex-rename.normalMode")

function M.rename()
    local result = normalMode.rename()
    print(table.concat(result, ','))
end

return M
