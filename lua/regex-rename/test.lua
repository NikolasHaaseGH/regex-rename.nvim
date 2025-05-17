local function scanLineForMatches(token, line, matchesArray, lineNumber)
    local match_start = 1
    local match_step = 1

    local lineLength = #line
    if lineLength < 1 or line == nil then
        return
    end
    local tokenLength = #token
    local count = 0
    for i = 1, lineLength do
        if lineLength - i < tokenLength then
            break
        end

        if string.sub(line, i, i) == string.sub(token, match_step, match_step) then
            if match_step == tokenLength then
                table.insert(matchesArray, { lineNumber, match_start })
                match_start = i + 1
                match_step = 1
                count = count + 1
            else
                match_step = match_step + 1
            end
        else
            match_start = i + 1
            match_step = 1
        end
    end
end

local matches = {}

scanLineForMatches("test", "test: the token test occurs 2 times in this line.", matches, 3)
