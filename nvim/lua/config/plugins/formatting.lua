-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file
return {
    {
        "stevearc/conform.nvim",
        enabled = true,
        config = function()
            local conform = require("conform")

            conform.setup({
                default_format_opts = {
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    -- Conform will run the first available formatter
                    -- javascript = { "prettierd", "prettier", stop_after_first = true }

                    bash = { "shfmt" },
                    css = { "stylelint" },
                    go = { "gopls" },
                    html = { "eslint_d" },
                    javascript = { "eslint_d" },
                    json = { "fixjson" },
                    lua = { "stylua" },
                    markdown = { "marksman" },
                    scss = { "stylelint" },
                    sql = { "sqlfmt" },
                    typescript = { "eslint_d" },
                    vue = { "eslint_d", "stylelint" },
                },
            })

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function(args)
                    conform.format({ bufnr = args.buf })
                end,
            })
        end,
    },
}
