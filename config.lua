-- CheckPvPAssistant Configuration
-- This file contains user-configurable settings for the addon

local _, ns = ...

-- Create config namespace
ns.config = {}

-- Default configuration values
local defaults = {
    DEBUG = false,                           -- Set to true to enable debug output
}

-- Fixed settings (not user-configurable)
ns.config.MENU_TEXT = "Copy Check-PvP URL"        -- Text shown in context menus
ns.config.DIALOG_TITLE = "Check-PvP URL"          -- Title of the URL dialog
ns.config.BASE_URL = "https://check-pvp.fr"       -- Base URL for Check-PvP website
ns.config.FRAME_STRATA = "DIALOG"                 -- Frame strata for URL dialog
ns.config.FRAME_LEVEL = 100                       -- Frame level for URL dialog

-- Initialize config with defaults
for key, value in pairs(defaults) do
    ns.config[key] = value
end

-- Function to load user settings from saved variables
local function LoadUserConfig()
    if CheckPvPAssistantDB then
        for key, value in pairs(CheckPvPAssistantDB) do
            if defaults[key] ~= nil then  -- Only load known config keys
                ns.config[key] = value
            end
        end
    end
end

-- Function to save user settings to saved variables
function ns.SetConfig(key, value)
    if defaults[key] ~= nil then
        ns.config[key] = value
        CheckPvPAssistantDB = CheckPvPAssistantDB or {}
        CheckPvPAssistantDB[key] = value
    else
        print("|cffff0000CheckPvP Assistant:|r Unknown config key:", key)
    end
end

-- Initialize saved variables and load user config
local configFrame = CreateFrame("Frame")
configFrame:RegisterEvent("ADDON_LOADED")
configFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "CheckPvPAssistant" then
        -- Initialize saved variables if they don't exist
        CheckPvPAssistantDB = CheckPvPAssistantDB or {}
        
        -- Load user configuration
        LoadUserConfig()
        
        configFrame:UnregisterEvent("ADDON_LOADED")
    end
end) 