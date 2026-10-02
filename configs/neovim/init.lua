vim.keymap.set("n", "<F2>", function()
    vim.cmd("rightbelow sp term://zsh")
end)

vim.keymap.set("n", "<CTRL-T>", function()
    vim.cmd("tabnew")
end)

vim.keymap.set("n", "<CTRL-G>", function()
    vim.cmd("Gamify")
end)

require("onedark").setup {
    style = "darker"
}

-- https://sharksforarms.dev/posts/neovim-rust/


-- local opts = {
--     tools = {
--         runnables = {
--             use_telescope = true,
--         },
--         inlay_hints = {
--             auto = true,
--             show_parameter_hints = false,
--             parameter_hints_prefix = "",
--             other_hints_prefix = "",
--         },
--     },

-- -- all the opts to send to nvim-lspconfig
-- -- these override the defaults set by rust-tools.nvim
-- -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
-- server = {
--     -- on_attach is a callback called when the language server attachs to the buffer
--     on_attach = on_attach,
--     settings = {
--         -- to enable rust-analyzer settings visit:
--         -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--         ["rust-analyzer"] = {
--             -- enable clippy on save
--             checkOnSave = {
--                 command = "clippy",
--             },
--         },
--     },
-- },
-- }

require 'barbar'.setup {}
require("gamify").setup()
require("power-mode").setup({
    particles = {
        preset = "explosion",
        chars = { "★", "☆", "✡" }, -- Custom chars with explosion physics
        count = { 10, 15 }, -- More particles
    },
    combo = {
        shake = false,
    },
})
local keymap_opts = { buffer = buffer }
-- Code navigation and shortcuts
vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)

-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 100

-- Show diagnostic popup on cursor hover
local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = diag_float_grp,
})

-- Goto previous/next diagnostic warning/error
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)

-- Yeah, did not found a better way to do it
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    command = "silent! NERDTreeMirror"
})
