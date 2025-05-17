local M = {}

local virtualCursor = require("regex-rename.virtualCursor")
local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")

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

    print(dump(matches))

    for i = 1, #matches do
        local column = matches[i][1]
        local line = matches[i][2]

       virtualCursor.add(line, column, 1, false)
    end
end

function M.setup()
    extmark.setup()
end

return M
