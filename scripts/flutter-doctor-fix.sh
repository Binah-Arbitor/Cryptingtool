#!/bin/bash
set -e

echo "🩺 Flutter Doctor Issue Resolver"
echo "==============================="
echo ""
echo "This script addresses common Flutter doctor issues for CryptingTool development."
echo ""

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

echo "📋 Detected OS: $OS"
echo ""

# Issue 1: GTK 3.0 development libraries for Linux desktop
echo "🔍 Issue 1: GTK 3.0 development libraries (Linux desktop requirement)"
echo "--------------------------------------------------------------------"
if [ "$OS" = "linux" ]; then
    if pkg-config --exists gtk+-3.0 2>/dev/null; then
        GTK_VERSION=$(pkg-config --modversion gtk+-3.0 2>/dev/null || echo "unknown")
        echo "✅ GTK 3.0 development libraries are installed (version: $GTK_VERSION)"
        echo "   This resolves the Flutter doctor error: '✗ GTK 3.0 development libraries are required for Linux development'"
    else
        echo "❌ GTK 3.0 development libraries are missing"
        echo ""
        echo "💡 This causes Flutter doctor to show:"
        echo "   [✗] Linux toolchain - develop for Linux desktop"
        echo "       ✗ GTK 3.0 development libraries are required for Linux development."
        echo ""
        echo "🔧 To fix this issue:"
        echo ""
        case $(lsb_release -si 2>/dev/null || echo "Unknown") in
            "Ubuntu"|"Debian")
                echo "   sudo apt-get update"
                echo "   sudo apt-get install libgtk-3-dev mesa-utils"
                ;;
            "CentOS"|"RHEL"|"Fedora")
                echo "   sudo yum install gtk3-devel mesa-dri-drivers"
                echo "   # Or on newer versions:"
                echo "   sudo dnf install gtk3-devel mesa-dri-drivers"
                ;;
            "Arch")
                echo "   sudo pacman -S gtk3"
                ;;
            *)
                echo "   # For Ubuntu/Debian:"
                echo "   sudo apt-get install libgtk-3-dev mesa-utils"
                echo ""
                echo "   # For CentOS/RHEL/Fedora:"
                echo "   sudo yum install gtk3-devel mesa-dri-drivers"
                echo ""
                echo "   # For Arch Linux:"
                echo "   sudo pacman -S gtk3"
                ;;
        esac
        
        # Offer automatic installation
        echo ""
        read -p "🚀 Would you like to attempt automatic installation? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🔄 Attempting to install GTK 3.0 development libraries..."
            case $(lsb_release -si 2>/dev/null || echo "Unknown") in
                "Ubuntu"|"Debian")
                    sudo apt-get update && sudo apt-get install -y libgtk-3-dev mesa-utils
                    ;;
                "CentOS"|"RHEL"|"Fedora")
                    if command_exists dnf; then
                        sudo dnf install -y gtk3-devel mesa-dri-drivers
                    else
                        sudo yum install -y gtk3-devel mesa-dri-drivers
                    fi
                    ;;
                "Arch")
                    sudo pacman -S --noconfirm gtk3
                    ;;
                *)
                    echo "❌ Automatic installation not supported for your distribution"
                    echo "   Please run the appropriate command manually"
                    ;;
            esac
            
            # Re-check after installation
            if pkg-config --exists gtk+-3.0 2>/dev/null; then
                GTK_VERSION=$(pkg-config --modversion gtk+-3.0 2>/dev/null || echo "unknown")
                echo "✅ Successfully installed GTK 3.0 development libraries (version: $GTK_VERSION)"
            else
                echo "❌ Installation may have failed. Please check manually."
            fi
        fi
    fi
else
    echo "ℹ️  GTK 3.0 checking is only relevant for Linux systems"
    echo "   Your OS ($OS) does not require GTK for Flutter desktop development"
fi

echo ""
echo ""

# Issue 2: Android Studio
echo "🔍 Issue 2: Android Studio (optional development environment)"
echo "-----------------------------------------------------------"

# Check for Android Studio installation
ANDROID_STUDIO_PATHS=(
    "/opt/android-studio/bin/studio.sh"
    "/usr/local/android-studio/bin/studio.sh"
    "$HOME/android-studio/bin/studio.sh"
    "/snap/android-studio/current/bin/studio.sh"
    "/Applications/Android Studio.app/Contents/bin/studio.sh"
    "/Applications/Android Studio.app"
)

ANDROID_STUDIO_FOUND=false
FOUND_PATH=""

for studio_path in "${ANDROID_STUDIO_PATHS[@]}"; do
    if [ -f "$studio_path" ] || [ -d "$studio_path" ]; then
        echo "✅ Android Studio found at: $studio_path"
        ANDROID_STUDIO_FOUND=true
        FOUND_PATH="$studio_path"
        break
    fi
done

if [ "$ANDROID_STUDIO_FOUND" = false ]; then
    echo "❌ Android Studio not found"
    echo ""
    echo "💡 This causes Flutter doctor to show:"
    echo "   [!] Android Studio (not installed)"
    echo ""
    echo "🔧 To fix this issue:"
    echo ""
    echo "   Option 1: Install Android Studio (recommended for Android development)"
    echo "   • Download from: https://developer.android.com/studio"
    echo "   • Follow the installation guide for your OS"
    echo ""
    echo "   Option 2: Use alternative IDE (VS Code, IntelliJ IDEA, etc.)"
    echo "   • Install Flutter and Dart plugins"
    echo "   • Android Studio is not strictly required if you don't develop for Android"
    echo ""
    echo "   Option 3: Command-line only development"
    echo "   • You can develop without any IDE using flutter commands"
    echo "   • Ensure Android SDK is properly configured if targeting Android"
    
    echo ""
    read -p "🌐 Would you like to open the Android Studio download page? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command_exists xdg-open; then
            xdg-open "https://developer.android.com/studio" 2>/dev/null &
        elif command_exists open; then
            open "https://developer.android.com/studio" 2>/dev/null &
        else
            echo "🔗 Please manually visit: https://developer.android.com/studio"
        fi
    fi
else
    echo "   This resolves the Flutter doctor warning: '[!] Android Studio (not installed)'"
fi

echo ""
echo ""

# Summary and next steps
echo "📋 Summary"
echo "=========="
echo ""
echo "✅ Completed Flutter doctor issue analysis"
echo ""
echo "🔄 Next Steps:"
echo "   1. Run 'flutter doctor -v' to verify the fixes"
echo "   2. If issues persist, run './scripts/troubleshoot.sh' for detailed diagnostics"
echo "   3. Check './scripts/check-dependencies.sh' for other dependency issues"
echo ""
echo "🎯 After resolving these issues, you should be able to:"
echo "   • Build Flutter apps for Linux desktop: flutter build linux"
echo "   • Develop with enhanced IDE support (if Android Studio is installed)"
echo ""
echo "🔗 Additional Resources:"
echo "   • Flutter Linux desktop: https://docs.flutter.dev/platform-integration/linux/building"
echo "   • Flutter doctor troubleshooting: https://docs.flutter.dev/get-started/install/linux#run-flutter-doctor"
echo ""

if command_exists flutter; then
    echo "🩺 Running Flutter doctor for verification..."
    echo ""
    flutter doctor
else
    echo "⚠️  Flutter is not installed. Install Flutter first to verify these fixes."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
fi

echo ""
echo "✅ Flutter Doctor Issue Resolver completed!"