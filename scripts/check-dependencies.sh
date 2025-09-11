#!/bin/bash
set -e

echo "🔍 Checking system dependencies for CryptingTool..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a library exists
library_exists() {
    local lib_name="$1"
    
    # Check via pkg-config
    if pkg-config --exists "$lib_name" 2>/dev/null; then
        return 0
    fi
    
    # Check via find_library-like search
    for path in /usr/lib /usr/local/lib /opt/homebrew/lib /usr/lib/x86_64-linux-gnu /usr/lib/aarch64-linux-gnu; do
        if [ -f "$path/lib${lib_name}.so" ] || [ -f "$path/lib${lib_name}.a" ] || [ -f "$path/lib${lib_name}.dylib" ]; then
            return 0
        fi
    done
    
    return 1
}

# Function to check if headers exist
headers_exist() {
    local header_path="$1"
    
    for path in /usr/include /usr/local/include /opt/homebrew/include; do
        if [ -f "$path/$header_path" ]; then
            return 0
        fi
    done
    
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
            if command_exists apt-get; then
                echo "🔄 Attempting automatic installation..."
                sudo apt-get update
                
                # Try multiple package names in order of preference
                CRYPTO_INSTALLED=false
                for pkg in libcrypto++-dev libcrypto++8-dev libcryptoppdev libcryptopp-dev; do
                    if sudo apt-get install -y $pkg 2>/dev/null; then
                        echo "✅ Installed $pkg"
                        CRYPTO_INSTALLED=true
                        break
                    fi
                done
                
                if [ "$CRYPTO_INSTALLED" = false ]; then
                    echo "📥 No packages available, building from source..."
                    # Get latest version dynamically
                    CRYPTO_VERSION=$(curl -s https://github.com/weidai11/cryptopp/releases 2>/dev/null | grep -o 'CRYPTOPP_[0-9_]*' | head -1 || echo "CRYPTOPP_8_9_0")
                    CRYPTO_ZIP_VERSION=$(echo $CRYPTO_VERSION | sed 's/CRYPTOPP_//g' | sed 's/_//g')
                    echo "🔄 Building Crypto++ $CRYPTO_VERSION from source..."
                    
                    cd /tmp
                    wget https://github.com/weidai11/cryptopp/releases/download/${CRYPTO_VERSION}/cryptopp${CRYPTO_ZIP_VERSION}.zip
                    unzip cryptopp${CRYPTO_ZIP_VERSION}.zip -d cryptopp
                    cd cryptopp
                    make -j$(nproc)
                    sudo make install PREFIX=/usr/local
                    sudo ldconfig
                    echo "✅ Built and installed Crypto++ $CRYPTO_VERSION from source"
                fi
            fi
            ;;
        "macos")
            echo "📦 Install with: brew install cryptopp"
            if command_exists brew; then
                echo "🔄 Attempting automatic installation..."
                if brew install cryptopp; then
                    echo "✅ Crypto++ installed via Homebrew"
                else
                    echo "📥 Homebrew installation failed, building from source..."
                    # Get latest version and build from source
                    CRYPTO_VERSION=$(curl -s https://github.com/weidai11/cryptopp/releases 2>/dev/null | grep -o 'CRYPTOPP_[0-9_]*' | head -1 || echo "CRYPTOPP_8_9_0")
                    CRYPTO_ZIP_VERSION=$(echo $CRYPTO_VERSION | sed 's/CRYPTOPP_//g' | sed 's/_//g')
                    echo "🔄 Building Crypto++ $CRYPTO_VERSION from source..."
                    
                    cd /tmp
                    wget https://github.com/weidai11/cryptopp/releases/download/${CRYPTO_VERSION}/cryptopp${CRYPTO_ZIP_VERSION}.zip
                    unzip cryptopp${CRYPTO_ZIP_VERSION}.zip -d cryptopp
                    cd cryptopp
                    make -j$(sysctl -n hw.ncpu)
                    sudo make install PREFIX=/usr/local
                    echo "✅ Built and installed Crypto++ $CRYPTO_VERSION from source"
                fi
            fi
            ;;
        "windows")
            echo "📦 Install with: vcpkg install cryptopp"
            echo "   Or download from: https://github.com/weidai11/cryptopp/releases"
            ;;
    esac
fi

# Check Flutter (if needed)
echo "🐦 Checking Flutter..."
if command_exists flutter; then
    echo "✅ Flutter is available"
    flutter --version
else
    echo "⚠️  Flutter not found. This is optional for C++ only builds."
fi

echo "🎉 Dependency check completed!"