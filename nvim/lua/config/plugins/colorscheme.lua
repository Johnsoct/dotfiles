return {
    {
        -- https://github.com/ramojus/mellifluous.nvim
        {
            "ramojus/mellifluous.nvim",
            enabled = false,
            config = function()
                require("mellifluous").setup({
                    mellifluous = {
                        neutral = true,
                    },
                })
                vim.cmd.colorscheme("mellifluous")
            end,
        },
        -- https://github.com/davidosomething/vim-colors-meh?tab=readme-ov-file
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
            "zenbones-theme/zenbones.nvim",
            -- Optionally install Lush. Allows for more configuration or extending the colorscheme
            -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
            -- In Vim, compat mode is turned on as Lush only works in Neovim.
            dependencies = "rktjmp/lush.nvim",
            enabled = true,
            -- you can set set configuration options here
            -- https://github.com/zenbones-theme/zenbones.nvim
            config = function()
                vim.g.zenbones_darken_comments = 45
                vim.cmd.colorscheme("zenbones")
            end,
        },
    },
}
