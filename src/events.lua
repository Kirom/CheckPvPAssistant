local addonName, ns = ...

-- Event handling module
ns.events = {}

-- Event frame
local eventFrame = CreateFrame("Frame")

-- Initialize the addon
local function InitializeAddon()
    ns.utils.DebugPrint("Initializing addon...")
    ns.menu.RegisterMenuHooks()
end

-- Event handling function
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddonName = ...
        if loadedAddonName == addonName then
            InitializeAddon()
        end
    elseif event == "PLAYER_LOGIN" then
        print("|cff00ff00Check-PvP Assistant|r addon loaded successfully!")
    end
end

-- Register events and set up event handling
function ns.events.Initialize()
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:RegisterEvent("PLAYER_LOGIN")
    eventFrame:SetScript("OnEvent", OnEvent)
end 