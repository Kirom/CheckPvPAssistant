local addonName, ns = ...

local function DebugPrint(...)
    if ns.config.DEBUG then
        print("|cff00ff00CheckPvP:|r", ...)
    end
end

-- Utility functions
local function GetNameRealm(fullName)
    if not fullName then return end
    local name, realm = string.match(fullName, "^([^-]+)-(.+)$")
    if not name then
        name = fullName
        realm = GetRealmName()
    end
    return name, realm
end

-- Region mapping
local REGION_TO_LTD = { "us", "kr", "eu", "tw", "cn" }

local function GetRegion()
    local guid = UnitGUID("player")
    if not guid then
        return "eu", 3 -- fallback
    end
    
    local serverId = tonumber(string.match(guid, "^Player%-(%d+)") or 0) or 0
    local regionId
    
    -- Simple server ID to region mapping
    if serverId >= 1 and serverId <= 300 then
        regionId = 1 -- US
    elseif serverId >= 500 and serverId <= 700 then
        regionId = 3 -- EU
    elseif serverId >= 2000 and serverId <= 2100 then
        regionId = 2 -- KR
    elseif serverId >= 3000 and serverId <= 3100 then
        regionId = 4 -- TW
    elseif serverId >= 4000 and serverId <= 4100 then
        regionId = 5 -- CN
    else
        -- Fallback to GetCurrentRegion() but with correct mapping
        regionId = GetCurrentRegion()
        if not regionId or regionId < 1 or regionId > #REGION_TO_LTD then
            regionId = 3 -- EU fallback
        end
    end
    
    local regionCode = REGION_TO_LTD[regionId] or "eu"
    return regionCode, regionId
end

-- Function to get English realm slug from localized name
local function GetRealmSlug(realm)
    return ns.realmSlugs[realm] or realm
end

local function GetCheckPvPURL(name, realm)
    if not name or not realm then return end
    
    -- Get region
    local regionCode, regionId = GetRegion()
    
    -- Debug output to help troubleshoot
    local guid = UnitGUID("player")
    local serverId = tonumber(string.match(guid or "", "^Player%-(%d+)") or 0) or 0
    DebugPrint("GUID =", guid, "ServerId =", serverId, "RegionId =", regionId, "RegionCode =", regionCode, "Realm =", realm)
    
    -- Translate realm name to English slug - simplified since we have exact matches
    local englishRealm = GetRealmSlug(realm)
    DebugPrint("Realm translation:", realm, "->", englishRealm)

    DebugPrint("Final URL components: region =", regionCode, "realm =", englishRealm, "name =", name)
    
    -- Construct check-pvp.fr URL
    return string.format("%s/%s/%s/%s", ns.config.BASE_URL, regionCode, englishRealm, name)
end

local function ShowCopyURLDialog(url)
    if not url then return end
    
    -- Create a simple frame to display the URL
    local frame = CreateFrame("Frame", "CheckPvPCopyFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(500, 150)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    -- Set high frame strata to appear above LFG windows
    frame:SetFrameStrata(ns.config.FRAME_STRATA)
    frame:SetFrameLevel(ns.config.FRAME_LEVEL)
    
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame.TitleBg, "TOP", 0, -5)
    frame.title:SetText(ns.config.DIALOG_TITLE)
    
    local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetSize(460, 30)
    editBox:SetPoint("CENTER", frame, "CENTER", 0, 10)
    editBox:SetText(url)
    editBox:SetAutoFocus(true)
    editBox:HighlightText()
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    editBox:SetScript("OnEnterPressed", function() frame:Hide() end)
    
    local instruction = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    instruction:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
    instruction:SetText("Press Ctrl+C to copy, then press Enter or Escape to close")
    
    frame:Show()
end

-- Simple closure generator
local function GenerateClosure(func)
    return function(owner, rootDescription, contextData)
        return func(owner, rootDescription, contextData)
    end
end

-- Track selected player for dropdown menus
local selectedName, selectedRealm

-- Valid menu types
local validTags = {
    MENU_LFG_FRAME_SEARCH_ENTRY = 1,
    MENU_LFG_FRAME_MEMBER_APPLY = 1,
}

local validTypes = {
    PLAYER = true,
    PARTY = true,
    RAID_PLAYER = true,
    FRIEND = true,
    GUILD = true,
    COMMUNITIES_GUILD_MEMBER = true,
    COMMUNITIES_WOW_MEMBER = true,
    BN_FRIEND = true,
    SELF = true,
    ENEMY_PLAYER = true,
    OTHER_PLAYER = true,
}

-- Validation function
local function IsValidMenu(rootDescription, contextData)
    if not contextData then
        local tagType = validTags[rootDescription.tag]
        return tagType == 1 -- LFG menus
    end
    local which = contextData.which
    return which and validTypes[which]
end

-- Get name and realm from LFG info
local function GetLFGListInfo(owner)
    local resultID = owner.resultID
    if resultID then
        local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
        if searchResultInfo and searchResultInfo.leaderName then
            return GetNameRealm(searchResultInfo.leaderName)
        end
    end
    
    local memberIdx = owner.memberIdx
    if not memberIdx then
        return
    end
    local parent = owner:GetParent()
    if not parent then
        return
    end
    local applicantID = parent.applicantID
    if not applicantID then
        return
    end
    local fullName = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
    if fullName then
        return GetNameRealm(fullName)
    end
    
    return nil, nil
end

-- Get Battle.net account info
local function GetBNetAccountInfo(accountInfo)
    if not accountInfo or not accountInfo.gameAccountInfo then
        return nil, nil
    end
    
    local gameAccountInfo = accountInfo.gameAccountInfo
    local characterName = gameAccountInfo.characterName
    local realmName = gameAccountInfo.realmName
    local characterLevel = gameAccountInfo.characterLevel
    
    return characterName, realmName, characterLevel
end

-- Get name and realm from menu context
local function GetNameRealmForMenu(owner, rootDescription, contextData)
    if not contextData then
        local tagType = validTags[rootDescription.tag]
        if tagType == 1 then
            return GetLFGListInfo(owner)
        end
        return
    end
    
    local name, realm
    
    -- PRIORITY 1: Use contextData.name and contextData.server if both are available
    -- This is the most reliable source for cross-realm players
    if contextData.name and contextData.server then
        name = contextData.name
        realm = contextData.server
        DebugPrint("Using contextData: name =", name, "server =", realm)
        return name, realm
    end
    
    -- PRIORITY 2: Handle units (target, party members, etc.)
    local unit = contextData.unit
    if unit and UnitExists(unit) then
        name, realm = GetNameRealm(UnitName(unit))
        -- If we have contextData.server, prefer it over parsed realm
        if contextData.server then
            realm = contextData.server
            DebugPrint("Using unit name with contextData server: name =", name, "server =", realm)
        else
            DebugPrint("Using unit data: name =", name, "realm =", realm)
        end
        return name, realm
    end
    
    -- PRIORITY 3: Handle Battle.net friends
    local accountInfo = contextData.accountInfo
    if accountInfo then
        name, realm = GetBNetAccountInfo(accountInfo)
        if not realm then
            return -- Skip if no realm info (classic characters on retail)
        end
        return name, realm
    end
    
    -- PRIORITY 4: Handle regular name context (fallback)
    if contextData.name then
        name, realm = GetNameRealm(contextData.name)
        return name, realm
    end
    
    -- PRIORITY 5: Handle friends list
    if contextData.friendsList then
        local friendInfo = C_FriendList.GetFriendInfoByIndex(contextData.friendsList)
        if friendInfo and friendInfo.name then
            name, realm = GetNameRealm(friendInfo.name)
            return name, realm
        end
    end
    
    return nil, nil
end

-- Hook into the dropdown menu system
local function AddCheckPvPOption(owner, rootDescription, contextData)
    -- Debug output
    if contextData then
        DebugPrint("contextData.which =", contextData.which, "contextData.unit =", contextData.unit, "contextData.name =", contextData.name, "contextData.server =", contextData.server)
        if contextData.accountInfo then
            DebugPrint("Found accountInfo =", contextData.accountInfo)
            if contextData.accountInfo.gameAccountInfo then
                local gameInfo = contextData.accountInfo.gameAccountInfo
                DebugPrint("gameAccountInfo - characterName =", gameInfo.characterName, "realmName =", gameInfo.realmName)
            end
        end
        if contextData.friendsList then
            DebugPrint("friendsList index =", contextData.friendsList)
        end
    else
        DebugPrint("No contextData, rootDescription.tag =", rootDescription.tag)
    end
    
    -- Check if this is a valid menu for our addon
    if not IsValidMenu(rootDescription, contextData) then
        DebugPrint("Menu not valid")
        return
    end
    
    local name, realm = GetNameRealmForMenu(owner, rootDescription, contextData)
    DebugPrint("Got name =", name, "realm =", realm)
    
    if name and realm then
        selectedName = name
        selectedRealm = realm
        rootDescription:CreateDivider()
        rootDescription:CreateButton(ns.config.MENU_TEXT, function()
            local url = GetCheckPvPURL(selectedName, selectedRealm)
            if url then
                ShowCopyURLDialog(url)
            end
        end)
        DebugPrint("Added menu option for", name, "-", realm)
    else
        DebugPrint("No valid name/realm found - skipping menu option")
    end
end

-- Initialize the addon and register menu hooks
local function InitializeAddon()
    DebugPrint("Initializing addon...")
    
    -- Check if the new Menu system is available (TWW+)
    if Menu and Menu.ModifyMenu then
        local ModifyMenu = Menu.ModifyMenu
        
        DebugPrint("Menu system found, registering hooks...")
        
        -- Hook LFG frame menus (most important for our use case)
        local success, err = pcall(function()
            ModifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", GenerateClosure(AddCheckPvPOption))
            
            -- Hook other player context menus
            ModifyMenu("MENU_UNIT_PLAYER", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_PARTY", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_RAID_PLAYER", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_FRIEND", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_GUILD", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_COMMUNITIES_GUILD_MEMBER", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_COMMUNITIES_MEMBER", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_BN_FRIEND", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_SELF", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_ENEMY_PLAYER", GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_OTHER_PLAYER", GenerateClosure(AddCheckPvPOption))
        end)
        
        if success then
            print("|cff00ff00Check-PvP Assistant|r: Menu hooks registered successfully!")
        else
            print("|cffff0000Check-PvP Assistant|r: Error registering menu hooks:", err)
        end
    else
        print("|cffff0000Check-PvP Assistant|r: Menu system not available! (WoW version may be too old)")
    end
end

-- Event handling
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddonName = ...
        if loadedAddonName == addonName then
            InitializeAddon()
        end
    elseif event == "PLAYER_LOGIN" then
        print("|cff00ff00Check-PvP Assistant|r addon loaded successfully!")
    end
end)

-- Slash command for debug toggle
SLASH_CHECKPVPCONFIG1 = "/checkpvp"
SLASH_CHECKPVPCONFIG2 = "/cpvp"
SlashCmdList["CHECKPVPCONFIG"] = function(msg)
    local command = string.match(msg, "^(%S+)")
    
    if not command or command == "" or command == "help" then
        print("|cff00ff00CheckPvP Assistant|r commands:")
        print("  |cffffcc00/checkpvp debug|r - Toggle debug output")
        return
    end
    
    if command == "debug" then
        local value = string.match(msg, "^debug%s+(.+)$")
        -- Toggle debug mode
        local newValue = not ns.config.DEBUG
        ns.SetConfig("DEBUG", newValue)
        print("|cff00ff00CheckPvP Assistant:|r Debug output", newValue and "enabled" or "disabled")
    else
        print("|cffff0000CheckPvP Assistant:|r Unknown command. Use '/checkpvp help' for available commands.")
    end
end


