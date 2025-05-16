local M = {}

local vapi = vim.api

local function scanLineForMatches(token, line, matchesArray, lineNumber)
    local match_start = 1
    local match_step = 1

    local lineLength = #line
    local tokenLength = #token
    local count = 0
    for i = 1, lineLength do
        if lineLength - i < tokenLength then
            break
        end

        if line[i] == token[match_step] then
            if match_step == tokenLength then
                table.insert(matchesArray, {lineNumber, match_start})
                match_start = i+1
                match_step = 1 
                count = count + 1
            else
                match_step = match_step + 1
            end
        else
            match_start = i+1
            match_step = 1
        end
    end
    print(count)
end

function M.scanFileForMatches(token, start_line, end_line)
    local matches = {}
    local buffer = vim.api.nvim_get_current_buf() 
    local bufferLines = vim.api.nvim_buf_get_lines(buffer, 1, 5, false)
    local lineColumn = start_line

    for i = 1, #bufferLines do
        scanLineForMatches(token, bufferLines[i], matches, lineColumn )
    end

    return matches
end

M.scanFileForMatches("test", 0, 5)

return M
