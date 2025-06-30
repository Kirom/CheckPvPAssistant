local addonName, ns = ...

-- CheckPvPAssistant Core - Main initialization and coordination
-- This file coordinates all addon modules and handles initialization

-- Initialize all addon components
local function Initialize()
    -- Register slash commands
    ns.commands.RegisterSlashCommands()
    
    -- Initialize event handling
    ns.events.Initialize()
end

-- Start initialization
Initialize()


