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
                "python-lsp-server",
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

                -- Taken from lsp/ts_ls.lua to handle simple projects and monorepos.
                root_dir = function(bufnr, on_dir)
                    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                    -- Give the root markers equal priority by wrapping them in a table
                    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })
                    -- We fallback to the current working directory if no project root is found
                    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

                    on_dir(project_root)
                end,

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
            local root_markers1 = {
                ".emmyrc.json",
                ".luarc.json",
                ".luarc.jsonc",
            }
            local root_markers2 = {
                ".luacheckrc",
                ".stylua.toml",
                "stylua.toml",
                "selene.toml",
                "selene.yml",
            }

            ---@type vim.lsp.Config
            lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2, { ".git" } }
                    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { ".git" }),
                ---@type lspconfig.settings.lua_ls
                settings = {
                    Lua = {
                        codeLens = { enable = true },
                        hint = { enable = true, semicolon = "Disable" },
                    },
                },
            })
            lsp.enable("lua_ls")

            ----------------
            --- MARKSMAN ---
            ----------------
            --- https://github.com/artempyanykh/marksman
            lsp.config("marksman", {
                cmd = { "marksman", "server" },
                filetypes = { "markdown", "markdown.mdx" },
                root_markers = {
                    ".marksman.toml",
                    ".git",
                },
            })
            lsp.enable("marksman")

            ----------------
            ---- PYTHON ----
            ----------------
            --- https://github.com/microsoft/pyright

            local function set_python_path(command)
                local path = command.args
                local clients = vim.lsp.get_clients({
                    bufnr = vim.api.nvim_get_current_buf(),
                    name = "pyright",
                })
                for _, client in ipairs(clients) do
                    if client.settings then
                        client.settings.python =
                            vim.tbl_deep_extend("force", client.settings.python --[[@as table]], { pythonPath = path })
                    else
                        client.config.settings =
                            vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
                    end
                    client:notify("workspace/didChangeConfiguration", { settings = nil })
                end
            end

            ---@type vim.lsp.Config
            lsp.config("pyright", {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                root_markers = {
                    "pyrightconfig.json",
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    ".git",
                },
                ---@type lspconfig.settings.pyright
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
                        local params = {
                            command = "pyright.organizeimports",
                            arguments = { vim.uri_from_bufnr(bufnr) },
                        }

                        -- Using client.request() directly because "pyright.organizeimports" is private
                        -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
                        -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
                        ---@diagnostic disable-next-line: param-type-mismatch
                        client.request("workspace/executeCommand", params, nil, bufnr)
                    end, {
                        desc = "Organize Imports",
                    })
                    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
                        desc = "Reconfigure pyright with the provided python path",
                        nargs = 1,
                        complete = "file",
                    })
                end,
            })
            lsp.enable("pyright")

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
            --- https://github.com/stylelint/vscode-stylelint/tree/main/packages/language-server

            local util = require("lspconfig.util")
            local stylelint_config_files = {
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

            ---@type vim.lsp.Config
            lsp.config("stylelint_lsp", {
                cmd = { "stylelint-language-server", "--stdio" },
                filetypes = {
                    "astro",
                    "css",
                    "html",
                    "less",
                    "scss",
                    "vue",
                },
                root_dir = function(bufnr, on_dir)
                    -- The project root is where the LSP can be started from
                    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
                    -- We select then from the project root, which is identified by the presence of a package
                    -- manager lock file.
                    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                    -- Give the root markers equal priority by wrapping them in a table
                    root_markers = vim.fn.has("nvim-0.12.0") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })

                    -- exclude deno
                    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
                        return
                    end

                    -- We fallback to the current working directory if no project root is found
                    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

                    -- We know that the buffer is using Stylelint if it has a config file
                    -- in its directory tree.
                    --
                    -- Stylelint support package.json files as config files.
                    local filename = vim.api.nvim_buf_get_name(bufnr)
                    local stylelint_config_files_with_package_json =
                        util.insert_package_json(stylelint_config_files, "stylelintConfig", filename)
                    local is_buffer_using_stylelint = vim.fs.find(stylelint_config_files_with_package_json, {
                        path = filename,
                        type = "file",
                        limit = 1,
                        upward = true,
                        stop = vim.fs.dirname(project_root),
                    })[1]
                    if not is_buffer_using_stylelint then
                        return
                    end

                    on_dir(project_root)
                end,
                on_attach = function(client, bufnr)
                    vim.api.nvim_buf_create_user_command(bufnr, "LspStylelintFixAll", function()
                        client:request_sync("workspace/executeCommand", {
                            command = "stylelint.applyAutoFix",
                            arguments = {
                                {
                                    uri = vim.uri_from_bufnr(bufnr),
                                    version = lsp.util.buf_versions[bufnr],
                                },
                            },
                        }, nil, bufnr)
                    end, {})
                end,
                -- Refer to https://github.com/stylelint/vscode-stylelint?tab=readme-ov-file#extension-settings for documentation.
                ---@type lspconfig.settings.stylelint_language_server
                -- settings = {
                --     stylelint = {
                -- snippet = {
                --     "css",
                --     "scss",
                --     "vue",
                -- },
                -- validate = {
                --     "css",
                --     "scss",
                --     "vue",
                -- },
                --     }
                -- },
            })
            lsp.enable("stylelint_lsp")

            ----------
            --- TS ---
            ----------
            --- https://github.com/typescript-language-server/typescript-language-server
            ---
            --- `ts_ls`, aka `typescript-language-server`, is a Language Server Protocol implementation for TypeScript wrapping `tsserver`. Note that `ts_ls` is not `tsserver`.
            ---
            --- `typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
            --- ```sh
            --- npm install -g typescript typescript-language-server
            --- ```
            ---
            --- To configure typescript language server, add a
            --- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
            --- [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
            --- project.
            ---
            --- Here's an example that disables type checking in JavaScript files.
            ---
            --- ```json
            --- {
            ---   "compilerOptions": {
            ---     "module": "commonjs",
            ---     "target": "es6",
            ---     "checkJs": false
            ---   },
            ---   "exclude": [
            ---     "node_modules"
            ---   ]
            --- }
            --- ```
            ---
            --- Use the `:LspTypescriptSourceAction` command to see "whole file" ("source") code-actions such as:
            --- - organize imports
            --- - remove unused code
            ---
            --- Use the `:LspTypescriptGoToSourceDefinition` command to navigate to the source definition of a symbol (e.g., jump to the original implementation instead of type definitions).
            ---
            --- ### Monorepo support
            ---
            --- `ts_ls` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
            --- This works without the need of spawning multiple instances of `ts_ls`, saving memory.
            ---
            --- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.
            ---
            --- Some care must be taken here to correctly infer whether a file is part of a Deno program, or a TS program that
            --- expects to run in Node or Web Browsers. This supports having a Deno module using the denols LSP as a part of a
            --- mostly-not-Deno monorepo. We do this by finding the nearest package manager lock file, and the nearest deno.json
            --- or deno.jsonc.
            ---
            --- Example:
            ---
            --- ```
            --- project-root
            --- +-- node_modules/...
            --- +-- package-lock.json
            --- +-- package.json
            --- +-- packages
            ---     +-- deno-module
            ---     |   +-- deno.json
            ---     |   +-- package.json <-- It's normal for Deno projects to have package.json files!
            ---     |   +-- src
            ---     |       +-- index.ts <-- this is a Deno file
            ---     +-- node-module
            ---         +-- package.json
            ---         +-- src
            ---             +-- index.ts <-- a non-Deno file (ie, should use ts_ls or tsgols)
            --- ```
            ---
            --- From the file being edited, we walk up to find the nearest package manager lockfile. This is PROJECT ROOT.
            --- From the file being edited, find the nearest deno.json or deno.jsonc. This is DENO ROOT.
            --- From the file being edited, find the nearest deno.lock. This is DENO LOCK ROOT
            --- If DENO LOCK ROOT is found, and PROJECT ROOT is missing or shorter, then this is a deno file, and we abort.
            --- If DENO ROOT is found, and it's longer than or equal to PROJECT ROOT, then this is a Deno file, and we abort.
            --- Otherwise, attach at PROJECT ROOT, or the cwd if not found.

            ---@type vim.lsp.Config
            lsp.config("ts_ls", {
                init_options = { hostInfo = "neovim" },
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                },
                root_dir = function(bufnr, on_dir)
                    -- The project root is where the LSP can be started from
                    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
                    -- We select then from the project root, which is identified by the presence of a package
                    -- manager lock file.
                    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                    -- Give the root markers equal priority by wrapping them in a table
                    root_markers = vim.fn.has("nvim-0.12.0") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })
                    -- exclude deno
                    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
                    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
                    local project_root = vim.fs.root(bufnr, root_markers)
                    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
                        -- deno lock is closer than package manager lock, abort
                        return
                    end
                    if deno_root and (not project_root or #deno_root >= #project_root) then
                        -- deno config is closer than or equal to package manager lock, abort
                        return
                    end
                    -- project is standard TS, not deno
                    -- We fallback to the current working directory if no project root is found
                    on_dir(project_root or vim.fn.getcwd())
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

                        local quickfix_items =
                            vim.lsp.util.locations_to_items(references --[[@as any]], client.offset_encoding)
                        vim.fn.setqflist({}, " ", {
                            title = command.title,
                            items = quickfix_items,
                            context = {
                                command = command,
                                bufnr = ctx.bufnr,
                            },
                        })

                        vim.lsp.util.show_document({
                            uri = file_uri --[[@as string]],
                            range = {
                                start = position --[[@as lsp.Position]],
                                ["end"] = position --[[@as lsp.Position]],
                            },
                        }, client.offset_encoding)
                        ---@diagnostic enable: assign-type-mismatch

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
                                diagnostics = {},
                            },
                        })
                    end, {})

                    -- Go to source definition command
                    vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptGoToSourceDefinition", function()
                        local win = vim.api.nvim_get_current_win()
                        local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
                        client:exec_cmd({
                            command = "_typescript.goToSourceDefinition",
                            title = "Go to source definition",
                            arguments = { params.textDocument.uri, params.position },
                        }, { bufnr = bufnr }, function(err, result)
                            if err then
                                vim.notify("Go to source definition failed: " .. err.message, vim.log.levels.ERROR)
                                return
                            end
                            if not result or vim.tbl_isempty(result) then
                                vim.notify("No source definition found", vim.log.levels.INFO)
                                return
                            end
                            vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
                        end)
                    end, { desc = "Go to source definition" })
                end,
            })
            -- lsp.enable("ts_ls")

            -----------
            --- VTS ---
            -----------
            --- https://github.com/yioneko/vtsls
            ---
            --- `vtsls` can be installed with npm:
            --- ```sh
            --- npm install -g @vtsls/language-server
            --- ```
            ---
            --- To configure a TypeScript project, add a
            --- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
            --- or [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to
            --- the root of your project.
            ---
            --- ### Vue support
            ---
            --- Since v3.0.0, the Vue language server requires `vtsls` to support TypeScript.
            ---
            --- ```
            --- -- If you are using mason.nvim, you can get the ts_plugin_path like this
            --- -- For Mason v1,
            --- -- local mason_registry = require('mason-registry')
            --- -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
            --- -- For Mason v2,
            --- -- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
            --- -- or even
            --- -- local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
            --- local vue_language_server_path = '/path/to/@vue/language-server'
            --- local vue_plugin = {
            ---   name = '@vue/typescript-plugin',
            ---   location = vue_language_server_path,
            ---   languages = { 'vue' },
            ---   configNamespace = 'typescript',
            --- }
            --- vim.lsp.config('vtsls', {
            ---   settings = {
            ---     vtsls = {
            ---       tsserver = {
            ---         globalPlugins = {
            ---           vue_plugin,
            ---         },
            ---       },
            ---     },
            ---   },
            ---   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
            --- })
            --- ```
            ---
            --- - `location` MUST be defined. If the plugin is installed in `node_modules`, `location` can have any value.
            --- - `languages` must include vue even if it is listed in filetypes.
            --- - `filetypes` is extended here to include Vue SFC.
            ---
            --- You must make sure the Vue language server is setup. For example,
            ---
            --- ```
            --- vim.lsp.enable('vue_ls')
            --- ```
            ---
            --- See `vue_ls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.
            ---
            --- ### Monorepo support
            ---
            --- `vtsls` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
            --- This works without the need of spawning multiple instances of `vtsls`, saving memory.
            ---
            --- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.
            ---
            --- This includes the same Deno-excluding logic from `ts_ls`. It is not recommended to enable both `vtsls` and `ts_ls` at the same time!

            local vue_language_server_path = vim.fn.stdpath("data")
                .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
            local vue_plugin = {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript",
            }
            ---@type vim.lsp.Config
            lsp.config("vtsls", {
                cmd = { "vtsls", "--stdio" },
                init_options = {
                    hostInfo = "neovim",
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "vue",
                },
                root_dir = function(bufnr, on_dir)
                    -- The project root is where the LSP can be started from
                    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
                    -- We select then from the project root, which is identified by the presence of a package
                    -- manager lock file.
                    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                    -- Give the root markers equal priority by wrapping them in a table
                    root_markers = vim.fn.has("nvim-0.12.0") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })
                    -- exclude deno
                    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
                    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
                    local project_root = vim.fs.root(bufnr, root_markers)
                    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
                        -- deno lock is closer than package manager lock, abort
                        return
                    end
                    if deno_root and (not project_root or #deno_root >= #project_root) then
                        -- deno config is closer than or equal to package manager lock, abort
                        return
                    end
                    -- project is standard TS, not deno
                    -- We fallback to the current working directory if no project root is found
                    on_dir(project_root or vim.fn.getcwd())
                end,

                settings = {
                    vtsls = {
                        tsserver = {
                            globalPlugins = {
                                vue_plugin,
                            },
                        },
                    },
                },
            })
            lsp.enable("vtsls")

            -----------
            --- VUE ---
            -----------
            --- https://github.com/vuejs/language-tools/tree/master/packages/language-server
            ---
            --- The official language server for Vue
            ---
            --- It can be installed via npm:
            --- ```sh
            --- npm install -g @vue/language-server
            --- ```
            ---
            --- The language server only supports Vue 3 projects by default.
            --- For Vue 2 projects, [additional configuration](https://github.com/vuejs/language-tools/blob/master/extensions/vscode/README.md?plain=1#L19) are required.
            ---
            --- The Vue language server works in "hybrid mode" that exclusively manages the CSS/HTML sections.
            --- You need the `vtsls` server with the `@vue/typescript-plugin` plugin to support TypeScript in `.vue` files.
            --- See `vtsls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.
            ---
            --- NOTE: Since v3.0.0, the Vue Language Server [no longer supports takeover mode](https://github.com/vuejs/language-tools/pull/5248).

            ---@type vim.lsp.Config
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
