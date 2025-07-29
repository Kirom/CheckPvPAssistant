local _, ns = ...

-- URL generation module
ns.url = {}

-- Generate Check-PvP URL for a player
function ns.url.GetFullURLFormat(name, realm)
    if not name or not realm then return end

    -- Get region
    local regionCode, regionId = ns.region.GetRegion()

    -- Debug output to help troubleshoot
    local guid = UnitGUID("player")
    local serverId = tonumber(string.match(guid or "", "^Player%-(%d+)") or 0) or 0
    ns.utils.DebugPrint(
        "GUID =", guid, "ServerId =", serverId, "RegionId =", regionId,
        "RegionCode =", regionCode, "Realm =", realm, "Name =", name
    )

    -- Translate realm name to English slug - simplified since we have exact matches
    local englishRealm = ns.region.GetRealmSlug(realm)
    ns.utils.DebugPrint("Realm translation:", realm, "->", englishRealm)

    ns.utils.DebugPrint("Final URL components: region =", regionCode, "realm =", englishRealm, "name =", name)

    -- Construct check-pvp.fr URL
    return string.format("%s/%s/%s/%s", ns.config.BASE_URL, regionCode, englishRealm, name)
end

-- Generate name-realm for a player
function ns.url.GetNameRealmFormat(name, realm)
    if not name or not realm then return end

    -- Debug output to help troubleshoot
    local guid = UnitGUID("player")
    local serverId = tonumber(string.match(guid or "", "^Player%-(%d+)") or 0) or 0
    ns.utils.DebugPrint(
        "GUID =", guid, "ServerId =", serverId, "Realm =", realm, "Name =", name
    )

    -- Translate realm name to English slug - simplified since we have exact matches
    local englishRealm = ns.region.GetRealmSlug(realm)
    ns.utils.DebugPrint("Realm translation:", realm, "->", englishRealm)

    ns.utils.DebugPrint("Final name-realm: name =", name, "realm =", englishRealm)

    return string.format("%s-%s", name, englishRealm)
end

-- Get the appropriate format based on current copy mode
function ns.url.GetCopyText(name, realm)
    if not name or not realm then return end

    if ns.config.COPY_MODE == "name" then
        return ns.url.GetNameRealmFormat(name, realm)
    else
        return ns.url.GetFullURLFormat(name, realm)
    end
end