local plugin = {}

local vapi = vim.api

local normalMode = require("simple_rename.normalMode")

local Mode = {}
Mode.normal = 0
Mode.visual_by_character = 1
Mode.visual_by_line = 2
Mode.visual_blockwise = 3
Mode.insert = 4

function getCurrentMode()
    local vim_mode = vapi.mode()
        
    if vim_mode == "n" then return Mode.normal
    elseif vim_mode == "v" then return Mode.visual_by_character
    elseif vim_mode == "V" then return Mode.visual_by_line
    elseif vim_mode == "CTRL-V" then return Mode.visual_blockwise
    elseif vim_mode == "i" then return Mode.insert
    else return Mode.normal -- TODO: change this to some error value
    end
end

function plugin.rename()
    local mode = getCurrentMode()
    if mode == Mode.normal then 
        beginRenameInNormalMode()
    end
end



return plugin
