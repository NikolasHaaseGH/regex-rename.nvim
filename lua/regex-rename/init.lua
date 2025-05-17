local M = {}

local virtualCursor = require("regex-rename.visualCursor")
local common = require("regex-rename.common")

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function M.rename()
    local matches = common.scanFileForMatches("if", 1, "$")

    for i = 1, #matches do
        local column = matches[i][1]
        local line = matches[i][2]

       virtualCursor.add(line, column, 1, false)
    end
end

return M
