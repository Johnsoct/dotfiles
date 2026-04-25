return {
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        config = function()
            require("dap").adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = { "~/.config/nvim/dap-adapters/js-debug/src/dapDebugServer.js", "${port}" },
                }
            }

            require("dap").configurations.javascript = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
            }
        end,
    },
}
