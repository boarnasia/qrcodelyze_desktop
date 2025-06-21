# QRCodelyze Desktop - Development Environment

## Development Environment
- OS: Windows 11 with WSL2 (Ubuntu 24)
- Flutter Path: e:\masat\sdks\flutter\bin\flutter
- Git Path: /mnt/c/Program Files/Git/bin/git.exe (Windows Git)
- Command Execution: 
  - Flutter: cmd.exe wrapper required
  - Git: Use Windows git.exe directly

## Flutter Command Examples
- Run: cmd.exe /c "e:\masat\sdks\flutter\bin\flutter run -d windows"
- Upgrade: cmd.exe /c "e:\masat\sdks\flutter\bin\flutter upgrade"
- Test: cmd.exe /c "e:\masat\sdks\flutter\bin\flutter test"
- Build: cmd.exe /c "e:\masat\sdks\flutter\bin\flutter build windows"

## Git Commands  
- Status: /mnt/c/Program\ Files/Git/bin/git.exe status
- Add: /mnt/c/Program\ Files/Git/bin/git.exe add .
- Commit: /mnt/c/Program\ Files/Git/bin/git.exe commit -m \"message\"

### Important Notes
- Always use cmd.exe /c wrapper when executing Flutter commands
- Always use Windows git.exe to avoid line ending issues
- Both tools operate on Windows filesystem directly"
- Target platform is Windows desktop
- Development is done in WSL2 but Flutter runs on Windows host

## Dependencies
- Main barcode library: flutter_zxing ^2.1.0 (supports ALL ZXing formats)
- Do NOT use: qr_flutter, barcode (unnecessary with flutter_zxing)
- UI: window_manager, logging, file_selector (for Windows desktop features)

## Testing & Code Coverage Standards
- Minimum code coverage: 80% line coverage
- All new features MUST include corresponding tests
- Test commands:
  - Run tests: cmd.exe /c \"e:\masat\sdks\flutter\bin\flutter test\"
  - Coverage: cmd.exe /c \"e:\masat\sdks\flutter\bin\flutter test --coverage\"
- Test file structure:
  - Widget tests: test/widgets/
  - Unit tests: test/units/
  - Integration tests: test/integration/
- Coverage verification required before any commit
- If coverage drops below threshold, implementation is incomplete

## Test Requirements for Any New Code:
1. Write tests FIRST (TDD approach when possible)
2. Cover both success and error paths
3. Mock external dependencies (flutter_zxing, file_selector, etc.)
4. Verify coverage after implementation
5. Fix any coverage gaps before considering task complete
