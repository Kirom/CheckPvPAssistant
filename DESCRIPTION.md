# Check-PvP Assistant

A World of Warcraft addon that adds convenient access to [Check-PvP.fr](https://check-pvp.fr/) player profiles through right-click context menus. Supports LFG search results and applicants.

**NEW in v1.2.0: Complete Mists of Pandaria Classic support!** The addon now works seamlessly across both Retail and MoP Classic with automatic version detection.


## 🎯 Key Features

*   **Right-click integration**: Access Check-PvP through "Check PvP" context menu option
*   **Comprehensive coverage**: Works on LFG menu, targets, party members, raid members, guild members, friends, enemies, and yourself
*   **LFG integration**: Generate URLs for players in LFG search results and applicants
*   **Cross-realm support**: Properly handles players from different realms
*   **Region detection**: Automatically detects your region (US, EU, KR, TW, CN)
*   **Realm translation**: Converts internal realm names to Check-PvP.fr format
*   **Dual Copy Modes**: Switch between name-realm format (default) and full URL copying
*   **Persistent settings**: Your copy mode preference is saved between sessions
*   **Version-Specific URLs**: Automatically uses the correct Check-PvP URL for your game version

### **Available Slash Commands**

*   `/checkpvp usename` - Switch to name-realm format copying (default)
*   `/checkpvp useurl` - Switch to URL copying
*   `/checkpvp mode` - Show current copy mode

## Usage

1.  **Right-click on any player** (target, party member, raid member, guild member, friend, enemy, or yourself)
2.  Look for **"Check PvP"** in the context menu
3.  **Click the option** to open a dialog with either name-realm format or Check-PvP.fr URL (depending on your mode)
4.  **Press Ctrl+C** to copy the text to your clipboard
5.  **Press Enter or Escape** to close the dialog
6.  **Use the copied content**:
    *   **Name-Realm mode**: Paste into Check-PvP.fr search bar or use in Discord/chat for example
    *   **URL mode**: Open directly in your browser

## Screenshots & Examples

### Basic Usage Example

**Step 1: Right-click on your character**

![Self Example](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/self-example.png)

_Right-click on your character to see the "Check PvP" option in the context menu_

**Step 2: Check PvP Dialog appears**

The dialog that appears depends on your current copy mode:

**Name-Realm Mode (default):**

![Name-Realm Dialog](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/copy-name-realm-dialog.png)

_Dialog showing name-realm format ready to copy (Press Ctrl+C to copy)_

**URL Mode:**

![URL Dialog](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/copy-url-dialog.png)

_Dialog showing Check-PvP.fr URL ready to copy (Press Ctrl+C to copy)_

**Step 3: Using the copied content**

*   **If in Name-Realm mode**: Use the "PlayerName-RealmName" format to paste into website search bar and open character profile
*   **If in URL mode**: Open the URL in your browser to view character profile

![Successful Website Result](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/website-success-example.png) _Example of Check-PvP.fr showing player's PvP statistics and profile_

### Character Not Found - Step by Step Fix

If the website shows "character not found", you can manually search for them (this will fetch the latest data on the website and make the profile appear):

**Step 1: Character Not Found Error** ![Website Error](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/website-fail-example.png) _The error message when a character is not initially found_

**Step 2: Copy Character Information** ![Copy Character Info](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/website-fail-example-step-1.png) _Copy the character name and realm from the error message_

**Step 3: Manual Search** ![Manual Search](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/website-fail-example-step-2.png) _Paste the information into the search bar and search manually_

**Step 4: Character Found** ![Character Found](https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/website-fail-example-step-3.png) _The character profile after manual search (fetches latest data from Blizzard's servers)_

### Additional Player Sources

The addon works with players from various sources:

| Context          |Screenshot |
| ---------------- |---------- |
| <strong>LFG Creator</strong> |<img src="https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/lfg-creator-example.png" alt="LFG Creator Example"> |
| <strong>LFG Seeker</strong> |<img src="https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/lfg-seeker-example.png" alt="LFG Seeker Example"> |
| <strong>Guild Member</strong> |<img src="https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/guild-example.png" alt="Guild Example"> |
| <strong>Community Member</strong> |<img src="https://raw.githubusercontent.com/Kirom/CheckPvPAssistant/refs/heads/master/assets/images/community-example.png" alt="Community Example"> |

## ⚙️ Configuration

### Slash Commands

*   `/checkpvp` or `/cpvp` - Show available commands
*   `/checkpvp debug` - Toggle debug output
*   `/checkpvp usename` - Copy name-realm format (default)
*   `/checkpvp useurl` - Copy full Check-PvP URLs
*   `/checkpvp mode` - Show current copy mode

### Supported Contexts

The addon works in multiple contexts as demonstrated in the screenshots above:

*   **Guild members** - Right-click in guild roster
*   **Community members** - Right-click in community member list
*   **LFG creators** - Right-click on group leaders in LFG browser
*   **LFG seekers** - Right-click on players looking for groups
*   **Your own character** - Right-click on yourself
*   **Target players** - Right-click on any targeted player
*   **Party members** - Right-click in party frames
*   **Raid members** - Right-click in raid frames
*   **Friends list** - Right-click on friends
*   **Battle.Net friends** - Right-click on Battle.Net friends
*   **Enemy players** - Right-click on opposing faction players

## 🔧 Requirements

*   **World of Warcraft**: 
    *   **Retail**: The War Within (11.1.7+) or later
    *   **MoP Classic**: Mists of Pandaria Classic (5.5.0) or later
*   **Menu System**: Uses the new Menu API introduced in TWW (Retail) and compatible with MoP Classic

## 📞 Support & Feedback

For bug reports, feature requests, or general feedback:

*   **GitHub Issues** - [CheckPvPAssistant Issues](https://github.com/Kirom/CheckPvPAssistant/issues)
*   **Documentation** - See README.md for detailed usage instructions and screenshots

***

**Happy PvP hunting!** 🗡️⚔️