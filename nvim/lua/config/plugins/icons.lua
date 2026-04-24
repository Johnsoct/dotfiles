return {
    "nvim-tree/nvim-web-devicons",
    enabled = false,
    opts = {},
    config = function()
        require("nvim-web-devicons").setup({
            override_by_extension = {
                [".env*"] = {
                    icon = "",
                    color = "#eb0000",
                    name = "Environment",
                },
                [".gitignore"] = {
                    icon = "",
                    color = "#f34c27",
                    name = "GIT",
                },
                [".md"] = {
                    icon = "",
                    color = "#e44d25",
                    name = "Markdown",
                },
                [".html"] = {
                    icon = "",
                    color = "#e44d25",
                    name = "HTML",
                },
                [".d.ts"] = {
                    icon = "",
                    color = "#3178c5",
                    name = "TypeScript Declaration",
                },
            },
            strict = true;
        })
    end,
}
