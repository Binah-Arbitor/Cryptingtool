#!/bin/bash

# CryptingTool Icon Generation Script
# This script helps set up the icon generation process for the CryptingTool app

echo "CryptingTool Icon Setup Script"
echo "=============================="

# Check if flutter_launcher_icons is available
echo "Checking for flutter_launcher_icons package..."
if grep -q "flutter_launcher_icons" pubspec.yaml; then
    echo "✓ flutter_launcher_icons found in pubspec.yaml"
else
    echo "✗ flutter_launcher_icons not found. Please run: flutter pub add dev:flutter_launcher_icons"
    exit 1
fi

# Create icon directories
echo "Creating icon directories..."
mkdir -p assets/icons
mkdir -p android/app/src/main/res/{mipmap-hdpi,mipmap-mdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi}

echo "✓ Directories created"

# Check for master icon files
if [ ! -f "assets/icons/app_icon.png" ]; then
    echo "⚠️  Master icon file missing: assets/icons/app_icon.png"
    echo "   Please create this file according to ICON_SPECIFICATION.md"
    echo "   Required size: 1024x1024 pixels"
fi

if [ ! -f "assets/icons/app_icon_foreground.png" ]; then
    echo "⚠️  Adaptive icon foreground missing: assets/icons/app_icon_foreground.png"
    echo "   Please create this file for Android adaptive icons"
    echo "   Required size: 1024x1024 pixels with transparent background"
fi

echo ""
echo "Next Steps:"
echo "1. Create the master icon files as specified in ICON_SPECIFICATION.md"
echo "2. Run: flutter pub get"
echo "3. Run: flutter pub run flutter_launcher_icons:main"
echo "4. Test the generated icons on Android device/emulator"
echo ""
echo "Icon Design Requirements Summary:"
echo "- CPU chip with glowing keyhole symbol"
echo "- Dark circuit board background"
echo "- Teal glow effect from keyhole"
echo "- Metallic CPU surface with faint teal edge outline"
echo "- PCB traces connecting to CPU pins"

# Generate placeholder icons (text-based description for now)
cat > assets/icons/README.md << 'EOF'
# Icon Assets

This directory should contain the master icon files for the CryptingTool app.

## Required Files:

### app_icon.png (1024x1024)
The main app icon featuring:
- CPU chip (top-down view) with metallic appearance
- Dark circuit board background with copper traces  
- Glowing keyhole symbol in center of CPU
- Teal edge highlights on CPU

### app_icon_foreground.png (1024x1024)
Adaptive icon foreground layer:
- Same CPU chip and keyhole design
- Transparent background
- Optimized for circular/square/rounded masks

## Generation:
After creating these files, run:
```bash
flutter pub run flutter_launcher_icons:main
```

This will generate all required icon sizes for Android.
EOF

echo "✓ Setup complete! Please create the actual icon files according to the specification."