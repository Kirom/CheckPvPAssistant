# TODO

## High Priority


## Medium Priority

1. **Region Testing**
   - Test Retail KR region functionality
   - Test Retail CN region functionality
   - Test MoP Classic KR region functionality
   - Test MoP Classic CN region functionality
   - Test MoP Classic TW region functionality
   - Test MoP Classic US region functionality
   - Verify region detection accuracy

## Low Priority

1. **Feature Enhancements**
   - Add localization support for multiple languages

## Fixed / Done

1. **Copy Dialog Enhancement** - [IMPLEMENTED]
   - Added option to auto-close copy dialog after text is copied (Ctrl+C)
   - Implemented toggle functionality for auto-close behavior via `/checkpvp autoclose` command
   - Default behavior: auto-close ON by default for better UX, with toggle for users who prefer manual control
   - Auto-close detection works by monitoring keyboard events to detect Ctrl+C key combination
   - Automatically ensures text is always selected when Ctrl+C is pressed to guarantee copy operation

- [FIXED] Realm name bug: Issues with realms containing single quotes or parentheses (e.g., Aggra(Português), Kor'gall) causing 404 errors on generated URLs. This has been addressed by correcting formatting in db_realms.lua for consistency in realm names.