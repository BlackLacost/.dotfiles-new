for _, app in ipairs {
    { shortcut = "1", name = "WezTerm" },
    { shortcut = "2", name = "Brave Browser" },
    { shortcut = "3", name = "Todoist" },
    { shortcut = "4", name = "Obsidian" },
    { shortcut = "5", name = "IntelliJ IDEA" },
    { shortcut = "6", name = "Anki" },
    { shortcut = "7", name = "Streisand" },
    { shortcut = "8", name = "Telegram" },
    { shortcut = "9", name = "Calendar" },
    { shortcut = "0", name = "Mail" },
} do
    hs.hotkey.bind({ "alt" }, app.shortcut, function()
        hs.application.launchOrFocus(app.name)
    end)
end
