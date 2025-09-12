@echo off
REM Android SDK License Acceptance Batch Script
REM Based on Stack Overflow solutions for "1 of 7 SDK package license not accepted"
REM https://stackoverflow.com/questions/38096225/automatically-accept-all-sdk-licences

echo === Android SDK License Acceptance ===
echo This script will accept all Android SDK licenses automatically

REM Method 1: Multiple echo responses (most reliable on Windows)
echo Attempting license acceptance method 1: Multiple echo approach...
(echo y & echo y & echo y & echo y & echo y & echo y & echo y & echo y & echo y & echo y) | flutter doctor --android-licenses

if %ERRORLEVEL% EQU 0 (
    echo ✅ License acceptance method 1 succeeded
    goto :verify
)

echo ⚠️ Method 1 failed, trying method 2...

REM Method 2: Direct SDK manager approach
echo Attempting license acceptance method 2: SDK manager approach...
for /f "delims=" %%i in ('flutter doctor --android-licenses') do echo y

if %ERRORLEVEL% EQU 0 (
    echo ✅ License acceptance method 2 succeeded
    goto :verify
)

echo ⚠️ Method 2 failed, trying method 3...

REM Method 3: CMD pipe approach
echo Attempting license acceptance method 3: CMD pipe...
cmd /c "echo y | flutter doctor --android-licenses"

:verify
echo === Verification ===
flutter doctor -v
echo === License acceptance script completed ===