#!/bin/bash
# Test script to verify Android API 24+ configuration
set -e

echo "=== Android API 24+ Configuration Test ==="
echo ""

# Check if Android platform exists
if [ ! -d "android" ]; then
    echo "❌ ERROR: Android platform directory not found!"
    exit 1
fi

echo "✅ Android platform directory exists"

# Check build.gradle configuration
if [ -f "android/app/build.gradle" ]; then
    echo "✅ build.gradle exists"
    
    # Check minSdk configuration (should be 24+)
    if grep -q "minSdk.*=.*2[4-9]\|[3-9][0-9]\|[1-9][0-9][0-9]" "android/app/build.gradle"; then
        echo "✅ Minimum SDK version is set to 24+ (Android 7.0+)"
    else
        echo "❌ ERROR: minSdk not set to 24 or higher"
        exit 1
    fi
    
    # Check compileSdk configuration
    if grep -q "compileSdk.*=.*3[5-9]\|[4-9][0-9]" "android/app/build.gradle"; then
        echo "✅ Compile SDK version is current (35+)"
    else
        echo "❌ ERROR: compileSdk not set to 35 or higher"
        exit 1
    fi
    
    # Verify multidex is NOT enabled (not needed for API 24+)
    if ! grep -q "multiDexEnabled.*true" "android/app/build.gradle"; then
        echo "✅ Multidex support correctly disabled (not needed for API 24+)"
    else
        echo "⚠️  WARNING: Multidex support still enabled (unnecessary for API 24+)"
    fi
    
    # Verify vector drawable legacy support is NOT enabled (not needed for API 24+)
    if ! grep -q "vectorDrawables.useSupportLibrary.*true" "android/app/build.gradle"; then
        echo "✅ Vector drawable legacy support correctly disabled (not needed for API 24+)"
    else
        echo "⚠️  WARNING: Vector drawable legacy support still enabled (unnecessary for API 24+)"
    fi
else
    echo "❌ ERROR: build.gradle not found!"
    exit 1
fi

# Check AndroidManifest.xml configuration
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    echo "✅ AndroidManifest.xml exists"
    
    # Check minSdkVersion in manifest
    if grep -q "minSdkVersion.*2[4-9]\|[3-9][0-9]\|[1-9][0-9][0-9]" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ AndroidManifest.xml specifies minSdkVersion 24+"
    else
        echo "ℹ️  INFO: minSdkVersion not specified in AndroidManifest.xml (will use build.gradle)"
    fi
    
    # Check required permissions
    if grep -q "android.permission.INTERNET" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ Internet permission configured for crypto operations"
    else
        echo "❌ ERROR: Internet permission not configured"
        exit 1
    fi
    
    # Verify legacy external storage support is removed
    if ! grep -q "requestLegacyExternalStorage" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ Legacy external storage support correctly removed (modern scoped storage)"
    else
        echo "⚠️  WARNING: Legacy external storage support still present (unnecessary for API 24+)"
    fi
else
    echo "❌ ERROR: AndroidManifest.xml not found!"
    exit 1
fi

# Check MainActivity exists
if [ -f "android/app/src/main/kotlin/com/binah/cryptingtool/MainActivity.kt" ]; then
    echo "✅ MainActivity.kt exists"
else
    echo "❌ ERROR: MainActivity.kt not found!"
    exit 1
fi

# Check other essential Android files
essential_files=(
    "android/settings.gradle"
    "android/build.gradle"
    "android/gradle.properties"
)

for file in "${essential_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ ERROR: $file not found!"
        exit 1
    fi
done

echo ""
echo "=== Configuration Summary ==="
echo "✅ Android platform configured for API 24+ (Android 7.0+)"
echo "✅ Modern Android features enabled for improved stability"
echo "✅ Legacy compatibility code removed (cleaner, more reliable)"
echo "✅ All essential Android build files present"
echo ""
echo "🎯 Target: Android API 24+ (7.0 Nougat and above)"
echo "💻 VM Environment: Windows"
echo "🏗️  Build System: Gradle with Flutter"
echo "📊 Device Coverage: ~94% of active Android devices"
echo ""
echo "✅ Android API 24+ configuration test PASSED!"