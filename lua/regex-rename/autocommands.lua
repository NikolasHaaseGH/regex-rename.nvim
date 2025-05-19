local normal_mode = require("regex-rename.normal-mode")

local Autocommands = {}

Autocommands.group_id = nil

function Autocommands.init()

    Autocommands.group_id = vim.api.nvim_create_augroup("MultipleCursors", {})

    -- mode changed from normal to insert or visual
    vim.api.nvim_create_autocmd({"modechanged"}, {
      group = Autocommands.group_id,
      pattern = "n:{i,v}",
      callback = normal_mode.mode_changed,
    })

    -- mode changed from insert to normal
    vim.api.nvim_create_autocmd({"modechanged"}, {
      group = Autocommands.group_id,
      pattern = "i:n",
      callback = normal_mode.mode_changed,
    })

end


