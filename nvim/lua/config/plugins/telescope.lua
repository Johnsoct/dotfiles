return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local ts = require("telescope")

            -----------------------
            -- Telescope options --
            -----------------------
            ts.setup({
                -- defaults = {
                --     file_ignore_patterns = {
                --         "^node_modules/",
                --     },
                -- },
                extensions = {
                    fzf = {
                        -- Default options
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
                pickers = {
                    buffers = {
                        theme = "ivy",
                    },
                    find_files = {
                        hidden = true,
                        no_ignore = false,
                        theme = "ivy",
                    },
                    grep_string = {
                        theme = "ivy",
                    },
                    live_grep = {
                        theme = "ivy",
                    },
                    oldfiles = {
                        theme = "ivy",
                    },
                    quickfix = {
                        theme = "ivy",
                    },
                },
            })

            -----------------------
            -- Extension Loading --
            -----------------------
            require("telescope").load_extension("fzf")

            -----------------------
            -- Telescope keymaps --
            -----------------------
            local tsb = require("telescope.builtin").buffers
            local tsff = require("telescope.builtin").find_files
            local tsht = require("telescope.builtin").help_tags
            local tslg = require("telescope.builtin").live_grep
            local tsgs = require("telescope.builtin").grep_string
            local tsof = require("telescope.builtin").oldfiles
            local tsqf = require("telescope.builtin").quickfix

            --en*
            vim.keymap.set("n", "<space>en", function()
                tsff({
                    cwd = vim.fn.stdpath("config"),
                })
            end, { desc = "telesceope neovim config files" })

            --f*
            vim.keymap.set("n", "<space><space>", tsht, { desc = "telescope help tags" })
            vim.keymap.set("n", "<space>tb", tsb, { desc = "telescope open buffers" })
            vim.keymap.set("n", "<space>tf", tsff, { desc = "telescope find files" })
            vim.keymap.set("n", "<space>tg", tslg, { desc = "telescope live grep" })
            vim.keymap.set("n", "<space>to", tsof, { desc = "telescope open old files" })
            vim.keymap.set("n", "<space>ts", tsgs, { desc = "telescope grep string" })
            vim.keymap.set("n", "<space>tq", tsqf, { desc = "telescope quickfix" })

            --g*
            vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { noremap = true, silent = true })
        end,
    },
}
