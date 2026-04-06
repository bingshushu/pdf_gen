@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

if "%~1"=="" goto usage

if /i "%~1"=="bwallet" goto do_bwallet
if /i "%~1"=="btcbox" goto do_btcbox
if /i "%~1"=="btcbox0727" goto do_btcbox0727
goto usage

:do_bwallet
call :check_firebase bwallet
if errorlevel 1 exit /b 1
echo Building B-Wallet...
flutter build apk --flavor bwallet --dart-define=APP_FLAVOR=bwallet -t lib/main.dart
if errorlevel 1 exit /b 1
echo Done. APK: build/app/outputs/flutter-apk/app-bwallet-release.apk
goto eof

:do_btcbox
call :check_firebase btcbox
if errorlevel 1 exit /b 1
echo Building BTCBOX...
flutter build apk --flavor btcbox --dart-define=APP_FLAVOR=btcbox -t lib/main.dart
if errorlevel 1 exit /b 1
echo Done. APK: build/app/outputs/flutter-apk/app-btcbox-release.apk
goto eof

:do_btcbox0727
call :check_firebase btcbox0727
if errorlevel 1 exit /b 1
echo Building BTCBOX0727...
flutter build apk --flavor btcbox0727 --dart-define=APP_FLAVOR=btcbox0727 -t lib/main.dart
if errorlevel 1 exit /b 1
echo Done. APK: build/app/outputs/flutter-apk/app-btcbox0727-release.apk
goto eof

:check_firebase
set "FV=%~1"
set "GSPATH=android\app\src\%FV%\google-services.json"
if exist "%GSPATH%" exit /b 0
echo Warning: missing Firebase config for %FV%
echo Expected: android\app\src\%FV%\google-services.json
set /p "ANS=Copy android\app\google-services.json there and continue? (y/n): "
if /i "!ANS!"=="y" (
  copy /y "android\app\google-services.json" "%GSPATH%" >nul
  echo Copied default file; Firebase may not work until you use the correct config.
  exit /b 0
)
echo Build cancelled.
exit /b 1

:usage
echo Usage: build_variants.cmd [bwallet ^| btcbox ^| btcbox0727]
echo   bwallet     - B-Wallet
echo   btcbox      - BTCBOX
echo   btcbox0727  - BTCBOX0727
echo.
echo Each flavor needs: android\app\src\^<flavor^>\google-services.json
exit /b 1

:eof
endlocal
exit /b 0
