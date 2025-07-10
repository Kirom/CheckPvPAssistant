# TODO

## High Priority

1. **Add CurseForge / WowUp distribution**  -- Test with the next release.

## Medium Priority


## Low Priority

1. **Feature Enhancements**
   - Add localization support for multiple languages

2. **Region Testing**
   - Test KR region functionality
   - Test CN region functionality
   - Verify region detection accuracy

## Fixed / Done

- [FIXED] Realm name bug: Issues with realms containing single quotes or parentheses (e.g., Aggra(Português), Kor'gall) causing 404 errors on generated URLs. This has been addressed by correcting formatting in db_realms.lua for consistency in realm names.