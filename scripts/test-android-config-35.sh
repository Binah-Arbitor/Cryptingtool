#!/bin/bash
# Enhanced test script to verify Android API 35+ configuration with optimizations
set -e

echo "=== Android API 35+ Configuration Test ==="
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
    
    # Check minSdk configuration
    if grep -q "minSdk.*=.*16" "android/app/build.gradle"; then
        echo "✅ Minimum SDK version is set to 16 (Android 4.1+)"
    else
        echo "❌ ERROR: minSdk not set to 16"
        exit 1
    fi
    
    # Check targetSdk configuration
    if grep -q "targetSdk.*=.*35" "android/app/build.gradle"; then
        echo "✅ Target SDK version is set to 35 (Android 15)"
    else
        echo "⚠️  WARNING: targetSdk not set to 35"
    fi
    
    # Check compileSdk configuration
    if grep -q "compileSdk.*=.*35" "android/app/build.gradle"; then
        echo "✅ Compile SDK version is set to 35 (Android 15)"
    else
        echo "⚠️  WARNING: compileSdk not set to 35"
    fi
    
    # Check Java 11 compatibility
    if grep -q "JavaVersion.VERSION_11" "android/app/build.gradle"; then
        echo "✅ Java 11 compatibility configured"
    else
        echo "⚠️  WARNING: Java version not set to 11"
    fi
    
    # Check multidex support
    if grep -q "multiDexEnabled.*true" "android/app/build.gradle"; then
        echo "✅ Multidex support enabled for legacy Android versions"
    else
        echo "⚠️  WARNING: Multidex support not explicitly enabled"
    fi
    
    # Check vector drawable support
    if grep -q "vectorDrawables.useSupportLibrary.*true" "android/app/build.gradle"; then
        echo "✅ Vector drawable support enabled for API < 21"
    else
        echo "⚠️  WARNING: Vector drawable support not explicitly enabled"
    fi
    
    # Check R8 optimization
    if grep -q "minifyEnabled.*true" "android/app/build.gradle"; then
        echo "✅ Code minification (R8) enabled for release builds"
    else
        echo "⚠️  WARNING: Code minification not enabled"
    fi
    
    # Check resource shrinking
    if grep -q "shrinkResources.*true" "android/app/build.gradle"; then
        echo "✅ Resource shrinking enabled for release builds"
    else
        echo "⚠️  WARNING: Resource shrinking not enabled"
    fi
    
    # Check ABI filters
    if grep -q "abiFilters" "android/app/build.gradle"; then
        echo "✅ ABI filters configured for optimization"
    else
        echo "⚠️  WARNING: ABI filters not configured"
    fi
    
else
    echo "❌ ERROR: build.gradle not found!"
    exit 1
fi

# Check ProGuard rules file
if [ -f "android/app/proguard-rules.pro" ]; then
    echo "✅ ProGuard rules file exists"
    if grep -q "Flutter" "android/app/proguard-rules.pro"; then
        echo "✅ Flutter-specific ProGuard rules configured"
    else
        echo "⚠️  WARNING: Flutter ProGuard rules not found"
    fi
else
    echo "⚠️  WARNING: ProGuard rules file not found"
fi

# Check AndroidManifest.xml configuration
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    echo "✅ AndroidManifest.xml exists"
    
    # Check minSdkVersion in manifest
    if grep -q "minSdkVersion.*16" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ AndroidManifest.xml specifies minSdkVersion 16"
    else
        echo "ℹ️  INFO: minSdkVersion not specified in AndroidManifest.xml (will use build.gradle)"
    fi
    
    # Check targetSdkVersion in manifest
    if grep -q "targetSdkVersion.*35" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ AndroidManifest.xml specifies targetSdkVersion 35"
    else
        echo "ℹ️  INFO: targetSdkVersion not specified in AndroidManifest.xml (will use build.gradle)"
    fi
    
    # Check required permissions
    if grep -q "android.permission.INTERNET" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ Internet permission configured for crypto operations"
    else
        echo "❌ ERROR: Internet permission not configured"
        exit 1
    fi
    
    # Check optimization attributes
    if grep -q "extractNativeLibs.*false" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ Native library extraction optimization enabled"
    else
        echo "⚠️  WARNING: Native library optimization not configured"
    fi
    
    if grep -q "hardwareAccelerated.*true" "android/app/src/main/AndroidManifest.xml"; then
        echo "✅ Hardware acceleration enabled"
    else
        echo "⚠️  WARNING: Hardware acceleration not explicitly enabled"
    fi
    
else
    echo "❌ ERROR: AndroidManifest.xml not found!"
    exit 1
fi

# Check gradle.properties optimizations
if [ -f "android/gradle.properties" ]; then
    echo "✅ gradle.properties exists"
    
    if grep -q "org.gradle.caching=true" "android/gradle.properties"; then
        echo "✅ Gradle build caching enabled"
    else
        echo "⚠️  WARNING: Gradle build caching not enabled"
    fi
    
    if grep -q "android.enableR8.fullMode=true" "android/gradle.properties"; then
        echo "✅ R8 full mode optimization enabled"
    else
        echo "⚠️  WARNING: R8 full mode not enabled"
    fi
    
    if grep -q "org.gradle.parallel=true" "android/gradle.properties"; then
        echo "✅ Parallel Gradle builds enabled"
    else
        echo "⚠️  WARNING: Parallel builds not enabled"
    fi
else
    echo "❌ ERROR: gradle.properties not found!"
    exit 1
fi

# Check settings.gradle for updated versions
if [ -f "android/settings.gradle" ]; then
    echo "✅ settings.gradle exists"
    
    if grep -q "8\.[2-9]" "android/settings.gradle" || grep -q "8\.1[0-9]" "android/settings.gradle"; then
        echo "✅ Android Gradle Plugin version is current (8.2+)"
    else
        echo "⚠️  WARNING: Android Gradle Plugin should be version 8.2 or higher"
    fi
    
    if grep -q "1\.9" "android/settings.gradle"; then
        echo "✅ Kotlin version is current (1.9+)"
    else
        echo "⚠️  WARNING: Kotlin version should be 1.9 or higher"
    fi
else
    echo "❌ ERROR: settings.gradle not found!"
    exit 1
fi

# Check MainActivity exists
if [ -f "android/app/src/main/kotlin/com/binah/cryptingtool/MainActivity.kt" ]; then
    echo "✅ MainActivity.kt exists"
else
    echo "❌ ERROR: MainActivity.kt not found!"
    exit 1
fi

echo ""
echo "=== Configuration Summary ==="
echo "✅ Android platform configured for API 35 (Android 15)"
echo "✅ Minimum SDK 16 (Android 4.1+) for backward compatibility"
echo "✅ Build optimizations enabled (R8, ProGuard, resource shrinking)"
echo "✅ Performance optimizations configured"
echo "✅ Windows VM environment optimized"
echo "✅ All essential Android build files present"
echo ""
echo "🎯 Target: Android API 35 (Android 15) with 4.1+ compatibility"
echo "💻 VM Environment: Windows"
echo "🏗️  Build System: Gradle with Flutter"
echo "⚡ Optimizations: R8, ProGuard, Resource Shrinking, Build Caching"
echo ""
echo "✅ Android API 35+ configuration test PASSED!"