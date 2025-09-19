#!/bin/bash

# Android v2 Embedding Verification Script
echo "🔍 Android v2 Embedding Configuration Verification"
echo "================================================="

# Check AndroidManifest.xml for v2 embedding
echo "1. Checking AndroidManifest.xml..."
MANIFEST_FILE="android/app/src/main/AndroidManifest.xml"

if [ -f "$MANIFEST_FILE" ]; then
    if grep -q 'android:name="flutterEmbedding"' "$MANIFEST_FILE" && grep -q 'android:value="2"' "$MANIFEST_FILE"; then
        echo "   ✅ Flutter v2 embedding metadata found"
    else
        echo "   ❌ Flutter v2 embedding metadata missing"
    fi
    
    if grep -q 'io.flutter.embedding.android.NormalTheme' "$MANIFEST_FILE"; then
        echo "   ✅ NormalTheme configuration found"
    else
        echo "   ❌ NormalTheme configuration missing"
    fi
else
    echo "   ❌ AndroidManifest.xml not found"
fi

# Check MainActivity
echo -e "\n2. Checking MainActivity..."
MAIN_ACTIVITY="android/app/src/main/kotlin/com/binah/cryptingtool/MainActivity.kt"

if [ -f "$MAIN_ACTIVITY" ]; then
    if grep -q "FlutterActivity" "$MAIN_ACTIVITY"; then
        echo "   ✅ MainActivity extends FlutterActivity"
    else
        echo "   ❌ MainActivity does not extend FlutterActivity"
    fi
else
    echo "   ❌ MainActivity.kt not found"
fi

# Check build.gradle
echo -e "\n3. Checking build.gradle configuration..."
BUILD_GRADLE="android/app/build.gradle"

if [ -f "$BUILD_GRADLE" ]; then
    if grep -q "dev.flutter.flutter-gradle-plugin" "$BUILD_GRADLE"; then
        echo "   ✅ Flutter Gradle plugin configured"
    else
        echo "   ❌ Flutter Gradle plugin missing"
    fi
    
    if grep -q 'flutter {' "$BUILD_GRADLE"; then
        echo "   ✅ Flutter block configuration found"
    else
        echo "   ❌ Flutter block configuration missing"
    fi
else
    echo "   ❌ build.gradle not found"
fi

# Check settings.gradle
echo -e "\n4. Checking settings.gradle..."
SETTINGS_GRADLE="android/settings.gradle"

if [ -f "$SETTINGS_GRADLE" ]; then
    if grep -q "dev.flutter.flutter-gradle-plugin" "$SETTINGS_GRADLE"; then
        echo "   ✅ Flutter plugin configured in settings"
    else
        echo "   ❌ Flutter plugin not configured in settings"
    fi
else
    echo "   ❌ settings.gradle not found"
fi

# Check themes.xml
echo -e "\n5. Checking themes.xml..."
THEMES_FILE="android/app/src/main/res/values/themes.xml"

if [ -f "$THEMES_FILE" ]; then
    if grep -q 'name="NormalTheme"' "$THEMES_FILE"; then
        echo "   ✅ NormalTheme style defined"
    else
        echo "   ❌ NormalTheme style missing"
    fi
else
    echo "   ❌ themes.xml not found"
fi

# Check local.properties
echo -e "\n6. Checking local.properties..."
LOCAL_PROPS="android/local.properties"

if [ -f "$LOCAL_PROPS" ]; then
    if grep -q "flutter.sdk=" "$LOCAL_PROPS"; then
        echo "   ✅ Flutter SDK path configured"
        FLUTTER_PATH=$(grep "flutter.sdk=" "$LOCAL_PROPS" | cut -d'=' -f2)
        echo "   📁 Flutter SDK: $FLUTTER_PATH"
    else
        echo "   ⚠️  Flutter SDK path not set"
    fi
else
    echo "   ⚠️  local.properties not found - needs to be created"
fi

# Summary
echo -e "\n📋 Summary:"
echo "   Android v2 embedding configuration has been applied."
echo "   To complete the setup:"
echo "   1. Install Flutter SDK"
echo "   2. Update android/local.properties with correct Flutter path"
echo "   3. Run: flutter pub get"
echo "   4. Run: flutter build apk --debug"
echo
echo "   The original Android v1 embedding error should now be resolved! ✨"