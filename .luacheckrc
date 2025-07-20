-- LuaCheck configuration for CheckPvPAssistant World of Warcraft addon
-- https://luacheck.readthedocs.io/en/stable/

-- Ignore global variable warnings for standard WoW API
std = "lua51"

-- Global variables read/write patterns
globals = {
    -- Addon namespace (read/write)
    "CheckPvPAssistantDB",

    -- Frame and UI API
    "CreateFrame",
    "UIParent",

    -- Unit API
    "UnitName",
    "UnitGUID",
    "GetRealmName",

    -- Event API
    "RegisterEvent",
    "UnregisterEvent",
    "SetScript",

    -- Slash command API
    "SlashCmdList",
    "SLASH_CHECKPVPCONFIG1",
    "SLASH_CHECKPVPCONFIG2",

    -- Menu system API (TWW+)
    "Menu",

    -- WoW-specific constants
    "MENU_LFG_FRAME_SEARCH_ENTRY",
    "MENU_LFG_FRAME_MEMBER_APPLY",
}

-- Read-only globals (WoW API that should not be modified)
read_globals = {
    -- Core WoW API
    "C_LFGList",
    "C_FriendList",
    "UnitExists",
    "GetCurrentRegion",
    "WOW_PROJECT_ID",

    -- Menu constants
    "MENU_UNIT_PLAYER",
    "MENU_UNIT_PARTY",
    "MENU_UNIT_RAID_PLAYER",
    "MENU_UNIT_FRIEND",
    "MENU_UNIT_GUILD",
    "MENU_UNIT_COMMUNITIES_GUILD_MEMBER",
    "MENU_UNIT_COMMUNITIES_WOW_MEMBER",
    "MENU_UNIT_BN_FRIEND",
    "MENU_UNIT_SELF",
    "MENU_UNIT_ENEMY_PLAYER",
    "MENU_UNIT_OTHER_PLAYER",
}

-- Files and directories to check
files = {
    "src/",
}

-- Exclude patterns
exclude_files = {
    "scripts/",
    "assets/",
    "ReleaseNotes/",
    ".git/",
    "*.md",
    "*.txt",
    "*.toc",
    "*.exe",
    "*.sh",
}

-- Maximum line length (increased for WoW addons due to color escape sequences)
max_line_length = 120

-- Lua version
lua_version = "5.1"

-- Format output for better readability
formatter = "TAP"
