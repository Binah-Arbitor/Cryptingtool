#!/bin/bash
set -e

echo "🔧 CryptingTool Troubleshooting Guide"
echo "====================================="

echo ""
echo "🔍 Diagnosing common issues..."

# Check 1: Build tools
echo ""
echo "1. Checking build tools..."
if command -v cmake >/dev/null 2>&1; then
    echo "✅ CMake: $(cmake --version | head -1)"
else
    echo "❌ CMake not found"
    echo "   Install: sudo apt-get install cmake (Linux) | brew install cmake (macOS)"
fi

if command -v ninja >/dev/null 2>&1; then
    echo "✅ Ninja: $(ninja --version)"
elif command -v make >/dev/null 2>&1; then
    echo "✅ Make: $(make --version | head -1)"
else
    echo "❌ Neither Ninja nor Make found"
    echo "   Install: sudo apt-get install ninja-build (Linux) | brew install ninja (macOS)"
fi

# Check 2: Compilers
echo ""
echo "2. Checking compilers..."
if command -v gcc >/dev/null 2>&1; then
    echo "✅ GCC: $(gcc --version | head -1)"
fi

if command -v clang >/dev/null 2>&1; then
    echo "✅ Clang: $(clang --version | head -1)"
fi

if ! command -v gcc >/dev/null 2>&1 && ! command -v clang >/dev/null 2>&1; then
    echo "❌ No C++ compiler found"
    echo "   Install: sudo apt-get install build-essential (Linux) | xcode-select --install (macOS)"
fi

# Check 3: Crypto++ library
echo ""
echo "3. Checking crypto++ library..."

# Check via pkg-config
if pkg-config --exists cryptopp 2>/dev/null; then
    echo "✅ Crypto++ found via pkg-config:"
    echo "   Version: $(pkg-config --modversion cryptopp)"
    echo "   Libs: $(pkg-config --libs cryptopp)"
elif pkg-config --exists libcrypto++ 2>/dev/null; then
    echo "✅ Crypto++ found via pkg-config (libcrypto++):"
    echo "   Version: $(pkg-config --modversion libcrypto++)"
    echo "   Libs: $(pkg-config --libs libcrypto++)"
else
    echo "⚠️  Crypto++ not found via pkg-config"
fi

# Check libraries
echo ""
echo "   Searching for crypto++ libraries..."
found_libs=0
for lib_path in /usr/lib /usr/local/lib /opt/homebrew/lib /usr/lib/x86_64-linux-gnu /usr/lib/aarch64-linux-gnu; do
    if [ -d "$lib_path" ]; then
        for lib_name in libcryptopp.so libcrypto++.so libcryptopp.a libcrypto++.a libcryptopp.dylib libcrypto++.dylib; do
            if [ -f "$lib_path/$lib_name" ]; then
                echo "   ✅ Found: $lib_path/$lib_name"
                found_libs=$((found_libs + 1))
            fi
        done
    fi
done

if [ $found_libs -eq 0 ]; then
    echo "   ❌ No crypto++ libraries found"
fi

# Check headers
echo ""
echo "   Searching for crypto++ headers..."
found_headers=0
for header_path in /usr/include /usr/local/include /opt/homebrew/include; do
    if [ -d "$header_path" ]; then
        for header_dir in cryptopp crypto++; do
            if [ -f "$header_path/$header_dir/cryptlib.h" ]; then
                echo "   ✅ Found headers: $header_path/$header_dir/"
                found_headers=$((found_headers + 1))
            fi
        done
    fi
done

if [ $found_headers -eq 0 ]; then
    echo "   ❌ No crypto++ headers found"
fi

# Check 4: Flutter (optional)
echo ""
echo "4. Checking Flutter (optional)..."
if command -v flutter >/dev/null 2>&1; then
    echo "✅ Flutter found: $(flutter --version | head -1)"
    
    # Check Linux desktop dependencies (GTK 3.0) when on Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo ""
        echo "   Checking Linux desktop dependencies..."
        if pkg-config --exists gtk+-3.0 2>/dev/null; then
            GTK_VERSION=$(pkg-config --modversion gtk+-3.0 2>/dev/null || echo "unknown")
            echo "   ✅ GTK 3.0 development libraries: $GTK_VERSION"
        else
            echo "   ❌ GTK 3.0 development libraries not found"
            echo "   📦 Install with: sudo apt-get install libgtk-3-dev mesa-utils"
        fi
    fi
    
    # Check Android Studio
    echo ""
    echo "   Checking Android Studio..."
    ANDROID_STUDIO_PATHS=(
        "/opt/android-studio/bin/studio.sh"
        "/usr/local/android-studio/bin/studio.sh"
        "$HOME/android-studio/bin/studio.sh"
        "/Applications/Android Studio.app/Contents/bin/studio.sh"
    )
    ANDROID_STUDIO_FOUND=false
    for studio_path in "${ANDROID_STUDIO_PATHS[@]}"; do
        if [ -f "$studio_path" ]; then
            echo "   ✅ Android Studio found at: $studio_path"
            ANDROID_STUDIO_FOUND=true
            break
        fi
    done
    
    if [ "$ANDROID_STUDIO_FOUND" = false ]; then
        echo "   ⚠️  Android Studio not found (optional)"
        echo "   💡 Download from: https://developer.android.com/studio"
    fi
else
    echo "⚠️  Flutter not found (optional for C++ only builds)"
fi

# Check 5: Git and GitHub Actions environment
echo ""
echo "5. Checking environment..."
if [ -n "$GITHUB_ACTIONS" ]; then
    echo "✅ Running in GitHub Actions"
    echo "   Runner OS: ${RUNNER_OS:-unknown}"
    echo "   Runner Architecture: ${RUNNER_ARCH:-unknown}"
else
    echo "ℹ️  Running locally"
fi

# Provide recommendations
echo ""
echo "🎯 Recommendations:"
echo "=================="

if [ $found_libs -eq 0 ] || [ $found_headers -eq 0 ]; then
    echo ""
    echo "❌ Crypto++ library issues detected"
    echo ""
    echo "Quick fixes:"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "  Ubuntu/Debian: sudo apt-get update && sudo apt-get install libcrypto++-dev"
        echo "  CentOS/RHEL:   sudo yum install cryptopp-devel"
        echo "  Arch Linux:    sudo pacman -S crypto++"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  macOS:         brew install cryptopp"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "  Windows:       vcpkg install cryptopp"
    fi
    echo ""
    echo "Alternative - build from source (latest stable):"
    LATEST_VERSION=$(curl -s https://github.com/weidai11/cryptopp/releases 2>/dev/null | grep -o 'CRYPTOPP_[0-9_]*' | head -1 || echo "CRYPTOPP_8_9_0")
    VERSION_NUM=$(echo $LATEST_VERSION | sed 's/CRYPTOPP_//g' | sed 's/_//g')
    echo "  Latest version: $LATEST_VERSION"
    echo "  wget https://github.com/weidai11/cryptopp/releases/download/${LATEST_VERSION}/cryptopp${VERSION_NUM}.zip"
    echo "  unzip cryptopp${VERSION_NUM}.zip && cd cryptopp"
    echo "  make && sudo make install"
fi

# Check for Flutter Linux desktop dependencies
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! pkg-config --exists gtk+-3.0 2>/dev/null; then
        echo ""
        echo "❌ Flutter Linux desktop dependencies missing"
        echo ""
        echo "Quick fix for GTK 3.0 development libraries:"
        echo "  Ubuntu/Debian: sudo apt-get install libgtk-3-dev mesa-utils"
        echo "  CentOS/RHEL:   sudo yum install gtk3-devel mesa-dri-drivers"
        echo "  Arch Linux:    sudo pacman -S gtk3"
        echo ""
        echo "This is required for 'flutter build linux' to work properly."
    fi
fi

# Check for Android Studio
ANDROID_STUDIO_PATHS=(
    "/opt/android-studio/bin/studio.sh"
    "/usr/local/android-studio/bin/studio.sh"
    "$HOME/android-studio/bin/studio.sh"
    "/Applications/Android Studio.app/Contents/bin/studio.sh"
)
ANDROID_STUDIO_FOUND=false
for studio_path in "${ANDROID_STUDIO_PATHS[@]}"; do
    if [ -f "$studio_path" ]; then
        ANDROID_STUDIO_FOUND=true
        break
    fi
done

if [ "$ANDROID_STUDIO_FOUND" = false ]; then
    echo ""
    echo "ℹ️  Android Studio not found (optional)"
    echo ""
    echo "Android Studio provides enhanced Flutter development experience:"
    echo "  Download from: https://developer.android.com/studio"
    echo "  Alternative: Use VS Code with Flutter extension"
fi

if ! command -v cmake >/dev/null 2>&1; then
    echo ""
    echo "❌ CMake required for building"
    echo "   Install CMake 3.10 or later"
fi

echo ""
echo "🔗 Useful links:"
echo "  - Crypto++ website: https://www.cryptopp.com/"
echo "  - GitHub repository: https://github.com/weidai11/cryptopp"
echo "  - Installation guide: https://www.cryptopp.com/wiki/Linux"

echo ""
echo "✅ Troubleshooting completed!"