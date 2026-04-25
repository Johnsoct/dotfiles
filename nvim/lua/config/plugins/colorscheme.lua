return {
    -- https://vimcolorschemes.com/i/trending
    {
        {
            -- https://vimcolorschemes.com/zenbones-theme/zenbones.nvim
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
                vim.o.background = "light"
                vim.cmd.colorscheme("tokyobones")
            end,
        },
    },
}
