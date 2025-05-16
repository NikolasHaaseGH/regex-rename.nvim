local M = {}


local normalMode = require("regex-rename.normalMode")


function M.rename()
    print("moinsen")
end

function M.setup(options) 
    opts = options or {}

    autocmd_group_id = vim.api.nvim_create_augroup("RegexRename", {})

end

return M
