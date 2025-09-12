#!/bin/bash
# Enhanced SDK verification script for diagnosing installation issues
set -e

echo "🔍 Comprehensive SDK Verification Tool"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "success") echo -e "${GREEN}✅ $message${NC}" ;;
        "error") echo -e "${RED}❌ $message${NC}" ;;
        "warning") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "info") echo -e "${BLUE}ℹ️  $message${NC}" ;;
    esac
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

print_status "info" "Detected OS: $OS"
echo ""

# Check system information
echo "🖥️  System Information"
echo "--------------------"
print_status "info" "OS Type: $OSTYPE"
print_status "info" "Architecture: $(uname -m 2>/dev/null || echo 'Unknown')"
print_status "info" "User: $(whoami 2>/dev/null || echo 'Unknown')"

if command -v free >/dev/null 2>&1; then
    MEMORY=$(free -h | grep '^Mem:' | awk '{print $2}')
    print_status "info" "Memory: $MEMORY"
fi

echo ""

# Check Flutter installation
echo "🐦 Flutter SDK Verification"
echo "---------------------------"

if command -v flutter >/dev/null 2>&1; then
    FLUTTER_VERSION=$(flutter --version 2>&1 | head -1 | cut -d' ' -f2 || echo "unknown")
    print_status "success" "Flutter found - Version: $FLUTTER_VERSION"
    
    # Get Flutter installation path
    FLUTTER_PATH=$(which flutter 2>/dev/null || echo "Unknown")
    print_status "info" "Flutter path: $FLUTTER_PATH"
    
    # Check Flutter doctor
    echo ""
    print_status "info" "Running Flutter doctor..."
    DOCTOR_OUTPUT=$(flutter doctor -v 2>&1 || echo "Flutter doctor failed")
    
    # Parse doctor output for key information
    if echo "$DOCTOR_OUTPUT" | grep -q "Flutter.*✓"; then
        print_status "success" "Flutter SDK is properly installed"
    else
        print_status "error" "Flutter SDK has issues"
    fi
    
    # Check Android toolchain
    if echo "$DOCTOR_OUTPUT" | grep -q "Android toolchain.*✓"; then
        print_status "success" "Android toolchain is properly configured"
    elif echo "$DOCTOR_OUTPUT" | grep -q "Android toolchain.*✗"; then
        print_status "error" "Android toolchain has critical issues"
        echo "$DOCTOR_OUTPUT" | grep -A 5 "Android toolchain" | head -6
    elif echo "$DOCTOR_OUTPUT" | grep -q "Android toolchain.*!"; then
        print_status "warning" "Android toolchain has warnings"
        echo "$DOCTOR_OUTPUT" | grep -A 5 "Android toolchain" | head -6
    else
        print_status "warning" "Android toolchain not found or unclear status"
    fi
    
    # Check for license issues
    if echo "$DOCTOR_OUTPUT" | grep -q "licenses.*not.*accepted"; then
        print_status "error" "Android SDK licenses not accepted"
        LICENSES_LINE=$(echo "$DOCTOR_OUTPUT" | grep "licenses.*not.*accepted" | head -1)
        print_status "info" "$LICENSES_LINE"
        echo "💡 Fix with: flutter doctor --android-licenses"
        echo "💡 Or run: ./scripts/accept-android-licenses.ps1 (Windows)"
        echo "💡 Or run: ./scripts/accept-android-licenses.bat (Windows CMD)"
        echo ""
        print_status "info" "Available license acceptance methods:"
        echo "   1. PowerShell script: ./scripts/accept-android-licenses.ps1"
        echo "   2. Batch file: ./scripts/accept-android-licenses.bat" 
        echo "   3. Manual: flutter doctor --android-licenses"
        echo "   4. Stack Overflow method: (echo y;echo y;echo y;echo y;echo y;echo y;echo y) | flutter doctor --android-licenses"
    else
        print_status "success" "Android SDK licenses appear to be accepted"
    fi
    
    # Check for cmdline-tools
    if echo "$DOCTOR_OUTPUT" | grep -q "cmdline-tools.*not.*available"; then
        print_status "error" "Android command-line tools not available"
        echo "💡 Install Android SDK command-line tools"
    else
        print_status "success" "Android command-line tools available"
    fi
    
else
    print_status "error" "Flutter not found in PATH"
    echo "💡 Install Flutter SDK from: https://docs.flutter.dev/get-started/install"
fi

echo ""

# Check Android SDK
echo "📱 Android SDK Verification"
echo "---------------------------"

# Check environment variables
if [ -n "$ANDROID_HOME" ]; then
    print_status "success" "ANDROID_HOME set: $ANDROID_HOME"
    SDK_PATH="$ANDROID_HOME"
elif [ -n "$ANDROID_SDK_ROOT" ]; then
    print_status "success" "ANDROID_SDK_ROOT set: $ANDROID_SDK_ROOT"
    SDK_PATH="$ANDROID_SDK_ROOT"
else
    print_status "warning" "ANDROID_HOME/ANDROID_SDK_ROOT not set"
    SDK_PATH=""
    
    # Try to find SDK in common locations
    COMMON_PATHS=(
        "$HOME/Android/Sdk"
        "$HOME/Library/Android/sdk"
        "/usr/local/android-sdk"
        "/opt/android-sdk"
        "C:/Users/$USER/AppData/Local/Android/Sdk"
        "$LOCALAPPDATA/Android/Sdk"
    )
    
    for path in "${COMMON_PATHS[@]}"; do
        if [ -d "$path" ]; then
            print_status "info" "Found potential Android SDK at: $path"
            SDK_PATH="$path"
            break
        fi
    done
fi

if [ -n "$SDK_PATH" ] && [ -d "$SDK_PATH" ]; then
    print_status "success" "Android SDK directory found: $SDK_PATH"
    
    # Check SDK components
    echo ""
    print_status "info" "Checking SDK components..."
    
    # Platforms
    if [ -d "$SDK_PATH/platforms" ]; then
        PLATFORMS=$(ls -1 "$SDK_PATH/platforms" 2>/dev/null | sort -V)
        PLATFORM_COUNT=$(echo "$PLATFORMS" | wc -l)
        print_status "success" "Android platforms ($PLATFORM_COUNT): $(echo $PLATFORMS | tr '\n' ' ')"
        
        # Check for recent platforms
        if echo "$PLATFORMS" | grep -q "android-3[4-9]\|android-[4-9][0-9]"; then
            print_status "success" "Recent Android API levels available"
        else
            print_status "warning" "Consider updating to newer Android API levels"
        fi
    else
        print_status "error" "No Android platforms found"
    fi
    
    # Build tools
    if [ -d "$SDK_PATH/build-tools" ]; then
        BUILD_TOOLS=$(ls -1 "$SDK_PATH/build-tools" 2>/dev/null | sort -V)
        BUILD_TOOLS_COUNT=$(echo "$BUILD_TOOLS" | wc -l)
        LATEST_BUILD_TOOL=$(echo "$BUILD_TOOLS" | tail -1)
        print_status "success" "Build tools ($BUILD_TOOLS_COUNT): Latest is $LATEST_BUILD_TOOL"
    else
        print_status "error" "No build tools found"
    fi
    
    # Command line tools
    if [ -d "$SDK_PATH/cmdline-tools" ]; then
        CMDTOOLS=$(ls -1 "$SDK_PATH/cmdline-tools" 2>/dev/null)
        print_status "success" "Command-line tools: $CMDTOOLS"
        
        # Check for sdkmanager
        for version in latest $(echo "$CMDTOOLS"); do
            SDKMANAGER="$SDK_PATH/cmdline-tools/$version/bin/sdkmanager"
            if [ -f "$SDKMANAGER" ]; then
                print_status "success" "SDK manager found: $SDKMANAGER"
                break
            fi
        done
    else
        print_status "error" "Command-line tools not found"
    fi
    
    # Tools (legacy)
    if [ -d "$SDK_PATH/tools" ]; then
        print_status "info" "Legacy tools directory found"
    fi
    
    # Check disk space
    if command -v du >/dev/null 2>&1; then
        SDK_SIZE=$(du -sh "$SDK_PATH" 2>/dev/null | cut -f1)
        print_status "info" "SDK size: $SDK_SIZE"
    fi
    
else
    print_status "error" "Android SDK not found"
    echo "💡 Install Android SDK or set ANDROID_HOME/ANDROID_SDK_ROOT"
fi

echo ""

# Check Java
echo "☕ Java Verification"
echo "-------------------"

if command -v java >/dev/null 2>&1; then
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    print_status "success" "Java found: $JAVA_VERSION"
    
    if [ -n "$JAVA_HOME" ]; then
        print_status "success" "JAVA_HOME set: $JAVA_HOME"
    else
        print_status "warning" "JAVA_HOME not set"
    fi
    
    # Check Java version compatibility
    if echo "$JAVA_VERSION" | grep -q "version \"1[7-9]\.\|version \"[2-9][0-9]\."; then
        print_status "success" "Java version is compatible (Java 17+ recommended)"
    else
        print_status "warning" "Java version may be too old (Java 17+ recommended)"
    fi
else
    print_status "error" "Java not found"
    echo "💡 Install Java 17+ from: https://adoptium.net/"
fi

echo ""

# Check Gradle
echo "🐘 Gradle Verification"
echo "----------------------"

if command -v gradle >/dev/null 2>&1; then
    GRADLE_VERSION=$(gradle --version 2>/dev/null | grep "Gradle" | head -1)
    print_status "success" "Gradle found: $GRADLE_VERSION"
else
    print_status "warning" "Gradle not found in PATH (will be downloaded by Flutter)"
fi

echo ""

# Platform-specific checks
echo "🔧 Platform-Specific Checks"
echo "---------------------------"

case $OS in
    "linux")
        # Check essential packages
        REQUIRED_PACKAGES=("build-essential" "cmake" "ninja-build" "pkg-config")
        
        if command -v dpkg >/dev/null 2>&1; then
            for pkg in "${REQUIRED_PACKAGES[@]}"; do
                if dpkg -l | grep -q "^ii.*$pkg "; then
                    print_status "success" "Package installed: $pkg"
                else
                    print_status "warning" "Package missing: $pkg"
                fi
            done
        fi
        ;;
    "macos")
        # Check Xcode and command line tools
        if xcode-select -p >/dev/null 2>&1; then
            XCODE_PATH=$(xcode-select -p)
            print_status "success" "Xcode command line tools: $XCODE_PATH"
        else
            print_status "error" "Xcode command line tools not installed"
            echo "💡 Install with: xcode-select --install"
        fi
        
        # Check Homebrew
        if command -v brew >/dev/null 2>&1; then
            BREW_VERSION=$(brew --version | head -1)
            print_status "success" "Homebrew found: $BREW_VERSION"
        else
            print_status "warning" "Homebrew not found"
        fi
        ;;
    "windows")
        # Check Visual Studio Build Tools
        if command -v cl >/dev/null 2>&1; then
            print_status "success" "Visual Studio compiler found"
        else
            print_status "warning" "Visual Studio compiler not found"
        fi
        
        # Check Chocolatey
        if command -v choco >/dev/null 2>&1; then
            print_status "success" "Chocolatey found"
        else
            print_status "warning" "Chocolatey not found"
        fi
        ;;
esac

echo ""

# Summary and recommendations
echo "📋 Summary and Recommendations"
echo "==============================="

CRITICAL_ISSUES=0
WARNINGS=0

# Count issues from the checks above (simplified)
if ! command -v flutter >/dev/null 2>&1; then
    ((CRITICAL_ISSUES++))
fi

if [ -z "$SDK_PATH" ] || [ ! -d "$SDK_PATH" ]; then
    ((CRITICAL_ISSUES++))
fi

if ! command -v java >/dev/null 2>&1; then
    ((CRITICAL_ISSUES++))
fi

if [ $CRITICAL_ISSUES -eq 0 ]; then
    print_status "success" "No critical issues found! SDK environment looks good."
    echo ""
    print_status "info" "For Android license issues, use enhanced scripts:"
    echo "   • Windows PowerShell: ./scripts/accept-android-licenses.ps1"
    echo "   • Windows CMD: ./scripts/accept-android-licenses.bat"
    echo "   • Manual: flutter doctor --android-licenses"
    echo "   • Stack Overflow method: (echo y;echo y;echo y;echo y;echo y;echo y;echo y) | flutter doctor --android-licenses"
else
    print_status "error" "Found $CRITICAL_ISSUES critical issue(s) that need to be fixed."
    echo ""
    print_status "info" "Common fixes for SDK issues:"
    echo "   1. Install missing SDKs (Flutter, Android SDK, Java)"
    echo "   2. Set environment variables (ANDROID_HOME, JAVA_HOME)"
    echo "   3. Accept Android licenses using enhanced scripts:"
    echo "      • ./scripts/accept-android-licenses.ps1 (Windows)"
    echo "      • ./scripts/accept-android-licenses.bat (Windows CMD)"
    echo "   4. Run: flutter doctor --android-licenses"
fi

echo ""
print_status "info" "Verification completed. Check the output above for specific issues and solutions."
echo ""
print_status "info" "📚 Additional Resources for License Issues:"
echo "   • Enhanced license acceptance scripts in ./scripts/ directory"
echo "   • Stack Overflow Android License Solutions"
echo "   • Flutter doctor troubleshooting guide"
echo "   • GitHub Actions Windows environment best practices"
echo ""

# Save results to a file
REPORT_FILE="sdk_verification_report.txt"
echo "Saving detailed report to: $REPORT_FILE"
{
    echo "SDK Verification Report"
    echo "======================"
    echo "Date: $(date)"
    echo "OS: $OS ($OSTYPE)"
    echo ""
    if command -v flutter >/dev/null 2>&1; then
        echo "Flutter: $(flutter --version | head -1)"
    else
        echo "Flutter: Not found"
    fi
    echo "Java: $(java -version 2>&1 | head -1 2>/dev/null || echo "Not found")"
    echo "Android SDK: ${SDK_PATH:-"Not found"}"
    echo ""
    echo "Critical Issues: $CRITICAL_ISSUES"
    echo "Warnings: $WARNINGS"
    echo ""
    echo "Full Flutter Doctor Output:"
    echo "---------------------------"
    flutter doctor -v 2>&1 || echo "Flutter doctor failed"
} > "$REPORT_FILE"

print_status "success" "SDK verification completed!"