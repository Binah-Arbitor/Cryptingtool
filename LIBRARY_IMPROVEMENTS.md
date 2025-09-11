# Library Finding Improvements

This update addresses the issue where GitHub Actions fail to find the crypto++ library by implementing robust fallback mechanisms and automatic installation.

## Changes Made

### 1. Enhanced CMakeLists.txt
- **Multiple detection methods**: Added 4 different methods to find crypto++ library:
  1. pkg-config (most reliable)
  2. find_library with multiple names and paths
  3. Header-based detection with manual linking
  4. vcpkg support for Windows
- **Better error messages**: Clear instructions for each platform when library is not found
- **Automatic path discovery**: Searches common installation paths across different systems

### 2. Improved GitHub Action (action.yml)
- **Dependency checking step**: Added automatic verification before building
- **Robust installation**: Multiple fallback installation methods per platform
- **Source compilation fallback**: Falls back to building crypto++ from source if packages unavailable
- **Verification step**: Confirms library installation before proceeding

### 3. Enhanced Build Scripts
- **build-cpp.sh**: Added error handling and retry logic for CMake configuration
- **build-flutter.sh**: Better error reporting and automatic cleanup on failure
- **check-dependencies.sh**: New script for comprehensive dependency checking and automatic installation
- **test-libraries.sh**: New script to verify built libraries work correctly

## Platform Support

### Linux (Ubuntu/Debian)
- Primary: `sudo apt-get install libcrypto++-dev`
- Fallback: Alternative package names (`libcrypto++8-dev`, `libcryptoppdev`)
- Last resort: Build from source

### macOS
- Primary: `brew install cryptopp`
- Fallback: Build from source

### Windows
- Primary: vcpkg (`vcpkg install cryptopp`)
- Automatic vcpkg setup if not available

## Error Handling

The action now handles these common failure scenarios:
1. **Missing library packages**: Automatic installation with multiple attempts
2. **CMake configuration failure**: Retry with dependency installation
3. **Build failures**: Clear error messages with troubleshooting hints
4. **Missing build tools**: Detection and installation instructions

## Testing

Added comprehensive testing:
- **Local testing script**: `scripts/test-action-locally.sh`
- **Library verification**: Symbol checking, dependency verification, runtime tests
- **Integration testing**: End-to-end action workflow validation

## Usage

The action now works more reliably out-of-the-box:

```yaml
- name: Build with Enhanced Action
  uses: ./
  with:
    target-platform: 'linux'
    app-name: 'MyApp'
    build-mode: 'release'
```

If issues occur, the action provides clear error messages with platform-specific installation instructions.