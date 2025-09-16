#!/bin/bash
set -e

echo "🔍 CRYPTO++ VERIFICATION SCRIPT"
echo "================================"
echo "This comprehensive script tests all crypto++ detection methods"
echo "and provides detailed debugging information."
echo ""

# Color output functions
success() { echo "✅ $1"; }
warning() { echo "⚠️  $1"; }
error() { echo "❌ $1"; }
# Crypto++ Library Verification Script
# Checks if Crypto++ is properly installed and provides detailed diagnostics

set -e

echo "🔐 Crypto++ Library Verification Script"
echo "========================================"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
info() { echo "ℹ️  $1"; }

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
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

echo "📋 System Information:"
echo "   OS: $OS ($OSTYPE)"
echo "   Architecture: $(uname -m 2>/dev/null || echo 'unknown')"
echo ""

CRYPTO_FOUND=false
CRYPTO_METHODS_FOUND=()

# Check 1: pkg-config detection
echo "🔍 Method 1: pkg-config detection"
if command_exists pkg-config; then
    if pkg-config --exists libcrypto++; then
        VERSION=$(pkg-config --modversion libcrypto++)
        LIBS=$(pkg-config --libs libcrypto++)
        INCLUDE=$(pkg-config --cflags libcrypto++)
        success "Found via pkg-config (libcrypto++): v$VERSION"
        info "   Libraries: $LIBS"
        info "   Includes: $INCLUDE"
        CRYPTO_FOUND=true
        CRYPTO_METHODS_FOUND+=("pkg-config libcrypto++")
    elif pkg-config --exists cryptopp; then
        VERSION=$(pkg-config --modversion cryptopp)
        LIBS=$(pkg-config --libs cryptopp)
        INCLUDE=$(pkg-config --cflags cryptopp)
        success "Found via pkg-config (cryptopp): v$VERSION"
        info "   Libraries: $LIBS"
        info "   Includes: $INCLUDE"
        CRYPTO_FOUND=true
        CRYPTO_METHODS_FOUND+=("pkg-config cryptopp")
    else
        warning "pkg-config available but no crypto++ packages found"
    fi
else
    warning "pkg-config not available"
fi
echo ""

# Check 2: Library file detection
echo "🔍 Method 2: Direct library detection"
LIBRARY_FOUND=false
for lib_path in /usr/lib /usr/local/lib /opt/homebrew/lib /usr/lib/x86_64-linux-gnu /usr/lib/aarch64-linux-gnu; do
    if [ -d "$lib_path" ]; then
        for lib_name in libcrypto++.so libcrypto++.a libcryptopp.so libcryptopp.a libcrypto++.dylib libcrypto++.so libcrypto++.so libcryptopp.a libcrypto++.a libcryptopp.dylib libcrypto++.dylib; do
            if [ -f "$lib_path/$lib_name" ]; then
                success "Found library: $lib_path/$lib_name"
                info "   Size: $(ls -lh "$lib_path/$lib_name" | awk '{print $5}')"
                LIBRARY_FOUND=true
                CRYPTO_FOUND=true
                CRYPTO_METHODS_FOUND+=("direct library search")
                break 2
            fi
        done
    fi
done

if [ "$LIBRARY_FOUND" = false ]; then
    warning "No crypto++ libraries found in standard paths"
fi
echo ""

# Check 3: Header detection
echo "🔍 Method 3: Header detection"
HEADERS_FOUND=false
for include_path in /usr/include /usr/local/include /opt/homebrew/include; do
    if [ -f "$include_path/cryptopp/cryptlib.h" ]; then
        success "Found headers: $include_path/cryptopp/"
        HEADERS_FOUND=true
        CRYPTO_FOUND=true
        CRYPTO_METHODS_FOUND+=("header detection")
        break
    elif [ -f "$include_path/crypto++/cryptlib.h" ]; then
        success "Found headers: $include_path/crypto++/"
        HEADERS_FOUND=true
        CRYPTO_FOUND=true
        CRYPTO_METHODS_FOUND+=("header detection")
        break
    fi
done

if [ "$HEADERS_FOUND" = false ]; then
    # Try alternative search
    for header_path in /usr/include /usr/local/include /opt/homebrew/include; do
        if [ -d "$header_path" ]; then
            for header_dir in cryptopp crypto++; do
                if [ -f "$header_path/$header_dir/cryptlib.h" ]; then
                    success "Found headers: $header_path/$header_dir/cryptlib.h"
                    HEADERS_FOUND=true
                    CRYPTO_FOUND=true
                    CRYPTO_METHODS_FOUND+=("headers")
                    break 2
                fi
            done
        fi
    done
fi

if [ "$HEADERS_FOUND" = false ]; then
    warning "No crypto++ headers found in standard paths"
fi
echo ""

# Check 4: Package manager detection
echo "🔍 Method 4: Package manager detection"
case $OS in
    "linux")
        if command_exists dpkg; then
            PACKAGES=$(dpkg -l | grep crypto++ | wc -l)
            if [ "$PACKAGES" -gt 0 ]; then
                success "Found $PACKAGES crypto++ package(s) via dpkg:"
                dpkg -l | grep crypto++ | while read line; do
                    info "   $line"
                done
                CRYPTO_FOUND=true
                CRYPTO_METHODS_FOUND+=("dpkg packages")
            else
                warning "No crypto++ packages found via dpkg"
            fi
        elif command_exists rpm; then
            if rpm -qa | grep -q cryptopp; then
                success "Found crypto++ packages via rpm"
                CRYPTO_FOUND=true
                CRYPTO_METHODS_FOUND+=("rpm packages")
            else
                warning "No crypto++ packages found via rpm"
            fi
        fi
        ;;
    "macos")
        if command_exists brew; then
            if brew list cryptopp >/dev/null 2>&1; then
                success "Found crypto++ via Homebrew"
                CRYPTO_FOUND=true
                CRYPTO_METHODS_FOUND+=("homebrew")
            else
                warning "crypto++ not found via Homebrew"
            fi
        fi
        ;;
    "windows")
        if command_exists vcpkg && [ -n "$VCPKG_ROOT" ]; then
            if vcpkg list | grep -q cryptopp; then
                success "Found crypto++ via vcpkg"
                CRYPTO_FOUND=true
                CRYPTO_METHODS_FOUND+=("vcpkg")
            else
                warning "crypto++ not found via vcpkg"
            fi
        fi
        ;;
esac
echo ""

# Summary
echo "📊 VERIFICATION SUMMARY"
echo "======================="
if [ "$CRYPTO_FOUND" = true ]; then
    success "Crypto++ library is available!"
    echo "   Detection methods: ${CRYPTO_METHODS_FOUND[*]}"
    echo ""
    info "✅ Your system should be able to build projects that depend on Crypto++"
else
    error "Crypto++ library NOT found!"
    echo ""
    echo "📦 INSTALLATION RECOMMENDATIONS:"
    case $OS in
        "linux")
            echo "   Ubuntu/Debian: sudo apt-get install libcrypto++-dev"
            echo "   CentOS/RHEL:   sudo yum install cryptopp-devel"
            echo "   Fedora:        sudo dnf install cryptopp-devel"
            echo "   Arch Linux:    sudo pacman -S crypto++"
            ;;
        "macos")
            echo "   Homebrew:      brew install cryptopp"
            ;;
        "windows")
            echo "   vcpkg:         vcpkg install cryptopp"
            echo "   Or download from: https://github.com/weidai11/cryptopp/releases"
            ;;
    esac
    echo ""
    echo "🔨 BUILD FROM SOURCE (latest stable):"
    echo "   wget https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_9_0/cryptopp890.zip"
    echo "   unzip cryptopp890.zip && cd cryptopp"
    echo "   make -j\\$(nproc) && sudo make install"
    echo "   make -j\$(nproc) && sudo make install"
    echo ""
fi

# CMake test
echo "🧪 CMAKE COMPATIBILITY TEST"
echo "============================"
if command_exists cmake; then
    info "Testing CMake detection..."
    cd /tmp
    cat > test_crypto_cmake.txt << EOF
cmake_minimum_required(VERSION 3.10)
project(CryptoTest)
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(CRYPTOPP QUIET libcrypto++)
    if(NOT CRYPTOPP_FOUND)
        pkg_check_modules(CRYPTOPP QUIET cryptopp)
    endif()
    if(CRYPTOPP_FOUND)
        message(STATUS "CMake found crypto++ via pkg-config")
    else()
        find_library(CRYPTOPP_LIB NAMES cryptopp crypto++ libcrypto++)
        if(CRYPTOPP_LIB)
            message(STATUS "CMake found crypto++ library: \${CRYPTOPP_LIB}")
        else()
            message(FATAL_ERROR "CMake could not find crypto++")
        endif()
    endif()
else()
    find_library(CRYPTOPP_LIB NAMES cryptopp crypto++ libcrypto++)
    if(CRYPTOPP_LIB)
        message(STATUS "CMake found crypto++ library: \${CRYPTOPP_LIB}")
    else()
        message(FATAL_ERROR "CMake could not find crypto++")
    endif()
endif()
EOF
    
    if cmake -P test_crypto_cmake.txt 2>&1 | grep -q "found crypto++"; then
        success "CMake can successfully detect crypto++"
    else
        warning "CMake detection test failed"
        info "CMake output:"
        cmake -P test_crypto_cmake.txt 2>&1 | head -5
    fi
    rm -f test_crypto_cmake.txt
else
    warning "CMake not available for testing"
fi
echo ""

echo "🔧 ADDITIONAL DEBUG INFO"
echo "========================="
info "All available pkg-config packages containing 'crypto':"
pkg-config --list-all 2>/dev/null | grep -i crypto | head -5 || echo "None found"
echo ""
info "Crypto-related files in /usr/lib:"
find /usr/lib -name "*crypto*" -type f 2>/dev/null | head -5 || echo "None found"
echo ""
info "Environment variables:"
echo "   PKG_CONFIG_PATH: ${PKG_CONFIG_PATH:-not set}"
echo "   LD_LIBRARY_PATH: ${LD_LIBRARY_PATH:-not set}"
echo "   CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH:-not set}"

echo ""
echo "Verification completed!"

echo ""
echo "🔗 Useful Links:"
echo "   - Crypto++ website: https://cryptopp.com/"
echo "   - Installation guide: https://cryptopp.com/wiki/Linux"
echo "   - GitHub releases: https://github.com/weidai11/cryptopp/releases"

exit 0
