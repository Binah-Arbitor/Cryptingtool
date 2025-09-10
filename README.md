# CryptingTool

A Flutter application with C++ native integration for cryptographic operations.

## Features

- Flutter UI for user interaction
- C++ native library for cryptographic operations
- Cross-platform support (Windows, macOS, Linux)
- Automated packaging with GitHub Actions

## Project Structure

```
├── lib/                    # Flutter Dart code
│   ├── main.dart          # Main application entry point
│   ├── crypto_service.dart # Service for native C++ integration
│   └── crypto_bindings.dart # FFI bindings (generated)
├── native/                # C++ native library
│   ├── crypto.h          # Header file
│   ├── crypto.cpp        # Implementation
│   └── CMakeLists.txt    # CMake build configuration
├── .github/workflows/     # GitHub Actions
│   └── package.yml       # Build and packaging workflow
└── pubspec.yaml          # Flutter dependencies
```

## Development

### Prerequisites

- Flutter SDK (3.19.0 or later)
- CMake (3.18 or later)
- C++ compiler (GCC, Clang, or MSVC)

### Building Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/Binah-Arbitor/Cryptingtool.git
   cd Cryptingtool
   ```

2. Build the native library:
   ```bash
   cd native
   cmake -B build -DCMAKE_BUILD_TYPE=Release
   cmake --build build --config Release
   cd ..
   ```

3. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## GitHub Actions Workflow

The project includes a comprehensive GitHub Actions workflow that:

1. **Builds native libraries** for all platforms (Linux, Windows, macOS)
2. **Builds Flutter applications** with native library integration
3. **Packages applications** as distributable archives
4. **Creates releases** with automatic asset uploads

### Workflow Features

- Uses Actions v4 (checkout@v4, upload-artifact@v4, download-artifact@v4)
- Cross-platform builds using matrix strategy
- Automated native library compilation with CMake
- Flutter application building for desktop platforms
- Proper artifact packaging and release creation
- Native library integration into final packages

### Supported Platforms

- **Linux**: Builds to `.tar.gz` archive
- **Windows**: Builds to `.zip` archive  
- **macOS**: Builds to `.zip` archive

## Architecture

The application uses Flutter's FFI (Foreign Function Interface) to communicate with a C++ native library. The native library provides cryptographic functions that are called from the Flutter/Dart layer.

### Key Components

1. **CryptoService**: Dart service that loads and interfaces with the native library
2. **Native Library**: C++ implementation of cryptographic functions
3. **GitHub Action**: Automated build and packaging pipeline

## Usage

1. Enter text in the input field
2. Click "Encrypt with C++" to process the text using the native library
3. View the encrypted result

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.