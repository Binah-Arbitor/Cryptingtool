#!/bin/bash
set -e

echo "🔍 Checking system dependencies for CryptingTool..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Optimized function to check if a library exists (faster than filesystem search)
library_exists() {
    local lib_name="$1"
    
    # Check via pkg-config first (fastest)
    if pkg-config --exists "$lib_name" 2>/dev/null; then
        return 0
    fi
    
    # Quick check in most common location for this architecture
    local arch_path="/usr/lib/$(gcc -dumpmachine)"
    if [ -f "$arch_path/lib${lib_name}.so" ]; then
        return 0
    fi
    
    # Fallback to ldconfig cache (faster than find)
    if ldconfig -p 2>/dev/null | grep -q "lib${lib_name}"; then
        return 0
    fi
    
    return 1
}

# Optimized function to check if headers exist (targeted check)
headers_exist() {
    local header_path="$1"
    
    # Check standard system locations directly (no loop)
    if [ -f "/usr/include/$header_path" ] || [ -f "/usr/local/include/$header_path" ]; then
        return 0
    fi
    
    # macOS homebrew check
    if [[ "$OSTYPE" == "darwin"* ]] && [ -f "/opt/homebrew/include/$header_path" ]; then
        return 0
    fi
    
    return 1
}

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
fi

echo "📋 Detected OS: $OS"

# Check essential build tools
echo "🔨 Checking build tools..."
MISSING_TOOLS=()

if ! command_exists cmake; then
    MISSING_TOOLS+=("cmake")
fi

if ! command_exists ninja && ! command_exists make; then
    MISSING_TOOLS+=("ninja or make")
fi

if ! command_exists gcc && ! command_exists clang; then
    MISSING_TOOLS+=("gcc or clang")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "❌ Missing build tools: ${MISSING_TOOLS[*]}"
    
    case $OS in
        "linux")
            echo "📦 Install with: sudo apt-get install build-essential cmake ninja-build"
            ;;
        "macos")
            echo "📦 Install with: brew install cmake ninja"
            ;;
        "windows")
            echo "📦 Install with: choco install cmake ninja"
            ;;
    esac
    exit 1
fi

echo "✅ Build tools are available"

# Check crypto++ library
echo "🔐 Checking crypto++ library..."
CRYPTOPP_FOUND=false

if library_exists "cryptopp" || library_exists "crypto++"; then
    echo "✅ Crypto++ library found"
    CRYPTOPP_FOUND=true
elif headers_exist "cryptopp/cryptlib.h" || headers_exist "crypto++/cryptlib.h"; then
    echo "✅ Crypto++ headers found"
    CRYPTOPP_FOUND=true
fi

if [ "$CRYPTOPP_FOUND" = false ]; then
    echo "❌ Crypto++ library not found"
    
    case $OS in
        "linux")
            echo "📦 Install with: sudo apt-get install libcrypto++-dev"
            # Skip automatic installation by default for speed
            if [[ "${AUTO_INSTALL:-false}" == "true" ]]; then
                echo "🔄 AUTO_INSTALL=true detected, attempting installation..."
                sudo apt-get update
                sudo apt-get install -y libcrypto++-dev
            else
                echo "💡 Run with AUTO_INSTALL=true to auto-install"
            fi
            ;;
        "macos")
            echo "📦 Install with: brew install cryptopp"
            if [[ "${AUTO_INSTALL:-false}" == "true" ]] && command_exists brew; then
                echo "🔄 AUTO_INSTALL=true detected, attempting installation..."
                brew install cryptopp
            else
                echo "💡 Run with AUTO_INSTALL=true to auto-install"
            fi
            ;;
        "windows")
            echo "📦 Install with: vcpkg install cryptopp"
            ;;
    esac
fi

# Check Flutter (quick check)
echo "🐦 Checking Flutter..."
if command_exists flutter; then
    echo "✅ Flutter is available"
    FLUTTER_VERSION=$(flutter --version 2>&1 | head -1 | cut -d' ' -f2 || echo "unknown")
    echo "   Version: $FLUTTER_VERSION"
    
    # Quick Android toolchain check (avoid expensive flutter doctor)
    echo "📱 Quick Android check..."
    if [[ -n "$ANDROID_HOME" ]] || [[ -n "$ANDROID_SDK_ROOT" ]]; then
        echo "✅ Android SDK path configured"
    else
        echo "⚠️  Android SDK path not set (ANDROID_HOME/ANDROID_SDK_ROOT)"
        echo "💡 Run 'flutter doctor' for detailed diagnostics"
    fi
else
    echo "⚠️  Flutter not found (install from: https://docs.flutter.dev/get-started/install)"
fi

echo "🎉 Dependency check completed!"