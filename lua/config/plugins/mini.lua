return {
    {
        'echasnovski/mini.nvim',
        -- change below to `false` to disable the plugin!
        enabled = true,
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = true }
        end
    }
}
