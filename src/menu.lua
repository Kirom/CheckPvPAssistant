local _, ns = ...

-- Menu system integration module
ns.menu = {}

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
            return ns.utils.GetNameRealm(searchResultInfo.leaderName)
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
        return ns.utils.GetNameRealm(fullName)
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

    -- Handle LFG list info
    if not contextData then
        local tagType = validTags[rootDescription.tag]
        if tagType == 1 then
            ns.utils.DebugPrint("Data found in LFG list info")
            return GetLFGListInfo(owner)
        end
        return
    end

    local name, realm

    -- Use contextData.name and contextData.server if both are available
    -- This is the most reliable source for cross-realm players
    if contextData.name and contextData.server then
        name = contextData.name
        realm = contextData.server
        ns.utils.DebugPrint("Data found in contextData: name =", name, "server =", realm)
        return name, realm
    end

    -- Handle units (target, party members, etc.)
    local unit = contextData.unit
    if unit and UnitExists(unit) then
        name, realm = ns.utils.GetNameRealm(UnitName(unit))
        -- If we have contextData.server, prefer it over parsed realm
        if contextData.server then
            realm = contextData.server
            ns.utils.DebugPrint("Data found in unit name with contextData server: name =", name, "server =", realm)
        else
            ns.utils.DebugPrint("Data found in unit data: name =", name, "realm =", realm)
        end
        return name, realm
    end

    -- Handle Battle.net friends
    local accountInfo = contextData.accountInfo
    if accountInfo then
        name, realm = GetBNetAccountInfo(accountInfo)
        if not realm then
            return -- Skip if no realm info (classic characters on retail)
        end
        ns.utils.DebugPrint("Data found in BNet friend info: name =", name, "realm =", realm)
        return name, realm
    end

    -- Handle regular name context (fallback)
    if contextData.name then
        name, realm = ns.utils.GetNameRealm(contextData.name)
        ns.utils.DebugPrint("Data found in regular name context: name =", name, "realm =", realm)
        return name, realm
    end

    -- Handle friends list
    if contextData.friendsList then
        local friendInfo = C_FriendList.GetFriendInfoByIndex(contextData.friendsList)
        if friendInfo and friendInfo.name then
            name, realm = ns.utils.GetNameRealm(friendInfo.name)
            ns.utils.DebugPrint("Data found in friends list: name =", name, "realm =", realm)
            return name, realm
        end
    end

    return nil, nil
end

-- Hook into the dropdown menu system
local function AddCheckPvPOption(owner, rootDescription, contextData)
    -- Debug output
    if contextData then
        ns.utils.DebugPrint(
            "contextData.which =", contextData.which, "contextData.unit =", contextData.unit,
            "contextData.name =", contextData.name, "contextData.server =", contextData.server
        )
        if contextData.accountInfo then
            ns.utils.DebugPrint("Found accountInfo =", contextData.accountInfo)
            if contextData.accountInfo.gameAccountInfo then
                local gameInfo = contextData.accountInfo.gameAccountInfo
                ns.utils.DebugPrint(
                    "gameAccountInfo - characterName =", gameInfo.characterName, "realmName =", gameInfo.realmName
                )
            end
        end
        if contextData.friendsList then
            ns.utils.DebugPrint("friendsList index =", contextData.friendsList)
        end
    else
        ns.utils.DebugPrint("No contextData, rootDescription.tag =", rootDescription.tag)
    end

    -- Check if this is a valid menu for our addon
    if not IsValidMenu(rootDescription, contextData) then
        ns.utils.DebugPrint("Menu not valid")
        return
    end

    local name, realm = GetNameRealmForMenu(owner, rootDescription, contextData)
    ns.utils.DebugPrint("Got name =", name, "realm =", realm)

    if name and realm then
        selectedName = name
        selectedRealm = realm
        rootDescription:CreateDivider()
        rootDescription:CreateButton(ns.config.MENU_TEXT, function()
            local url = ns.url.GetCheckPvPURL(selectedName, selectedRealm)
            if url then
                ns.ui.ShowCopyURLDialog(url)
            end
        end)
        ns.utils.DebugPrint("Added menu option for", name, "-", realm)
    else
        ns.utils.DebugPrint("No valid name/realm found - skipping menu option")
    end
end

-- Register menu hooks
function ns.menu.RegisterMenuHooks()
    -- Check if the new Menu system is available (TWW+)
    if Menu and Menu.ModifyMenu then
        local ModifyMenu = Menu.ModifyMenu

        ns.utils.DebugPrint("Menu system found, registering hooks...")

        -- Hook LFG frame menus (most important for our use case)
        local success, err = pcall(function()
            ModifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", ns.utils.GenerateClosure(AddCheckPvPOption))

            -- Hook other player context menus
            ModifyMenu("MENU_UNIT_PLAYER", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_PARTY", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_RAID_PLAYER", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_FRIEND", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_GUILD", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_COMMUNITIES_GUILD_MEMBER", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_COMMUNITIES_WOW_MEMBER", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_BN_FRIEND", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_SELF", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_ENEMY_PLAYER", ns.utils.GenerateClosure(AddCheckPvPOption))
            ModifyMenu("MENU_UNIT_OTHER_PLAYER", ns.utils.GenerateClosure(AddCheckPvPOption))
        end)

        if success then
            ns.utils.DebugPrint("|cff00ff00Check-PvP Assistant|r: Menu hooks registered successfully!")
            return true
        else
            print("|cffff0000Check-PvP Assistant|r: Error registering menu hooks:", err, "Please report this to the developer.")
            return false
        end
    else
        print("|cffff0000Check-PvP Assistant|r: Menu system not available! (WoW version may be too old). Please report this to the developer.")
        return false
    end
end