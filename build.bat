@echo off
echo 🔨 Building CryptingTool...

REM Check if CMake is installed
cmake --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ CMake is not installed. Please install CMake to continue.
    exit /b 1
)

REM Build native library
echo 📦 Building native C++ library...
cd native
cmake -B build -DCMAKE_BUILD_TYPE=Release -A x64
cmake --build build --config Release
cd ..

REM Create lib-native directory and copy library
echo 📁 Setting up native library...
if not exist lib-native mkdir lib-native

REM Copy Windows DLL
copy "native\build\Release\crypto_native.dll" "lib-native\" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Windows library copied
) else (
    echo ⚠️  Windows library not found, but build may have succeeded
)

echo 🎉 Build completed successfully!
echo 💡 Next steps:
echo    1. Install Flutter SDK
echo    2. Run 'flutter pub get' to install dependencies
echo    3. Run 'flutter run' to start the application