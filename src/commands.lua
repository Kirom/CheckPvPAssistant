local _, ns = ...

-- Commands module
ns.commands = {}

-- Slash command handler
local function HandleSlashCommand(msg)
    local command = string.match(msg, "^(%S+)")

    if not command or command == "" or command == "help" then
        print("|cff00ff00CheckPvP Assistant|r commands:")
        print("  |cffffcc00/checkpvp debug|r - Toggle debug output")
        return
    end

    if command == "debug" then
        -- Toggle debug mode
        local newValue = not ns.config.DEBUG
        ns.SetConfig("DEBUG", newValue)
        print("|cff00ff00CheckPvP Assistant:|r Debug output", newValue and "enabled" or "disabled")
    else
        print("|cffff0000CheckPvP Assistant:|r Unknown command. Use '/checkpvp help' for available commands.")
    end
end

-- Register slash commands
function ns.commands.RegisterSlashCommands()
    SLASH_CHECKPVPCONFIG1 = "/checkpvp"
    SLASH_CHECKPVPCONFIG2 = "/cpvp"
    SlashCmdList["CHECKPVPCONFIG"] = HandleSlashCommand
end