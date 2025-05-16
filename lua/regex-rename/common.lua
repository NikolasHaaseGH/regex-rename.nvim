local M = {}

local vapi = vim.api

local function scanLineForMatches(token, line, matchesArray, lineNumber)
    local match_start = 1
    local match_step = 1

    local lineLength = #line
    local tokenLength = #token

    for i = 1, lineLength do
        if lineLength - i < tokenLength then
            break
        end

        if line[i] == token[match_step] then
            if match_step == #token then
                table.insert(matchesArray, {lineNumber, match_start})
                match_start = i
                match_step = 1 
            else
                match_step = match_step + 1
            end
        else
            match_start = i
            match_step = 1
        end
    end
end

function M.scanFileForMatches(token, start_line, end_line)
    local matches = {}
    local bufferLines = vapi.getbufline(0, 1, "$") -- get list of all lines in buffer

    local lineColumn = start_line

    for i = 1, #bufferLines do
        scanLineForMatches(token, bufferLines[i], matches, lineColumn )
    end
end

return M
