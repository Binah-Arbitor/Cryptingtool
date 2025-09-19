# CryptingTool - High-Performance Flutter Encryption Suite

A cross-platform Flutter application with integrated C++ cryptographic components, featuring a professional PCB/cyber-tech design theme and custom CPU chip app icon.

## 🎨 App Icon Design

The CryptingTool features a **custom-designed app icon** that embodies the hardware-level encryption concept:

- **Core Symbol**: Top-down view of a CPU chip with realistic pin layout
- **Central Focus**: Glowing keyhole symbol etched into the chip surface
- **Background**: Dark circuit board with teal traces and connection nodes  
- **Colors**: Teal (#00FFD4) and cyan (#00E5FF) glow effects against deep black (#0A0A0A)
- **Theme**: Hardware-level security and professional technical aesthetics

The icon is implemented as both SVG assets and a custom Flutter widget for maximum flexibility and performance.

## Features

- ✅ Cross-platform Flutter application for encryption
- ✅ Integrates C++ cryptographic components 
- ✅ Custom CPU chip app icon with hardware encryption theme
- ✅ PCB/cyber-tech UI design with circuit board aesthetics
- ✅ High-performance encryption suite
- ✅ Professional dark theme interface

## Getting Started

### Prerequisites

- Flutter SDK (>=3.16.0)
- Dart SDK (>=3.0.0)
- C++ compiler (for native cryptographic components)
- Platform-specific development tools

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Binah-Arbitor/Cryptingtool.git
cd Cryptingtool
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Build native C++ components (if needed):
```bash
./scripts/troubleshoot.sh
```

4. Run the application:
```bash
flutter run
```

### Building for Different Platforms

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Linux Desktop
```bash
flutter build linux --release
```

#### Windows Desktop
```bash
flutter build windows --release
```

#### macOS Desktop
```bash
flutter build macos --release
```

#### Web
```bash
flutter build web --release
```

## Supported Platforms

### Android
- Contains Android project configuration
- Includes native libraries (.so files)
- Supports different architectures

### iOS
- Builds iOS app bundle
- Includes native frameworks
- Supports iOS 11.0+

### Linux Desktop
- Builds native Linux application
- Includes shared libraries (.so files)
- Supports modern Linux distributions

### Windows Desktop
- Builds native Windows application
- Includes dynamic libraries (.dll files)
- Supports Windows 10+

### macOS Desktop
- Builds native macOS application
- Includes dynamic libraries (.dylib files)
- Supports macOS 10.14+

### Web
- Builds Progressive Web App (PWA)
- JavaScript-only build (no C++ integration)
- Creates ZIP package
- No C++ integration for web builds

## C++ Integration

The application automatically detects and builds C++ components in your project:

1. **CMake Projects**: If `CMakeLists.txt` is found, uses CMake with Ninja
2. **Makefile Projects**: If `Makefile` is found, uses make
3. **Source Files**: Compiles `.cpp`, `.cc`, `.cxx`, and `.c` files directly

### Generated Libraries
- Linux/macOS: `libcrypting.so` (shared library)
- Windows: `libcrypting.a` (static library)
- Mobile: Platform-specific native libraries

## Flutter Integration

The application handles Flutter projects automatically:

1. FFI dependencies for C++ integration
2. Cross-platform UI components
3. State management with Provider pattern
4. Custom theming and styling

### Flutter Version Handling
- **Minimum supported**: Flutter 3.16.0
- **Dart SDK**: >=3.0.0 <4.0.0
- **Recommended**: Use stable channel

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── crypto_bridge/            # C++ integration layer
├── models/                   # Data models
├── providers/                # State management
├── screens/                  # UI screens
├── theme/                    # App theming
└── widgets/                  # Reusable UI components
```

## Troubleshooting

The application includes robust error handling and automatic dependency resolution. If you encounter issues:

### Quick Diagnosis
```bash
# Run the troubleshooting script
./scripts/troubleshoot.sh

# For Flutter doctor specific issues
./scripts/flutter-doctor-fix.sh
```

### Common Issues

#### 1. Crypto++ Library Not Found
**Symptoms**: CMake configuration fails with "Crypto++ library not found"

**Solutions**:
- Ubuntu/Debian: `sudo apt-get install libcrypto++-dev`
- macOS: `brew install cryptopp`  
- Windows: `vcpkg install cryptopp`

#### 2. Flutter SDK Issues
**Symptoms**: Flutter commands fail or SDK not found

**Solutions**:
- Install Flutter: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Verify installation: `flutter doctor`

#### 3. Flutter Linux Desktop Issues
**Symptoms**: "GTK 3.0 development libraries are required for Linux development"

**Solutions**:
- `sudo apt-get install libgtk-3-dev mesa-utils`

#### 4. Flutter Doctor Issues
**Symptoms**: Multiple Flutter doctor errors like "[✗] Linux toolchain" or "[!] Android Studio (not installed)"

**Solutions**:
- Run the dedicated Flutter doctor issue resolver: `./scripts/flutter-doctor-fix.sh`
- This script provides interactive fixing for common Flutter doctor problems

### Dependency Check
Run a comprehensive dependency check:
```bash
./scripts/check-dependencies.sh
```

### Crypto Library Verification
Verify crypto++ installation:
```bash
./scripts/verify-crypto.sh
```

### Manual Installation Steps
If automatic installation fails:

1. **Install crypto++ from source**:
```bash
wget https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_9_0/cryptopp890.zip
unzip cryptopp890.zip && cd cryptopp
make && sudo make install
```

2. **Update library paths**:
```bash
sudo ldconfig
```

## Development

### Running Tests
```bash
flutter test
```

### Code Quality
```bash
flutter analyze
```

### Formatting
```bash
dart format .
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue on GitHub
- Check the troubleshooting guide above
- Run diagnostic scripts in the `scripts/` directory