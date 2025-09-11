#!/bin/bash
set -e

COMPILER=$1
TARGET_PLATFORM=$2

echo "Building C++ components with $COMPILER for $TARGET_PLATFORM..."

# Create build directory
mkdir -p build/cpp

# Find all C++ source files
CPP_SOURCES=$(find . -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" 2>/dev/null || echo "")
C_SOURCES=$(find . -name "*.c" 2>/dev/null || echo "")

if [ -z "$CPP_SOURCES" ] && [ -z "$C_SOURCES" ]; then
    echo "No C++ source files found. Skipping C++ build."
    exit 0
fi

# Set compiler and flags based on target platform
case $TARGET_PLATFORM in
    "android")
        if [ ! -z "$ANDROID_NDK" ]; then
            export CC="$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang"
            export CXX="$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang++"
        fi
        ;;
    "ios")
        export CC="clang"
        export CXX="clang++"
        export CFLAGS="-arch arm64 -isysroot $(xcrun --sdk iphoneos --show-sdk-path)"
        export CXXFLAGS="-arch arm64 -isysroot $(xcrun --sdk iphoneos --show-sdk-path)"
        ;;
    "linux")
        case $COMPILER in
            "gcc")
                export CC="gcc"
                export CXX="g++"
                ;;
            "clang")
                export CC="clang"
                export CXX="clang++"
                ;;
        esac
        ;;
    "windows")
        if [ "$COMPILER" = "msvc" ]; then
            # Use MSVC if available
            export CC="cl"
            export CXX="cl"
        else
            export CC="gcc"
            export CXX="g++"
        fi
        ;;
    "macos")
        export CC="clang"
        export CXX="clang++"
        ;;
esac

# Check for CMakeLists.txt
if [ -f "CMakeLists.txt" ]; then
    echo "Found CMakeLists.txt, using CMake build..."
    cd build/cpp
    
    # Run CMake with verbose output to catch library issues
    if ! cmake ../.. -G Ninja -DCMAKE_BUILD_TYPE=Release; then
        echo "❌ CMake configuration failed. Checking for missing dependencies..."
        
        # Try to help with common issues
        if [ "${{ runner.os }}" = "Linux" ]; then
            echo "🔍 Checking for crypto++ library on Linux..."
            if ! dpkg -l | grep -q libcrypto++; then
                echo "📦 Installing crypto++ library..."
                sudo apt-get update && sudo apt-get install -y libcrypto++-dev
            fi
            
            # Update library cache
            sudo ldconfig
            
            # Try CMake again
            echo "🔄 Retrying CMake configuration..."
            cmake ../.. -G Ninja -DCMAKE_BUILD_TYPE=Release
        else
            echo "❌ CMake failed on ${{ runner.os }}. Please check crypto++ installation."
            exit 1
        fi
    fi
    
    if ! ninja; then
        echo "❌ Build failed. Checking library linking issues..."
        echo "Available libraries:"
        find /usr /usr/local -name "*crypto*" 2>/dev/null | head -10
        exit 1
    fi
    
    cd ../..
elif [ -f "Makefile" ]; then
    echo "Found Makefile, using make build..."
    make clean || true
    make
else
    echo "No CMakeLists.txt or Makefile found. Compiling sources directly..."
    
    # Compile C++ sources
    if [ ! -z "$CPP_SOURCES" ]; then
        for src in $CPP_SOURCES; do
            obj="build/cpp/$(basename $src .cpp).o"
            echo "Compiling $src -> $obj"
            mkdir -p $(dirname $obj)
            $CXX -c $src -o $obj $CXXFLAGS
        done
    fi
    
    # Compile C sources
    if [ ! -z "$C_SOURCES" ]; then
        for src in $C_SOURCES; do
            obj="build/cpp/$(basename $src .c).o"
            echo "Compiling $src -> $obj"
            mkdir -p $(dirname $obj)
            $CC -c $src -o $obj $CFLAGS
        done
    fi
    
    # Link objects into library
    OBJECTS=$(find build/cpp -name "*.o" 2>/dev/null || echo "")
    if [ ! -z "$OBJECTS" ]; then
        case $TARGET_PLATFORM in
            "windows")
                echo "Creating static library libcrypting.a..."
                ar rcs build/cpp/libcrypting.a $OBJECTS
                ;;
            *)
                echo "Creating shared library libcrypting.so..."
                $CXX -shared $OBJECTS -o build/cpp/libcrypting.so
                ;;
        esac
    fi
fi

echo "C++ build completed successfully!"