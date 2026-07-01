-- General Options --
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.autoindent = true
vim.opt.syntax = 'on'
vim.opt.ttyfast = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.winborder = 'rounded'
--vim.opt.cmdheight = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Key Bindings START--
vim.g.mapleader = "\\"
-- toggle the sidebar
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
-- reveal the current file in the tree
vim.keymap.set('n', '<leader>r', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
-- Key Bindings END--


-- pack --
vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin'},
    { src = 'https://github.com/nvim-tree/nvim-tree.lua', version = 'v1.18.0' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons', version = 'master' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    --{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', name = 'nvim-treesitter', version = 'v0.10.0'},
    { src = 'https://github.com/nvim-lualine/lualine.nvim', name = 'lualine'},
})

require('nvim-web-devicons').setup()
require('nvim-tree').setup()
require('catppuccin')
vim.api.nvim_command("colorscheme catppuccin-macchiato")
require('lualine').setup()
--require'nvim-treesitter.configs'.setup {
--  highlight = {
--    enable = true, -- This is the switch that turns on the colors
--  },
--}
-- LSP START --
vim.lsp.log.set_level(vim.log.levels.OFF)
vim.lsp.enable({
    'clangd',
    'gdscript',
    'lua_ls',
    'rust-analyzer',
    'pyright',
    'bashls',
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

            -- keybindings for lsp
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('i', '<C-Space>', function()
                vim.lsp.completion.get()
            end)

            -- end of keybindings for lsp
        end
    end,
})

-- Diagnostics
vim.diagnostic.config({
    -- Use the default configuration
    -- virutal_lines = true

    -- Alternative, customize specific options
    virtual_lines = {
        -- Only show virtual line diagnostics for the current cursor line
        current_line = true,
    },
})
-- LSP END --
