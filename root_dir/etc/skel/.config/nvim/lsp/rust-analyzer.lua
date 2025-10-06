return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { ".git" },
    single_file_support = true,
    capabilities = {
        experimental = {
            serverStatusNotification = true
        },
    }
}
