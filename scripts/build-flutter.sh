#!/bin/bash
set -e

TARGET_PLATFORM=$1
BUILD_MODE=$2

echo "Building Flutter application for $TARGET_PLATFORM in $BUILD_MODE mode..."

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
    echo "pubspec.yaml not found. This might not be a Flutter project."
    echo "Creating a minimal Flutter project structure..."
    
    # Create minimal Flutter app structure
    flutter create --project-name cryptingtool .
    
    # Update pubspec.yaml to include FFI for C++ integration
    cat >> pubspec.yaml << EOL

  # C++ Integration
  ffi: ^2.1.0
  path: ^1.8.3
EOL
fi

# Get dependencies
echo "📦 Getting Flutter dependencies..."
if ! flutter pub get; then
    echo "❌ Failed to get Flutter dependencies. Checking Flutter installation..."
    flutter doctor -v
    
    # Try to fix common issues
    flutter clean
    flutter pub get
fi

# Create build directory
mkdir -p build/flutter

case $TARGET_PLATFORM in
    "android")
        echo "Building Flutter for Android..."
        if ! flutter build apk --$BUILD_MODE; then
            echo "❌ Android build failed. Checking Android SDK..."
            flutter doctor -v
            exit 1
        fi
        if [ -d "build/app/outputs/flutter-apk" ]; then
            cp -r build/app/outputs/flutter-apk/* build/flutter/
        fi
        ;;
    "ios")
        echo "Building Flutter for iOS..."
        if ! flutter build ios --$BUILD_MODE --no-codesign; then
            echo "❌ iOS build failed. Checking iOS setup..."
            flutter doctor -v
            exit 1
        fi
        if [ -d "build/ios/iphoneos" ]; then
            cp -r build/ios/iphoneos build/flutter/ios-build
        fi
        ;;
    "linux")
        echo "Building Flutter for Linux..."
        flutter config --enable-linux-desktop
        if ! flutter build linux --$BUILD_MODE; then
            echo "❌ Linux build failed. Checking Linux desktop setup..."
            flutter doctor -v
            exit 1
        fi
        if [ -d "build/linux/x64/release/bundle" ]; then
            cp -r build/linux/x64/release/bundle build/flutter/linux-bundle
        fi
        ;;
    "windows")
        echo "Building Flutter for Windows..."
        flutter config --enable-windows-desktop
        if ! flutter build windows --$BUILD_MODE; then
            echo "❌ Windows build failed. Checking Windows desktop setup..."
            flutter doctor -v
            exit 1
        fi
        if [ -d "build/windows/runner/Release" ]; then
            cp -r build/windows/runner/Release build/flutter/windows-release
        fi
        ;;
    "macos")
        echo "Building Flutter for macOS..."
        flutter config --enable-macos-desktop
        if ! flutter build macos --$BUILD_MODE; then
            echo "❌ macOS build failed. Checking macOS desktop setup..."
            flutter doctor -v
            exit 1
        fi
        if [ -d "build/macos/Build/Products/Release" ]; then
            cp -r build/macos/Build/Products/Release build/flutter/macos-release
        fi
        ;;
    "web")
        echo "Building Flutter for Web..."
        flutter config --enable-web
        if ! flutter build web --$BUILD_MODE; then
            echo "❌ Web build failed. Checking web setup..."
            flutter doctor -v
            exit 1
        fi
        if [ -d "build/web" ]; then
            cp -r build/web build/flutter/web-build
        fi
        ;;
    *)
        echo "Unsupported platform: $TARGET_PLATFORM"
        exit 1
        ;;
esac

echo "Flutter build completed successfully!"

# List built artifacts
echo "Built artifacts:"
find build/flutter -type f -name "*" | head -20