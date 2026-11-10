return {
    cmd = { "qmlls" },
    -- symlink the /usr/lib/qt6/bin/qmlls to /usr/local/bin/ or it won't work in void linux --
    filetypes = { "qml", "qmljs" },
    root_markers = { ".git", ".qmlls.ini", "CMakeLists.txt" },
    single_file_support = true,
    capabilities = {
        experimental = {
            serverStatusNotification = true
        },
    }
}
