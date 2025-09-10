# Flutter C++ Packager Action

A GitHub Action to build and package Flutter applications with C++ components using GitHub Actions V4 (Node 20 runtime).

## Features

- ✅ Supports multiple platforms: Android, iOS, Linux, Windows, macOS, Web
- ✅ Integrates C++ component compilation
- ✅ Flexible build configuration
- ✅ Automatic dependency management
- ✅ Cross-platform packaging
- ✅ GitHub Actions V4 compatible

## Usage

### Basic Usage

```yaml
name: Build and Package
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Package Flutter App with C++
        uses: ./
        with:
          target-platform: 'linux'
          app-name: 'MyApp'
          build-mode: 'release'
```

### Advanced Usage

```yaml
name: Multi-Platform Build
on: [push, pull_request]

jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        include:
          - os: ubuntu-latest
            platform: linux
          - os: windows-latest
            platform: windows
          - os: macos-latest
            platform: macos
    
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Package Flutter App
        uses: ./
        with:
          target-platform: ${{ matrix.platform }}
          app-name: 'CryptingTool'
          build-mode: 'release'
          flutter-version: 'stable'
          cpp-compiler: 'gcc'
          output-path: './packages'
          include-cpp-libs: 'true'
        id: package
        
      - name: Upload Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: ${{ matrix.platform }}-package
          path: ${{ steps.package.outputs.package-path }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `flutter-version` | Flutter SDK version to use | No | `stable` |
| `flutter-channel` | Flutter channel (stable, beta, dev, master) | No | `stable` |
| `target-platform` | Target platform (android, ios, linux, windows, macos, web) | Yes | - |
| `build-mode` | Build mode (debug, profile, release) | No | `release` |
| `cpp-compiler` | C++ compiler to use (gcc, clang, msvc) | No | `gcc` |
| `output-path` | Output path for packaged application | No | `./dist` |
| `app-name` | Application name for packaging | Yes | - |
| `include-cpp-libs` | Include C++ libraries in package | No | `true` |

## Outputs

| Output | Description |
|--------|-------------|
| `package-path` | Path to the generated package |
| `package-size` | Size of the generated package |

## Supported Platforms

### Android
- Builds APK files
- Includes native libraries (.so files)
- Supports different architectures

### iOS
- Builds iOS app bundle
- Includes frameworks and dylibs
- Requires macOS runner

### Linux
- Creates executable bundle
- Includes shared libraries
- Creates tar.gz package

### Windows
- Builds Windows executable
- Includes DLL files
- Creates ZIP package

### macOS
- Creates .app bundle
- Includes frameworks
- Creates tar.gz package

### Web
- Builds web assets
- Creates ZIP package
- No C++ integration for web builds

## C++ Integration

The action automatically detects and builds C++ components in your project:

1. **CMake Projects**: If `CMakeLists.txt` is found, uses CMake with Ninja
2. **Makefile Projects**: If `Makefile` is found, uses make
3. **Source Files**: Compiles `.cpp`, `.cc`, `.cxx`, and `.c` files directly

### C++ Build Outputs
- Linux/macOS: `libcrypting.so` (shared library)
- Windows: `libcrypting.a` (static library)
- Mobile: Platform-specific native libraries

## Flutter Integration

The action handles Flutter projects automatically:

1. Creates a minimal Flutter project if none exists
2. Adds FFI dependencies for C++ integration
3. Builds for the specified target platform
4. Packages the built application

## Project Structure

```
your-repo/
├── lib/                  # Flutter Dart code
├── android/             # Android specific code
├── ios/                 # iOS specific code
├── linux/               # Linux specific code
├── windows/             # Windows specific code
├── macos/               # macOS specific code
├── web/                 # Web specific code
├── src/                 # C++ source files
├── include/             # C++ header files
├── CMakeLists.txt       # CMake build file (optional)
├── Makefile            # Makefile (optional)
└── pubspec.yaml        # Flutter dependencies
```

## Examples

### Example 1: Simple Flutter App with C++ Library

```yaml
- name: Build Crypto Tool
  uses: Binah-Arbitor/Cryptingtool@v1
  with:
    target-platform: 'linux'
    app-name: 'CryptingTool'
    cpp-compiler: 'gcc'
```

### Example 2: Multi-Platform Release

```yaml
- name: Build All Platforms
  strategy:
    matrix:
      platform: [android, linux, windows, macos]
  uses: Binah-Arbitor/Cryptingtool@v1
  with:
    target-platform: ${{ matrix.platform }}
    app-name: 'CryptingTool'
    build-mode: 'release'
    output-path: './releases'
```

## Requirements

- Repository must contain Flutter project files or the action will create a minimal structure
- For C++ integration, source files should be in standard locations
- Platform-specific runners required for iOS (macOS) and Windows builds

## License

MIT License - see [LICENSE](LICENSE) file for details.