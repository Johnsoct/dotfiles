return {
    {

        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
            auto_update = true,
            ensure_installed = {
                "bash-language-server",
                "css-lsp",
                "css-variables-language-server",
                "dotenv-linter",
                "eslint_d",
                "fixjson",
                "gh-actions-language-server",
                -- "go-debug-adapter",
                "gofumpt",
                "goimports",
                "gopls",
                "html-lsp",
                "js-debug-adapter",
                "json-lsp",
                "jsonlint",
                "lua-language-server",
                "luacheck",
                "luaformatter",
                "markdownlint",
                "marksman",
                "pyright",
                "ruff",
                "shellcheck",
                "shfmt",
                "some-sass-language-server",
                "sql-formatter",
                "sqls",
                "stylelint",
                "stylua",
                "typescript-language-server",
                "vue-language-server",
                "vtsls",
                "yaml-language-server",
                "yamlfmt",
                "yamllint",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lsp = vim.lsp

            ------------
            --- BASH ---
            ------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/bashls.lua
            lsp.config("bashls", {
                cmd = { "bash-language-server", "start" },
                settings = {
                    bashIde = {
                        -- Glob pattern for finding and parsing shell script files in the workspace.
                        -- Used by the background analysis features across files.

                        -- Prevent recursive scanning which will cause issues when opening a file
                        -- directly in the home directory (e.g. ~/foo.sh).
                        --
                        -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
                        globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
                    },
                },
                filetypes = { "bash", "sh" },
                root_markers = { ".git" },
            })
            lsp.enable("bashls")

            -----------
            --- CSS ---
            -----------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/cssls.lua
            lsp.config("cssls", {
                cmd = { "vscode-css-language-server", "--stdio" },
                filetypes = { "css", "scss", "less" },
                init_options = { provideFormatter = false }, -- needed to enable formatting capabilities
                root_markers = { "package.json", ".git" },
                settings = {
                    css = { validate = true },
                    scss = { validate = true },
                    less = { validate = true },
                },
            })
            lsp.enable("cssls")

            ---------------------
            --- CSS VARIABLES ---
            ---------------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/css_variables.lua
            lsp.config("css_variables", {
                cmd = { "css-variables-language-server", "--stdio" },
                filetypes = { "css", "scss", "less" },
                root_markers = { "package.json", ".git" },
                -- Same as inlined defaults that don't seem to work without hardcoding them in the lua config
                -- https://github.com/vunguyentuan/vscode-css-variables/blob/763a564df763f17aceb5f3d6070e0b444a2f47ff/packages/css-variables-language-server/src/CSSVariableManager.ts#L31-L50
                settings = {
                    cssVariables = {
                        lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
                        blacklistFolders = {
                            "**/.cache",
                            "**/.DS_Store",
                            "**/.git",
                            "**/.hg",
                            "**/.next",
                            "**/.svn",
                            "**/bower_components",
                            "**/CVS",
                            "**/dist",
                            "**/node_modules",
                            "**/tests",
                            "**/tmp",
                        },
                    },
                },
            })
            lsp.enable("css_variables")

            -------------
            --- GOPLS ---
            -------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/gopls.lua
            --- @class go_dir_custom_args
            ---
            --- @field envvar_id string
            ---
            --- @field custom_subdir string?

            local mod_cache = nil
            local std_lib = nil

            ---@param custom_args go_dir_custom_args
            ---@param on_complete fun(dir: string | nil)
            local function identify_go_dir(custom_args, on_complete)
                local cmd = { "go", "env", custom_args.envvar_id }
                vim.system(cmd, { text = true }, function(output)
                    local res = vim.trim(output.stdout or "")
                    if output.code == 0 and res ~= "" then
                        if custom_args.custom_subdir and custom_args.custom_subdir ~= "" then
                            res = res .. custom_args.custom_subdir
                        end
                        on_complete(res)
                    else
                        vim.schedule(function()
                            vim.notify(
                                ("[gopls] identify " .. custom_args.envvar_id .. " dir cmd failed with code %d: %s\n%s"):format(
                                    output.code,
                                    vim.inspect(cmd),
                                    output.stderr
                                )
                            )
                        end)
                        on_complete(nil)
                    end
                end)
            end

            ---@return string?
            local function get_std_lib_dir()
                if std_lib and std_lib ~= "" then
                    return std_lib
                end

                identify_go_dir({ envvar_id = "GOROOT", custom_subdir = "/src" }, function(dir)
                    if dir then
                        std_lib = dir
                    end
                end)
                return std_lib
            end

            ---@return string?
            local function get_mod_cache_dir()
                if mod_cache and mod_cache ~= "" then
                    return mod_cache
                end

                identify_go_dir({ envvar_id = "GOMODCACHE" }, function(dir)
                    if dir then
                        mod_cache = dir
                    end
                end)
                return mod_cache
            end

            ---@param fname string
            ---@return string?
            local function get_root_dir(fname)
                if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
                    local clients = vim.lsp.get_clients({ name = "gopls" })
                    if #clients > 0 then
                        return clients[#clients].config.root_dir
                    end
                end
                if std_lib and fname:sub(1, #std_lib) == std_lib then
                    local clients = vim.lsp.get_clients({ name = "gopls" })
                    if #clients > 0 then
                        return clients[#clients].config.root_dir
                    end
                end
                return vim.fs.root(fname, "go.work") or vim.fs.root(fname, "go.mod") or vim.fs.root(fname, ".git")
            end

            ---@type vim.lsp.Config
            lsp.config("gopls", {
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = function(bufnr, on_dir)
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    get_mod_cache_dir()
                    get_std_lib_dir()
                    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
                    on_dir(get_root_dir(fname))
                end,
            })
            lsp.enable("gopls")

            ------------
            --- HTML ---
            ------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/html.lua
            --- `pnpm add -g vscode-langservers-extracted`
            lsp.config("html", {
                cmd = { "vscode-html-language-server", "--stdio" },
                filetypes = { "html", "templ" },
                root_markers = { "package.json", ".git" },
                settings = {},
                init_options = {
                    provideFormatter = true,
                    embeddedLanguages = { css = true, javascript = true },
                    configurationSection = { "html", "css", "javascript" },
                },
            })
            lsp.enable("html")

            ------------
            --- HTMX ---
            ------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/htmx.lua
            lsp.config("htmx", {
                cmd = { "htmx-lsp" },
                filetypes = { -- filetypes copied and adjusted from tailwindcss-intellisense
                    -- html
                    "aspnetcorerazor",
                    "astro",
                    "astro-markdown",
                    "blade",
                    "clojure",
                    "django-html",
                    "htmldjango",
                    "edge",
                    "eelixir", -- vim ft
                    "elixir",
                    "ejs",
                    "erb",
                    "eruby", -- vim ft
                    "gohtml",
                    "gohtmltmpl",
                    "haml",
                    "handlebars",
                    "hbs",
                    "html",
                    "htmlangular",
                    "html-eex",
                    "heex",
                    "jade",
                    "leaf",
                    "liquid",
                    "markdown",
                    "mdx",
                    "mustache",
                    "njk",
                    "nunjucks",
                    "php",
                    "razor",
                    "slim",
                    "twig",
                    -- js
                    "javascript",
                    "javascriptreact",
                    "reason",
                    "rescript",
                    "typescript",
                    "typescriptreact",
                    -- mixed
                    "vue",
                    "svelte",
                    "templ",
                },
                root_markers = { ".git" },
            })
            lsp.enable("htmx")

            ------------
            --- JSON ---
            ------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jsonls.lua
            lsp.config("jsonls", {
                cmd = { "vscode-json-language-server", "--stdio" },
                filetypes = { "json", "jsonc" },
                init_options = {
                    provideFormatter = true,
                },
                root_markers = { ".git" },
            })
            lsp.enable("jsonls")

            -----------
            --- LUA ---
            -----------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
            lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = {
                    ".luarc.json",
                    ".luarc.jsonc",
                    ".luacheckrc",
                    ".stylua.toml",
                    "stylua.toml",
                    "selene.toml",
                    "selene.yml",
                    ".git",
                },
            })
            lsp.enable("lua_ls")

            ----------------
            ---- PYTHON ----
            ----------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/pylsp.lua
            lsp.config("pylsp", {
                cmd = { "pylsp" },
                filetypes = { "python" },
                root_markers = {
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    ".git",
                },
            })
            lsp.enable("pylsp")

            ----------------
            --- SOMESASS ---
            ----------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/somesass_ls.lua
            --- `pnpm add -g some-sass-language-server`
            lsp.config("somesass_ls", {
                name = "somesass_ls",
                cmd = { "some-sass-language-server", "--stdio" },
                filetypes = { "scss", "sass" },
                root_markers = { ".git", ".package.json" },
                settings = {
                    somesass = {
                        suggestAllFromOpenDocument = true,
                    },
                },
            })
            lsp.enable("somesass_ls")

            ------------
            --- SQL ----
            ------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/sqls.lua
            lsp.config("sqls", {
                cmd = { "sqls" },
                filetypes = { "sql", "mysql" },
                root_markers = { "config.yml" },
                settings = {},
            })
            lsp.enable("sqls")

            -----------------
            --- STYLELINT ---
            -----------------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/stylelint_lsp.lua
            local util = require("lspconfig.util")

            local root_file = {
                ".stylelintrc",
                ".stylelintrc.mjs",
                ".stylelintrc.cjs",
                ".stylelintrc.js",
                ".stylelintrc.json",
                ".stylelintrc.yaml",
                ".stylelintrc.yml",
                "stylelint.config.mjs",
                "stylelint.config.cjs",
                "stylelint.config.js",
            }

            root_file = util.insert_package_json(root_file, "stylelint")

            ---@type vim.lsp.Config
            lsp.config("stylelint_lsp", {
                cmd = { "stylelint-lsp", "--stdio" },
                filetypes = {
                    "astro",
                    "css",
                    "html",
                    "less",
                    "scss",
                    "sugarss",
                    "vue",
                    "wxss",
                },
                root_markers = root_file,
                settings = {
                    stylelintplus = {
                        autoFixOnFormat = true,
                        autoFixOnSave = true,
                        validateOnSave = true,
                        validateOnType = true,
                    },
                },
            })
            lsp.enable("stylelint_lsp")

            ----------
            --- TS ---
            ----------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua
            --- Installed via `pnpm add -g typescript typescript-language-server`
            lsp.config("ts_ls", {
                init_options = { hostInfo = "neovim" },
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
                root_dir = function(bufnr, on_dir)
                    -- The project root is where the LSP can be started from
                    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
                    -- We select then from the project root, which is identified by the presence of a package
                    -- manager lock file.
                    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                    -- Give the root markers equal priority by wrapping them in a table
                    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })
                    -- We fallback to the current working directory if no project root is found
                    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

                    on_dir(project_root)
                end,
                handlers = {
                    -- handle rename request for certain code actions like extracting functions / types
                    ["_typescript.rename"] = function(_, result, ctx)
                        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
                        vim.lsp.util.show_document({
                            uri = result.textDocument.uri,
                            range = {
                                start = result.position,
                                ["end"] = result.position,
                            },
                        }, client.offset_encoding)
                        vim.lsp.buf.rename()
                        return vim.NIL
                    end,
                },
                commands = {
                    ["editor.action.showReferences"] = function(command, ctx)
                        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
                        local file_uri, position, references = unpack(command.arguments)

                        local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
                        vim.fn.setqflist({}, " ", {
                            title = command.title,
                            items = quickfix_items,
                            context = {
                                command = command,
                                bufnr = ctx.bufnr,
                            },
                        })

                        vim.lsp.util.show_document({
                            uri = file_uri,
                            range = {
                                start = position,
                                ["end"] = position,
                            },
                        }, client.offset_encoding)

                        vim.cmd("botright copen")
                    end,
                },
                on_attach = function(client, bufnr)
                    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
                    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
                    vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
                        local source_actions = vim.tbl_filter(function(action)
                            return vim.startswith(action, "source.")
                        end, client.server_capabilities.codeActionProvider.codeActionKinds)

                        vim.lsp.buf.code_action({
                            context = {
                                only = source_actions,
                            },
                        })
                    end, {})
                end,
            })
            lsp.enable("ts_ls")

            -----------
            --- VTSLS ---
            -----------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/vtsls.lua
            --- Uses a local TS server, but falls back to my global TS install
            --- Installed via `pnpm add -g @vue/language-server`
            lsp.config("vtsls", {
                cmd = { "vtsls", "--stdio" },
                init_options = {
                    hostInfo = "neovim",
                },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                    "vue",
                },
                settings = {
                    vtsls = {
                        tsserver = {
                            globalPlugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location = vim.fn.stdpath("data")
                                        .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
                                    languages = { "vue" },
                                    configNamespace = "typescript",
                                },
                            },
                        },
                    },
                },
                root_dir = function(bufnr, on_dir)
                    -- The project root is where the LSP can be started from
                    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
                    -- We select then from the project root, which is identified by the presence of a package
                    -- manager lock file.
                    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                    -- Give the root markers equal priority by wrapping them in a table
                    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })
                    -- We fallback to the current working directory if no project root is found
                    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

                    on_dir(project_root)
                end,
            })
            lsp.enable("vtsls")

            -----------
            --- VUE ---
            -----------
            --- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/vue_ls.lua
            --- Uses a local TS server, but falls back to my global TS install
            --- Installed via `pnpm add -g @vue/language-server`
            lsp.config("vue_ls", {
                cmd = { "vue-language-server", "--stdio" },
                filetypes = { "vue" },
                root_markers = { "package.json" },
                on_init = function(client)
                    local retries = 0

                    ---@param _ lsp.ResponseError
                    ---@param result any
                    ---@param context lsp.HandlerContext
                    local function typescriptHandler(_, result, context)
                        local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })[1]
                            or vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })[1]
                            or vim.lsp.get_clients({ bufnr = context.bufnr, name = "typescript-tools" })[1]

                        if not ts_client then
                            -- there can sometimes be a short delay until `ts_ls`/`vtsls` are attached so we retry for a few times until it is ready
                            if retries <= 10 then
                                retries = retries + 1
                                vim.defer_fn(function()
                                    typescriptHandler(_, result, context)
                                end, 100)
                            else
                                vim.notify(
                                    "Could not find `ts_ls`, `vtsls`, or `typescript-tools` lsp client required by `vue_ls`.",
                                    vim.log.levels.ERROR
                                )
                            end
                            return
                        end

                        local param = unpack(result)
                        local id, command, payload = unpack(param)
                        ts_client:exec_cmd({
                            title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                            command = "typescript.tsserverRequest",
                            arguments = {
                                command,
                                payload,
                            },
                        }, { bufnr = context.bufnr }, function(_, r)
                            local response_data = { { id, r and r.body } }
                            ---@diagnostic disable-next-line: param-type-mismatch
                            client:notify("tsserver/response", response_data)
                        end)
                    end

                    client.handlers["tsserver/request"] = typescriptHandler
                end,
            })
            lsp.enable("vue_ls")
        end,
    },
}
