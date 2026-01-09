return {
    {
        {
            "catppuccin/nvim",
            enabled = false,
            config = function()
                require("catppuccin").setup({
                    flavour = "mocha",
                })

                vim.cmd.colorscheme("catppuccin-mocha")
            end,
        },
        {
            "AlexvZyl/nordic.nvim",
            enabled = false,
            config = function()
                -- require("nordic").load()
                vim.cmd.colorscheme("nordic")
            end,
        },
        {
            "folke/tokyonight.nvim",
            enabled = false,
            opts = {},
            config = function()
                local transparent = false

                if transparent then
                    vim.cmd([[
                        highlight Normal guibg=none
                        highlight NonText guibg=none
                        highlight Normal ctermbg=none
                        highlight NonText ctermbg=none
                    ]])
                end

                require("tokyonight").setup({
                    dim_inactive = true,

                    -- on_colors = function(colors)
                    --     colors.
                    styles = {
                        -- comments = {
                        --     bg = "white",
                        --     fg = "#222222",
                        -- },
                        -- floats = transparent and "transparent" or "dark",
                        -- sidebars = transparent and "transparent" or "dark",
                    },
                    transparent = transparent,
                })

                vim.cmd.colorscheme("tokyonight-storm")
            end,
        },
        {
            "ramojus/mellifluous.nvim",
            enabled = false,
            config = function()
                -- https://github.com/ramojus/mellifluous.nvim
                require("mellifluous").setup({
                    mellifluous = {
                        neutral = true,
                    },
                })
                vim.cmd.colorscheme("mellifluous")
            end,
        },
        {
            "davidosomething/vim-colors-meh.nvim",
            enabled = false,
            config = function()
                vim.cmd.colorscheme("meh")
            end,
        },
        {
            "mellow-theme/mellow.nvim",
            enabled = false,
            config = function()
                -- Plug 'mellow-theme/mellow.nvim'
                vim.cmd.colorscheme("mellow")
            end,
        },
        {
            "p00f/alabaster.nvim",
            enabled = false,
            config = function()
                vim.cmd.colorscheme("alabaster")
            end,
        },
        {
            "nyoom-engineering/oxocarbon.nvim",
            enabled = false,
            config = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("oxocarbon")
            end,
        },
        {
            "scottmckendry/cyberdream.nvim",
            enabled = false,
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("cyberdream")

                local transparent = true

                if transparent then
                    vim.cmd([[
                        highlight Normal guibg=none highlight NonText guibg=none
                        highlight Normal ctermbg=none
                        highlight NonText ctermbg=none
                    ]])
                end

                require("cyberdream").setup({
                    cache = false, -- improve start up time by caching highlights
                    theme = {
                        saturation = 1,
                    },
                    transparent = true,
                })

                -- The event data property will contain a string with either "default" or "light" respectively
                vim.api.nvim_create_autocmd("User", {
                    pattern = "CyberdreamToggleMode",
                    callback = function(event)
                        -- Your custom code here!
                        -- For example, notify the user that the colorscheme has been toggled
                        print("Switched to " .. event.data .. " mode!")
                    end,
                })
            end,
        },
        {
            "zenbones-theme/zenbones.nvim",
            -- Optionally install Lush. Allows for more configuration or extending the colorscheme
            -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
            -- In Vim, compat mode is turned on as Lush only works in Neovim.
            dependencies = "rktjmp/lush.nvim",
            enabled = false,
            -- you can set set configuration options here
            -- https://github.com/zenbones-theme/zenbones.nvim
            config = function()
                vim.g.zenbones_darken_comments = 45
                vim.cmd.colorscheme("zenbones")
            end,
        },
    },
}
