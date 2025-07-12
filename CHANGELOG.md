# Changelog

All notable changes to CheckPvPAssistant will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-07-10

### Added
- **Addon icon** - Added visual icon for the addon (assets/images/addon-icon.png)
- **BigWigs packager integration** - Switched to industry-standard BigWigsMods/packager@v2 for robust addon releases

### Changed
- **Improved release workflow** - Replaced custom 188-line release workflow with simplified 25-line BigWigs packager
- **Automatic platform distribution** - Now automatically publishes to CurseForge, Wago.io, and GitHub with proper game version mapping
- **Enhanced changelog handling** - Automatic extraction of version-specific changelog sections for release notes
- **Improved error messages** - Refactored error messages in menu.lua for better readability and 120-character line formatting
- **Enhanced debug output** - Improved debug information in menu.lua and utils.lua for better traceability when retrieving player names and realms

### Fixed
- **🔧 CRITICAL: Realm name formatting corrections** - Fixed realm database (db_realms.lua) to preserve special characters (apostrophes, parentheses) in realm names:
  - `Aggra(Português)` now correctly mapped (was causing 404 errors)
  - `Ahn'Qiraj`, `Al'Akir`, `Al'ar` now preserve apostrophes
  - `Blade's Edge` now correctly formatted
  - Over 100+ realm names corrected for accurate Check-PvP URL generation
  - **This fixes 404 errors when accessing Check-PvP URLs for characters on realms with special characters**
- **CurseForge upload errors** - Fixed "Invalid game version ID" errors by implementing proper game version mapping
- **Pipeline reliability** - Enhanced GitHub Actions workflow with better error handling and validation

## [1.0.0] - 2025-07-01

### Added
- **Initial release** of CheckPvPAssistant addon
- **Right-click context menu integration** - "Copy Check-PvP URL" option in player dropdown menus
- **Universal player support** - Works with LFG menu, targets, party members, raid members, guild members, friends, enemies, and yourself
- **LFG integration** - Support for LFG search results and applicants
- **Automatic region detection** - Detects US, EU, KR, TW, CN regions automatically using character GUID analysis
- **Comprehensive realm support** - Database with 1000+ realm name translations from WoW internal format to Check-PvP.fr format
- **Cross-realm player support** - Properly handles players from different realms
- **Battle.net friends support** - Works with Battle.net friends across different realms
- **Copy URL dialog** - Clean, user-friendly dialog for copying URLs to clipboard
- **Slash command system** - `/checkpvp` and `/cpvp` commands for configuration
- **Debug mode** - Toggle debug output for troubleshooting (`/checkpvp debug`)
- **Persistent settings** - Debug preferences saved between game sessions
- **Multiple menu contexts supported**:
  - Guild members (guild roster)
  - Community members (community member list)
  - LFG creators (group leaders in LFG browser)
  - LFG seekers (players looking for groups)
  - Target players (any targeted player)
  - Party members (party frames)
  - Raid members (raid frames)
  - Friends list (regular friends)
  - Battle.net friends (cross-realm friends)
  - Enemy players (opposing faction)
  - Self (your own character)

### Technical Features
- **Menu API integration** - Uses new TWW Menu system for context menu hooks
- **Comprehensive validation** - Input validation and menu context checking

### Requirements
- World of Warcraft: The War Within (11.1.7)
- Uses the new Menu API introduced in TWW

### Known Issues
- Only EU, US, TW regions have been thoroughly tested; KR and CN regions need additional testing

---

## Release Notes

For detailed release notes, see the individual version files in the `ReleaseNotes/` directory. 