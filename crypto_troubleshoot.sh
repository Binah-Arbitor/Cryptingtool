#!/bin/bash

# crypto_troubleshoot.sh - Crypto++ Installation and Troubleshooting Script
#
# This script helps diagnose and resolve common Crypto++ build issues
# Based on Stack Overflow solutions for crypto++ problems
#
# Usage: ./crypto_troubleshoot.sh [--fix]
#   --fix: Automatically attempt to install Crypto++ if missing

set -e

echo "=== Crypto++ Troubleshooting Tool ==="
echo "Diagnosing common Crypto++ build issues..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_success() {
    print_status $GREEN "✅ $1"
}

print_warning() {
    print_status $YELLOW "⚠️  $1"
}

print_error() {
    print_status $RED "❌ $1"
}

print_info() {
    print_status $BLUE "ℹ️  $1"
}

# Check if --fix flag is provided
AUTO_FIX=false
if [[ "$1" == "--fix" ]]; then
    AUTO_FIX=true
    print_info "Auto-fix mode enabled"
fi

echo "1. Checking system information..."
print_info "OS: $(uname -s)"
print_info "Architecture: $(uname -m)"

if command -v lsb_release >/dev/null 2>&1; then
    print_info "Distribution: $(lsb_release -d | cut -f2)"
fi

echo ""

echo "2. Checking for Crypto++ headers..."

# Fast header check - direct paths only
HEADERS_FOUND=false
HEADER_PATH=""

# Check most common locations directly
if [[ -f "/usr/include/crypto++/cryptlib.h" ]]; then
    print_success "Found headers in /usr/include/crypto++/"
    HEADERS_FOUND=true
    HEADER_PATH="/usr/include/crypto++/"
elif [[ -f "/usr/include/cryptopp/cryptlib.h" ]]; then
    print_success "Found headers in /usr/include/cryptopp/"
    HEADERS_FOUND=true
    HEADER_PATH="/usr/include/cryptopp/"
elif [[ -f "/usr/local/include/crypto++/cryptlib.h" ]]; then
    print_success "Found headers in /usr/local/include/crypto++/"
    HEADERS_FOUND=true
    HEADER_PATH="/usr/local/include/crypto++/"
else
    print_error "Crypto++ headers not found in standard locations"
    HEADERS_FOUND=false
fi

echo ""

echo "3. Checking for Crypto++ libraries..."

# Fast library check using ldconfig and direct paths
LIBRARY_FOUND=false

# Use ldconfig for fast system library detection
if ldconfig -p 2>/dev/null | grep -q "libcryptopp\|libcrypto++"; then
    print_success "Found Crypto++ library in system cache"
    LIBRARY_FOUND=true
    # Show first found library
    FOUND_LIB=$(ldconfig -p 2>/dev/null | grep -E "libcryptopp|libcrypto++" | head -1 | awk '{print $NF}')
    if [[ -n "$FOUND_LIB" ]]; then
        print_success "Library path: $FOUND_LIB"
    fi
elif [[ -f "/usr/lib/x86_64-linux-gnu/libcryptopp.so" ]]; then
    print_success "Found library: /usr/lib/x86_64-linux-gnu/libcryptopp.so"
    LIBRARY_FOUND=true
fi

if [[ "$LIBRARY_FOUND" == false ]]; then
    print_error "Crypto++ libraries not found"
fi

echo ""

echo "4. Checking pkg-config..."

if command -v pkg-config >/dev/null 2>&1; then
    print_success "pkg-config is available"
    
    # Check for different pkg-config names
    if pkg-config --exists libcrypto++ 2>/dev/null; then
        print_success "pkg-config found libcrypto++"
        VERSION=$(pkg-config --modversion libcrypto++ 2>/dev/null || echo "unknown")
        print_info "Version: $VERSION"
    elif pkg-config --exists cryptopp 2>/dev/null; then
        print_success "pkg-config found cryptopp"
        VERSION=$(pkg-config --modversion cryptopp 2>/dev/null || echo "unknown")
        print_info "Version: $VERSION"
    else
        print_warning "pkg-config cannot find Crypto++ package"
    fi
else
    print_warning "pkg-config not available"
fi

echo ""

echo "5. Checking compiler compatibility..."

if command -v g++ >/dev/null 2>&1; then
    GCC_VERSION=$(g++ --version | head -n1)
    print_success "g++ available: $GCC_VERSION"
    
    # Only do compilation test if explicitly requested or if there were issues
    if [[ "$1" == "--test-compile" ]] || [[ "$HEADERS_FOUND" == true && "$LIBRARY_FOUND" == false ]]; then
        print_info "Running compilation test..."
        
        # Create a simple test file
        TEST_FILE=$(mktemp --suffix=.cpp)
        cat > "$TEST_FILE" << 'EOF'
#include "crypto_compat.h"
int main() {
    CryptoPP::AutoSeededRandomPool rng;
    return 0;
}
EOF
        
        # Try to compile with different flags
        COMPILE_SUCCESS=false
        
        # Test compilation with different library names
        for lib in cryptopp crypto++; do
            if g++ -I./include -std=c++11 "$TEST_FILE" -l$lib -o /tmp/test_crypto 2>/dev/null; then
                print_success "Compilation test passed with -l$lib"
                COMPILE_SUCCESS=true
                rm -f /tmp/test_crypto
                break
            fi
        done
        
        rm -f "$TEST_FILE"
        
        if [[ "$COMPILE_SUCCESS" == false ]]; then
            print_warning "Compilation test failed - may have linking issues"
        fi
    else
        print_info "Skipping compilation test (use --test-compile to force)"
    fi
else
    print_error "g++ compiler not found"
fi

echo ""

# Summary and recommendations
echo "=== DIAGNOSIS SUMMARY ==="
echo ""

ISSUES_FOUND=false

if [[ "$HEADERS_FOUND" == false ]]; then
    print_error "Headers not found - Crypto++ is not installed"
    ISSUES_FOUND=true
fi

if [[ "$LIBRARY_FOUND" == false ]]; then
    print_error "Libraries not found - Crypto++ development packages missing"
    ISSUES_FOUND=true
fi

if [[ "$ISSUES_FOUND" == false ]]; then
    print_success "Crypto++ appears to be properly installed!"
    print_info "If you're still having issues, check your CMakeLists.txt configuration"
    exit 0
fi

echo ""
echo "=== RECOMMENDED SOLUTIONS ==="
echo ""

# Detect OS and provide specific instructions
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    
    case "$ID" in
        ubuntu|debian)
            print_info "Ubuntu/Debian detected"
            echo "Install command: sudo apt-get install libcrypto++-dev"
            
            if [[ "$AUTO_FIX" == true ]]; then
                print_info "Auto-installing Crypto++..."
                sudo apt-get update && sudo apt-get install -y libcrypto++-dev
            fi
            ;;
        centos|rhel|rocky)
            print_info "CentOS/RHEL detected"
            echo "Install command: sudo yum install cryptopp-devel"
            
            if [[ "$AUTO_FIX" == true ]]; then
                print_info "Auto-installing Crypto++..."
                sudo yum install -y cryptopp-devel
            fi
            ;;
        fedora)
            print_info "Fedora detected"
            echo "Install command: sudo dnf install cryptopp-devel"
            
            if [[ "$AUTO_FIX" == true ]]; then
                print_info "Auto-installing Crypto++..."
                sudo dnf install -y cryptopp-devel
            fi
            ;;
        arch)
            print_info "Arch Linux detected"
            echo "Install command: sudo pacman -S crypto++"
            
            if [[ "$AUTO_FIX" == true ]]; then
                print_info "Auto-installing Crypto++..."
                sudo pacman -S --noconfirm crypto++
            fi
            ;;
        *)
            print_info "Unknown Linux distribution"
            echo "Try building from source:"
            echo "  wget https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_9_0/cryptopp890.zip"
            echo "  unzip cryptopp890.zip && cd cryptopp"
            echo "  make -j\$(nproc) && sudo make install"
            echo "  sudo ldconfig"
            ;;
    esac
elif [[ "$(uname)" == "Darwin" ]]; then
    print_info "macOS detected"
    echo "Install with Homebrew: brew install cryptopp"
    
    if [[ "$AUTO_FIX" == true ]]; then
        if command -v brew >/dev/null 2>&1; then
            print_info "Auto-installing Crypto++..."
            brew install cryptopp
        else
            print_error "Homebrew not found. Please install Homebrew first."
        fi
    fi
elif [[ "$(uname)" == "MINGW"* ]] || [[ "$(uname)" == "CYGWIN"* ]]; then
    print_info "Windows detected"
    echo "Install with vcpkg: vcpkg install cryptopp"
fi

echo ""

if [[ "$AUTO_FIX" == false ]]; then
    echo "To automatically attempt installation, run:"
    echo "  ./crypto_troubleshoot.sh --fix"
fi

echo ""
print_info "After installation, run 'cmake ..' again to reconfigure the build"
print_info "For more help, see: https://cryptopp.com/wiki/Linux"