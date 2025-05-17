local M = {}

local vapi = vim.api

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function scanLineForMatches(token, line, matchesArray, lineNumber)
    local match_start = 1
    local match_step = 1

    local lineLength = #line
    if lineLength < 1 or line == nil then
        return
    end

    local tokenLength = #token

    for i = 1, lineLength do
        if lineLength - i < tokenLength then
            break
        end

        if string.sub(line, i, i) == string.sub(token, match_step, match_step) then
            if match_step == tokenLength then
                table.insert(matchesArray, { lineNumber, match_start })
                match_start = i + 1
                match_step = 1
            else
                match_step = match_step + 1
            end
        else
            match_start = i + 1
            match_step = 1
        end
    end
end

function M.scanFileForMatches(token, start_line, end_line)
    local matches = {}
    local buffer = vim.api.nvim_get_current_buf()
    local bufferLines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local lineColumn = start_line

    local s = ""
    for i = 1, #bufferLines do
        scanLineForMatches(token, bufferLines[i], matches, lineColumn)
        s = s .. M.dump(matches)
    end

    print(s)

    return matches
end



return M
