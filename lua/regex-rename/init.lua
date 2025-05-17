local M = {}

local virtualCursor = require("regex-rename.virtualCursor")
local common = require("regex-rename.common")
local extmark = require("regex-rename.extmark")

local function is_mode(mode)
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

local function get_visual_area_text()
    local lnum1, col1, lnum2, col2 = get_normalised_visual_area()

    if lnum1 ~= lnum2 then
        vim.print("search pattern must be a single line")
        return nil
    end

    local line = vim.fn.getline(lnum1)
    return line:sub(col1, col2)
end

local function getWordUnderCursor()
    local pattern = ""

    if is_mode("v") then
        pattern = get_visual_area_text()
    else -- Normal mode
        -- Get word under cursor
        pattern = vim.fn.expand("<cword>")
        -- Match whole word
        --pattern = "\\<" .. vim.pesc(pattern) .. "\\>"
    end

    return pattern
end

function M.rename()
    local token = getWordUnderCursor()
    if token == "" then
        return
    end

    local matches = common.scanFileForMatches(token, 1, -1)

    for i = 1, #matches do
        local column = matches[i][2]
        local line = matches[i][1]

        virtualCursor.add(line, column, 1, false, #token)
    end
end

function M.setup()
    extmark.setup()
end

return M
