return {
    {
        "nvim-tree/nvim-tree.lua",
        enabled = true,
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                actions = {
                    open_file = {
                        quit_on_open = false,
                    },
                },
                hijack_netrw = true,
                reload_on_bufenter = true,
                sync_root_with_cwd = true,
                renderer = {
                    highlight_opened_files = "name",
                    highlight_modified = "name",
                    icons = {
                        git_placement = "right_align",
                        modified_placement = "right_align",
                        padding = "  ",
                        show = {
                            folder_arrow = false, -- Stupid empty box
                            hidden = false,
                        },
                    },
                },
                view = {
                    centralize_selection = true,
                    relativenumber = true,
                    signcolumn = "yes",
                    width = 30,
                },
                update_focused_file = {
                    enable = true,
                },
            })

            local api = require("nvim-tree.api")

            vim.keymap.set("n", "<space>e", api.tree.toggle)
            vim.keymap.set("n", "<space>fe", api.tree.focus)
        end,
    },
}
