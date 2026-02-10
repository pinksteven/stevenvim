return {
    {
        "nvim-lspconfig",
        for_cat = "core",
        on_require = { "lspconfig" },
        -- NOTE: define a function for lsp,
        -- and it will run for all specs with type(plugin.lsp) == table
        -- when their filetype trigger loads them
        lsp = function(plugin)
            vim.lsp.config(plugin.name, plugin.lsp or {})
            vim.lsp.enable(plugin.name)
        end,
        before = function(_)
            vim.lsp.config('*', {
                on_attach = require('LSPs.on_attach'),
            })
        end,
    },
    {import = "lua.LSPs.lua"},
    {import = "lua.LSPs.nix"},
}
