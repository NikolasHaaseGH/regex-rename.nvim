local M = {}

local virtualCursor = require("regex-rename.virtualCursor")
local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")


function M.rename()
    local matches = common.scanFileForMatches("if", 1, -1)

    for i = 1, #matches do
        local column = matches[i][2]
        local line = matches[i][1]

        virtualCursor.add(line, column, 2, false)
    end
end

function M.setup()
    extmark.setup()
end

local function get_search_pattern()

  local pattern = nil

  if common.is_mode("v") then
    pattern = get_visual_area_text()
  else -- Normal mode
    -- Get word under cursor
    pattern = vim.fn.expand("<cword>")
    -- Match whole word
    pattern = "\\<" .. vim.pesc(pattern) .. "\\>"
  end

  if pattern == "" then
    return nil
  else
    return pattern
  end

end

return M
