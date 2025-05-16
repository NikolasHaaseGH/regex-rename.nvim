local M = {}

local normalMode = require("regex-rename.normalMode")

function M.rename()
    normalMode.rename()
end

return M
