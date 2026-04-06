return {
    {
        "nvim-treesitter/nvim-treesitter",
        -- Tells Lazy to run TSUpdate whenever we update this plugin, which
        -- ensures treesitter is rebuilt whenever we download new queries (parsers)
        build = ":TSUpdate",
        branch = "master",
        lazy = false,
        opts = {
            -- https://www.lazyvim.org/plugins/treesitter#nvim-treesitter
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = false,
            folds = { enable = true },
            ensure_installed = {
                "bash",
                "blade",
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
                "scss",
                "sql",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "vue",
                "yaml",
            },
            highlight = {
                enable = true,

                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                -- the name of the parser) list of language that will be disabled
                -- disable = { "c", "rust" },
                -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                disable = function(lang, buf)
                    local max_filesize = 5000 * 1024 -- 5 MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        },
    },
}
