local _, ns = ...

-- Commands module
ns.commands = {}

-- Slash command handler
local function HandleSlashCommand(msg)
    local command = string.match(msg, "^(%S+)")

    if not command or command == "" or command == "help" then
        print("|cff00ff00CheckPvP Assistant|r commands:")
        print("  |cffffcc00/checkpvp debug|r - Toggle debug output")
        print("  |cffffcc00/checkpvp useurl|r - Copy full URLs")
        print("  |cffffcc00/checkpvp usename|r - Copy name-realm (default)")
        print("  |cffffcc00/checkpvp mode|r - Show current copy mode")
        print("  |cffffcc00/checkpvp autoclose|r - Toggle auto-close dialog after copy")
        return
    end

    if command == "debug" then
        -- Toggle debug mode
        local newValue = not ns.config.DEBUG
        ns.SetConfig("DEBUG", newValue)
        print("|cff00ff00CheckPvP Assistant:|r Debug output", newValue and "enabled" or "disabled")
    elseif command == "useurl" then
        -- Set copy mode to URL
        ns.SetConfig("COPY_MODE", "url")
        print("|cff00ff00CheckPvP Assistant:|r Now copying full URLs.")
    elseif command == "usename" then
        -- Set copy mode to name-realm
        ns.SetConfig("COPY_MODE", "name")
        print("|cff00ff00CheckPvP Assistant:|r Now copying name-realm.")
    elseif command == "mode" then
        -- Show current copy mode
        local currentMode = ns.config.COPY_MODE
        local modeText = currentMode == "name" and "name-realm" or "full URL"
        print("|cff00ff00CheckPvP Assistant:|r Current copy mode: " .. modeText)
        print("  Use |cffffcc00/checkpvp useurl|r or |cffffcc00/checkpvp usename|r to change")
    elseif command == "autoclose" then
        -- Toggle auto-close dialog behavior
        local newValue = not ns.config.AUTO_CLOSE_DIALOG
        ns.SetConfig("AUTO_CLOSE_DIALOG", newValue)
        print("|cff00ff00CheckPvP Assistant:|r Auto-close dialog after copy", newValue and "enabled" or "disabled")
    elseif command == "realms" then  -- TODO: Remove this command once MoP Classic is tested after release
        -- Show current realms
        local realms = ns.realmSlugs
        print("|cff00ff00CheckPvP Assistant:|r Current realms:")
        for realm, slug in pairs(realms) do
            print("  " .. realm .. " - " .. slug)
        end
    elseif command == "regions" then  -- TODO: Remove this command once MoP Classic is tested after release
        -- Show current regions
        local regions = ns.regionIDs
        print("|cff00ff00CheckPvP Assistant:|r Current regions:")
        for region, id in pairs(regions) do
            print("  " .. region .. " - " .. id)
        end
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