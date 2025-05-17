local M = {}

local common = require("regex-rename.common")

function M.rename()
    local matches = {} 
    return common.scanFileForMatches("vim", 1, "$")
    
end

return M
