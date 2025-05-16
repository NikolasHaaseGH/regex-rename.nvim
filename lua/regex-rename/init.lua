local M = {}

local normalMode = require("regex-rename.normalMode")

function M.rename()
    local result = normalMode.rename()
    --print(table.concat(result, ',')
    vim.pretty_print(result)
end

return M
