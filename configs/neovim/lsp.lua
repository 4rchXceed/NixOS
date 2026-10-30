local lspconfig = require 'lspconfig'


lspconfig.rust_analyzer.setup({
    cmd = { "nix", "develop", ".", "--command", "rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

lspconfig.pyright.setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities()
})
