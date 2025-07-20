# TODO

## High Priority


## Medium Priority

1. **Copy Dialog Enhancement**
   - Add option to auto-close copy dialog after text is copied (Ctrl+C)
   - Implement toggle functionality for auto-close behavior
   - Consider default behavior: auto-close ON by default for better UX, but provide toggle for users who prefer manual control

2. **Region Testing**
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

- [FIXED] Realm name bug: Issues with realms containing single quotes or parentheses (e.g., Aggra(Português), Kor'gall) causing 404 errors on generated URLs. This has been addressed by correcting formatting in db_realms.lua for consistency in realm names.