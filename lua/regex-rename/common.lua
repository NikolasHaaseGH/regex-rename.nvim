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

        if string.sub(line, i, i) == string.sub(token, match_step, match_step) then
            if match_step == tokenLength then
                table.insert(matchesArray, { lineNumber, match_start })
                if lineLength - i < tokenLength then
                    break
                end
                match_start = i + 1
                match_step = 1
            else
                match_step = match_step + 1
            end
        else
            if lineLength - i < tokenLength then
                break
            end
            match_start = i + 1
            match_step = 1
        end
    end
end

function M.scanFileForMatches(token, start_line, end_line)
    local matches = {}
    local buffer = vim.api.nvim_get_current_buf()
    local bufferLines = vim.api.nvim_buf_get_lines(buffer, 0, end_line, false)
    local lineColumn = start_line

    for i = 1, #bufferLines do
        if #bufferLines[i] >= #token then
            scanLineForMatches(token, bufferLines[i], matches, lineColumn)
        end

        lineColumn = lineColumn + 1
    end

    print(M.dump(matches))

    return matches
end

function M.is_mode(mode)
    return vim.api.nvim_get_mode().mode == mode
end

-- Get current visual area
-- Returns v_lnum, v_col, lnum, col, curswant
local function get_visual_area()
    local vpos = vim.fn.getpos("v")
    local cpos = vim.fn.getcurpos()
    return vpos[2], vpos[3], cpos[2], cpos[3], cpos[5]
end

-- Get current visual area in a forward direction
-- returns lnum1, col1, lnum2, col2
local function get_normalised_visual_area()
    local v_lnum, v_col, lnum, col = get_visual_area()

    -- Normalise
    if v_lnum < lnum then
        return v_lnum, v_col, lnum, col
    elseif lnum < v_lnum then
        return lnum, col, v_lnum, v_col
    else -- v_lnum == lnum
        if v_col <= col then
            return v_lnum, v_col, lnum, col
        else -- col < v_col
            return lnum, col, v_lnum, v_col
        end
    end
end

function M.get_visual_area_text()
    local lnum1, col1, lnum2, col2 = get_normalised_visual_area()

    if lnum1 ~= lnum2 then
        vim.print("search pattern must be a single line")
        return nil
    end

    local line = vim.fn.getline(lnum1)
    return line:sub(col1, col2)
end

function M.getWordUnderCursor()
    local pattern = nil

    if M.is_mode("v") then
        pattern = M.get_visual_area_text()
    else -- Normal mode
        -- Get word under cursor
        pattern = vim.fn.expand("<cword>")
        -- Match whole word
        --pattern = "\\<" .. vim.pesc(pattern) .. "\\>"
    end

    return pattern == nil and "" or pattern
end

return M
