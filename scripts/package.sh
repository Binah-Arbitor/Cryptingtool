#!/bin/bash
set -e

TARGET_PLATFORM=$1
APP_NAME=$2
OUTPUT_PATH=$3
INCLUDE_CPP_LIBS=$4

echo "Packaging application for $TARGET_PLATFORM..."
echo "App Name: $APP_NAME"
echo "Output Path: $OUTPUT_PATH"
echo "Include C++ Libraries: $INCLUDE_CPP_LIBS"

# Create output directory
mkdir -p "$OUTPUT_PATH"

# Package based on platform
case $TARGET_PLATFORM in
    "android")
        echo "Packaging Android APK..."
        PACKAGE_DIR="$OUTPUT_PATH/android"
        mkdir -p "$PACKAGE_DIR"
        
        # Copy APK files
        if [ -d "build/flutter" ]; then
            find build/flutter -name "*.apk" -exec cp {} "$PACKAGE_DIR/${APP_NAME}.apk" \;
        fi
        
        # Copy C++ libraries if requested
        if [ "$INCLUDE_CPP_LIBS" = "true" ] && [ -d "build/cpp" ]; then
            mkdir -p "$PACKAGE_DIR/libs"
            find build/cpp -name "*.so" -exec cp {} "$PACKAGE_DIR/libs/" \;
        fi
        
        PACKAGE_PATH="$PACKAGE_DIR/${APP_NAME}.apk"
        ;;
        
    "ios")
        echo "Packaging iOS app..."
        PACKAGE_DIR="$OUTPUT_PATH/ios"
        mkdir -p "$PACKAGE_DIR"
        
        # Copy iOS build
        if [ -d "build/flutter/ios-build" ]; then
            cp -r build/flutter/ios-build "$PACKAGE_DIR/${APP_NAME}.app"
        fi
        
        # Copy C++ libraries if requested
        if [ "$INCLUDE_CPP_LIBS" = "true" ] && [ -d "build/cpp" ]; then
            mkdir -p "$PACKAGE_DIR/${APP_NAME}.app/Frameworks"
            find build/cpp -name "*.dylib" -exec cp {} "$PACKAGE_DIR/${APP_NAME}.app/Frameworks/" \;
        fi
        
        PACKAGE_PATH="$PACKAGE_DIR/${APP_NAME}.app"
        ;;
        
    "linux")
        echo "Packaging Linux application..."
        PACKAGE_DIR="$OUTPUT_PATH/linux"
        mkdir -p "$PACKAGE_DIR"
        
        # Copy Linux bundle
        if [ -d "build/flutter/linux-bundle" ]; then
            cp -r build/flutter/linux-bundle "$PACKAGE_DIR/${APP_NAME}"
        fi
        
        # Copy C++ libraries if requested
        if [ "$INCLUDE_CPP_LIBS" = "true" ] && [ -d "build/cpp" ]; then
            mkdir -p "$PACKAGE_DIR/${APP_NAME}/lib"
            find build/cpp -name "*.so" -exec cp {} "$PACKAGE_DIR/${APP_NAME}/lib/" \;
        fi
        
        # Create launcher script
        cat > "$PACKAGE_DIR/${APP_NAME}/launch.sh" << EOL
#!/bin/bash
cd "\$(dirname "\$0")"
export LD_LIBRARY_PATH=./lib:\$LD_LIBRARY_PATH
./${APP_NAME}
EOL
        chmod +x "$PACKAGE_DIR/${APP_NAME}/launch.sh"
        
        # Create tar.gz package
        cd "$OUTPUT_PATH"
        tar -czf "${APP_NAME}-linux.tar.gz" linux/
        PACKAGE_PATH="$OUTPUT_PATH/${APP_NAME}-linux.tar.gz"
        cd - > /dev/null
        ;;
        
    "windows")
        echo "Packaging Windows application..."
        PACKAGE_DIR="$OUTPUT_PATH/windows"
        mkdir -p "$PACKAGE_DIR"
        
        # Copy Windows release
        if [ -d "build/flutter/windows-release" ]; then
            cp -r build/flutter/windows-release "$PACKAGE_DIR/${APP_NAME}"
        fi
        
        # Copy C++ libraries if requested
        if [ "$INCLUDE_CPP_LIBS" = "true" ] && [ -d "build/cpp" ]; then
            find build/cpp -name "*.dll" -exec cp {} "$PACKAGE_DIR/${APP_NAME}/" \;
            find build/cpp -name "*.lib" -exec cp {} "$PACKAGE_DIR/${APP_NAME}/" \;
        fi
        
        # Create zip package
        cd "$OUTPUT_PATH"
        zip -r "${APP_NAME}-windows.zip" windows/
        PACKAGE_PATH="$OUTPUT_PATH/${APP_NAME}-windows.zip"
        cd - > /dev/null
        ;;
        
    "macos")
        echo "Packaging macOS application..."
        PACKAGE_DIR="$OUTPUT_PATH/macos"
        mkdir -p "$PACKAGE_DIR"
        
        # Copy macOS release
        if [ -d "build/flutter/macos-release" ]; then
            cp -r build/flutter/macos-release "$PACKAGE_DIR/${APP_NAME}.app"
        fi
        
        # Copy C++ libraries if requested
        if [ "$INCLUDE_CPP_LIBS" = "true" ] && [ -d "build/cpp" ]; then
            mkdir -p "$PACKAGE_DIR/${APP_NAME}.app/Contents/Frameworks"
            find build/cpp -name "*.dylib" -exec cp {} "$PACKAGE_DIR/${APP_NAME}.app/Contents/Frameworks/" \;
        fi
        
        # Create DMG package (simplified)
        cd "$OUTPUT_PATH"
        tar -czf "${APP_NAME}-macos.tar.gz" macos/
        PACKAGE_PATH="$OUTPUT_PATH/${APP_NAME}-macos.tar.gz"
        cd - > /dev/null
        ;;
        
    "web")
        echo "Packaging Web application..."
        PACKAGE_DIR="$OUTPUT_PATH/web"
        mkdir -p "$PACKAGE_DIR"
        
        # Copy web build
        if [ -d "build/flutter/web-build" ]; then
            cp -r build/flutter/web-build "$PACKAGE_DIR/${APP_NAME}-web"
        fi
        
        # Create zip package
        cd "$OUTPUT_PATH"
        zip -r "${APP_NAME}-web.zip" web/
        PACKAGE_PATH="$OUTPUT_PATH/${APP_NAME}-web.zip"
        cd - > /dev/null
        ;;
        
    *)
        echo "Unsupported platform: $TARGET_PLATFORM"
        exit 1
        ;;
esac

# Calculate package size
if [ -f "$PACKAGE_PATH" ]; then
    PACKAGE_SIZE=$(du -h "$PACKAGE_PATH" | cut -f1)
elif [ -d "$PACKAGE_PATH" ]; then
    PACKAGE_SIZE=$(du -sh "$PACKAGE_PATH" | cut -f1)
else
    PACKAGE_SIZE="0"
fi

echo "Packaging completed!"
echo "Package path: $PACKAGE_PATH"
echo "Package size: $PACKAGE_SIZE"

# Set GitHub Action outputs
echo "path=$PACKAGE_PATH" >> $GITHUB_OUTPUT
echo "size=$PACKAGE_SIZE" >> $GITHUB_OUTPUT

# List package contents
echo "Package contents:"
ls -la "$OUTPUT_PATH"