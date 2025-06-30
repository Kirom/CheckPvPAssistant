# CheckPvPAssistant

A World of Warcraft addon that adds convenient access to [Check-PvP.fr](https://check-pvp.fr) player profiles through right-click context menus.

## Features

- **Right-click integration**: Access Check-PvP URLs directly from player context menus
- **Comprehensive coverage**: Works on targets, party members, raid members, guild members, friends, enemies, and yourself
- **LFG integration**: Generate URLs for players in LFG search results and applicants
- **Cross-realm support**: Properly handles players from different realms
- **Region detection**: Automatically detects your region (US, EU, KR, TW, CN)
- **Realm translation**: Converts internal realm names to Check-PvP.fr format

## Installation

### Manual Installation
1. Download the latest release
2. Extract the `CheckPvPAssistant` folder to your WoW AddOns directory:
   - **Windows**: `World of Warcraft\_retail_\Interface\AddOns\`
   - **Mac**: `Applications/World of Warcraft/_retail_/Interface/AddOns/`
3. Restart World of Warcraft or reload your UI (`/reload`)

### CurseForge/Wago/WowUp
*Coming soon*

## Usage

1. **Right-click on any player** (target, party member, raid member, guild member, friend, enemy, or yourself)
2. Look for **"Copy Check-PvP URL"** in the context menu
3. **Click the option** to open a dialog with the Check-PvP.fr URL
4. **Press Ctrl+C** to copy the URL to your clipboard
5. **Press Enter or Escape** to close the dialog
6. Open the URL in your browser to view the player's PvP statistics

> **Note**: If the website shows "character not found" (e.g., "Tripitropa - Silvermoon is not found Reason: The character doesn't exist"), you can manually search (this will fetch the latest data) for the character on the website using the name and realm from the error message. Simply copy the name and realm from the error message and paste them into the search bar on the website.

### Known Issues

- Only EU region was tested, other regions need to be tested.

### Supported Contexts

- Target players
- Party members
- Raid members
- Guild members
- Friends list
- Battle.net friends
- Enemy players
- Other players
- LFG search results
- LFG applicants
- Your own character

## Requirements

- **World of Warcraft**: The War Within (11.0+) or later
- **Menu System**: Uses the new Menu API introduced in TWW

## Configuration

The addon has a simple debug mode that can be toggled using slash commands:

### Slash Commands

- `/checkpvp` or `/cpvp` - Show available commands
- `/checkpvp debug` - Toggle debug output

### Examples

```
/checkpvp debug        # Toggle debug mode
```

Debug setting is automatically saved and will persist between game sessions.

## Technical Details

### Region Detection
The addon uses the same region detection method as RaiderIO, analyzing your character's GUID to determine the correct region for URL generation.

### Realm Name Translation
Realm names are automatically translated from WoW's internal format to Check-PvP.fr's expected format:
- Spaces are added where appropriate (`AeriePeak` → `Aerie Peak`)
- Special characters are handled (`Blade'sEdge` → `Blades Edge`)
- Capitalization is preserved

## Development

### Project Structure
```
CheckPvPAssistant/
├── CheckPvPAssistant.toc    # Addon metadata
├── core.lua                 # Main addon logic
├── db_realms.lua           # Realm name translations
```

### Debug Mode
Enable debug output by setting `DEBUG = true` in `core.lua`. This will show detailed information about:
- Region detection
- Realm translation
- Menu context data
- URL generation

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

- **Issues**: Report bugs or request features on [GitHub Issues](https://github.com/Kirom/CheckPvPAssistant/issues)
- **Discord**: TBA

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of all changes and updates. 