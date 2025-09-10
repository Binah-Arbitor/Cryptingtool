#!/bin/bash

# Build script for CryptingTool
# This script builds the native library and prepares for Flutter app development

set -e

echo "🔨 Building CryptingTool..."

# Check if CMake is installed
if ! command -v cmake &> /dev/null; then
    echo "❌ CMake is not installed. Please install CMake to continue."
    exit 1
fi

# Build native library
echo "📦 Building native C++ library..."
cd native
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cd ..

# Create lib-native directory and copy library
echo "📁 Setting up native library..."
mkdir -p lib-native

# Copy library based on platform
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp native/build/libcrypto_native.so* lib-native/
    echo "✅ Linux library copied"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp native/build/libcrypto_native.dylib* lib-native/ 2>/dev/null || cp native/build/*.dylib lib-native/ 2>/dev/null || echo "⚠️  macOS library not found, but build succeeded"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    cp native/build/Release/crypto_native.dll lib-native/ 2>/dev/null || cp native/build/*.dll lib-native/ 2>/dev/null || echo "⚠️  Windows library not found, but build succeeded"
fi

echo "🎉 Build completed successfully!"
echo "💡 Next steps:"
echo "   1. Install Flutter SDK"
echo "   2. Run 'flutter pub get' to install dependencies"
echo "   3. Run 'flutter run' to start the application"