#!/bin/bash
set -e

echo "🧪 Testing GitHub Action locally..."

# Create a temporary directory for test outputs
TEST_OUTPUT_DIR="/tmp/test-action-output"
rm -rf "$TEST_OUTPUT_DIR"
mkdir -p "$TEST_OUTPUT_DIR"

cd /home/runner/work/Cryptingtool/Cryptingtool

echo "🔍 Step 1: Check dependencies..."
./scripts/check-dependencies.sh

echo "🔨 Step 2: Build C++ components..."
mkdir -p build/cpp
export TARGET_PLATFORM="linux"
export COMPILER="gcc"
./scripts/build-cpp.sh "$COMPILER" "$TARGET_PLATFORM"

echo "🧪 Step 3: Test libraries..."
./scripts/test-libraries.sh

echo "📦 Step 4: Package application..."
export APP_NAME="CryptingTool-Test"
export OUTPUT_PATH="$TEST_OUTPUT_DIR"
export INCLUDE_CPP_LIBS="true"
./scripts/package.sh "$TARGET_PLATFORM" "$APP_NAME" "$OUTPUT_PATH" "$INCLUDE_CPP_LIBS"

echo "✅ Step 5: Verify package..."
if [ -f "$TEST_OUTPUT_DIR/CryptingTool-Test-linux.tar.gz" ]; then
    echo "✅ Package created successfully: $(ls -lh "$TEST_OUTPUT_DIR"/CryptingTool-Test-linux.tar.gz)"
    
    # Extract and check contents
    cd "$TEST_OUTPUT_DIR"
    tar -tzf CryptingTool-Test-linux.tar.gz | head -10
    echo "✅ Package contents look good"
else
    echo "❌ Package not found"
    ls -la "$TEST_OUTPUT_DIR"
    exit 1
fi

echo "🎉 Local action test completed successfully!"