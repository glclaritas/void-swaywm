return {
    -- Command and args to start the server
    cmd = { "lua-language-server" },

    -- Filetypes to automatically attach to.
    filetypes = { "lua" },

    -- Sets the "root directory" to the partent directory if the file in the
    -- current buffer that containers either a ".luarc.json" or a
    -- ".luarc.jsonc" file. FIles that share a root directory will reuse
    -- the connection to the same LSP server.
    -- Nested lists indicates equal priority, see |vim.lsp.config|.
    root_markers = {  ".luarc.json", ".luarc.jsonc" , ".git" },

    -- Specific settings to send to the server. THe schema for this is
    -- defined by the server. For example, the schema for lua-language-server
    -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/settings/schema.
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the 'vim' global
                globals = { 'vim' },
            },
        }
    },
    single_file_support = true,
}
