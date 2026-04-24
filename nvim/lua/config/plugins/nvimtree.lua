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
            -- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#custom-mappings
            local function my_on_attach(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end

                -- Default mappings
                api.map.on_attach.default(bufnr)

                -- Custom mappings
                vim.keymap.set("n", "<C-j>", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "<C-h>", api.node.open.horizontal, opts("Open: SEX"))
            end

            require("nvim-tree").setup({
                actions = {
                    open_file = {
                        quit_on_open = false,
                    },
                },
                hijack_netrw = true,
                on_attach = my_on_attach,
                reload_on_bufenter = true,
                renderer = {
                    highlight_opened_files = "name",
                    highlight_modified = "name",
                    icons = {
                        git_placement = "right_align",
                        modified_placement = "right_align",
                        padding = "  ",
                        show = {
                            file = false,
                            folder_arrow = false, -- Stupid empty box
                            hidden = false,
                        },
                    },
                },
                sync_root_with_cwd = true,
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

            -- Non-nvim-tree buffer commands
            vim.keymap.set("n", "<leader>e", require("nvim-tree.api").tree.toggle, { desc = "Open nvim-tree" })
        end,
    },
}
