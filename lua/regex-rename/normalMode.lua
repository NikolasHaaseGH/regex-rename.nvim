local M = {}

local common = require("regex-rename.common")

function M.rename()
    local matches = {} 
    common.scanLineForMatches("test", "test: there are two tests in here.", matches, 3)
    return matches
end

return M
