--- https://github.com/JoosepAlviste/dotfiles/blob/master/config/nvim/lua/j/plugins/treesitter.lua
---@param bufnr integer
---@return boolean
--- Used to skip tree-sitter on files over 100K lines
local is_large_file = function(bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 100000
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        init = function()
            -- This autocmd runs before parser updates happen, and it registers a custom vue parser
            vim.api.nvim_create_autocmd("User", {
                pattern = "TSUpdate",
                callback = function()
                    require("nvim-treesitter.parsers").vue = {
                        install_info = {
                            -- revision = "d3a6a9b8170d93e05436ad792833a8b1e9995f5b",
                            url = "https://github.com/tree-sitter-grammars/tree-sitter-vue",
                        },
                    }
                end,
            })

            require("nvim-treesitter").install({
                "bash",
                "c",
                "css",
                "javascript",
                "go",
                "html",
                "jsdoc",
                "json",
                "lua",
                "query",
                "markdown",
                "markdown_inline",
                "php",
                "php_only",
                "python",
                "regex",
                "scss",
                "sql",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "vue",
                "yaml",
                "vim",
                "vimdoc",
            })

            local group = vim.api.nvim_create_augroup("MyTreesitterSetup", { clear = true })

            -- For each listed filetype, when a buffer opens, it does three things if the file isn't too large:
            -- vim.treesitter.start() — starts Neovim's built-in treesitter highlighter
            -- Sets indentexpr to nvim-treesitter's indent function
            -- Sets folding to use treesitter's fold expression
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = {
                    "vue",
                    "typescript",
                    "typescriptreact",
                    "query",
                    "markdown",
                    "javascript",
                    "json",
                    "html",
                    "graphql",
                    "yaml",
                    "css",
                    "bash",
                    "scss",
                },
                callback = function(args)
                    if not is_large_file(args.buf) then
                        -- Starts the built-in tree-sitter highlighter
                        vim.treesitter.start()
                        -- Sets nvim's tree-sitter's indent function
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        -- Sets folding to use treesitter's fold expression
                        vim.wo[0][0].foldmethod = "expr"
                        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            })
        end,
    },
    {
        -- match-up is a plugin that lets you highlight, navigate, and operate on sets of matching
        -- text. It extends vim's % key to language-specific words instead of just single characters
        "andymass/vim-matchup",
        config = function()
            vim.g.matchup_matchparen_offscreen = {}
        end,
    },
    {
        -- Plugin to use treesitter to auto close and auto rename html tag
        "windwp/nvim-ts-autotag",
        opts = {},
    },
}
