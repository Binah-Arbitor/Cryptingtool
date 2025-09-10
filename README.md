# CryptingTool - High-Performance File Encryption Utility

A Flutter-based UI for a high-performance file encryption/decryption utility with PCB/Cyber-Tech aesthetic design. This application provides a modern, intuitive interface for file encryption operations using various cryptographic algorithms.

## Features

### 🔒 Encryption & Decryption
- Support for multiple encryption algorithms (AES, Serpent, Twofish, RC6, Blowfish, Camellia)
- Configurable key lengths (128, 192, 256 bits)
- Multiple operation modes (CBC, GCM, ECB, CFB, OFB, CTR)
- Dynamic algorithm compatibility - UI adapts available options based on selected algorithm

### 🎨 PCB/Cyber-Tech UI Design
- Dark theme with deep off-black background (#0A0A0A)
- Teal/Cyan accent colors for interactive elements
- Lime green for success states
- Circuit board-inspired design elements
- Monospace fonts for technical aesthetic

### 🚀 Advanced Features
- **Multithreading Control**: Configurable worker threads with efficiency monitoring
- **Real-time Logging**: Live console with color-coded log levels
- **Progress Tracking**: Real-time progress indicators and status monitoring
- **System Integration**: Automatic CPU core detection and optimization
- **File Compatibility**: Support for all file types

### 📱 UI Components
- **File I/O Panel**: Drag-and-drop file selection with encryption/decryption actions
- **Encryption Config Panel**: Algorithm, key length, operation mode, and password settings
- **Advanced Settings Panel**: Multithreading controls and performance tuning
- **Live Log Console**: Expandable console with real-time backend communication logs
- **Status Panel**: Progress bar and system status indicators

## Requirements

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Supported platforms: Windows, macOS, Linux

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  file_picker: ^6.1.1
  path_provider: ^2.1.1
  provider: ^6.1.1
  flutter_riverpod: ^2.4.9
  equatable: ^2.0.5
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Binah-Arbitor/Cryptingtool.git
cd Cryptingtool
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Architecture

### UI Structure
- **Single-screen layout** with expandable panels for efficient space usage
- **Modular widget system** with separate components for each major feature
- **Responsive design** that adapts to different screen sizes

### Backend Communication
- **Service Layer**: `BackendService` handles communication with C++ backend
- **Stream-based Architecture**: Real-time updates using Dart streams
- **Isolate Support**: Prepared for multithreaded backend communication

### State Management
- **Equatable Models**: Immutable data models for reliable state management
- **Stream Controllers**: Real-time communication between UI and backend
- **Progress Tracking**: Comprehensive progress and status monitoring

## Supported Algorithms

| Algorithm | Key Lengths | Operation Modes |
|-----------|-------------|----------------|
| AES | 128, 192, 256 | CBC, GCM, ECB, CFB, OFB, CTR |
| Serpent | 128, 192, 256 | CBC, ECB, CFB, OFB |
| Twofish | 128, 192, 256 | CBC, ECB, CFB, OFB |
| RC6 | 128, 192, 256 | CBC, ECB, CFB, OFB |
| Blowfish | 128 | CBC, ECB, CFB, OFB |
| Camellia | 128, 192, 256 | CBC, ECB, CFB, OFB |

## Color Palette

- **Background**: Deep Off-Black (#0A0A0A)
- **Primary Accent**: Teal/Cyan (#00D4AA)
- **Secondary Accent**: Lime Green (#39FF14)
- **Text**: Light Gray (#E0E0E0)
- **Cards**: Dark Gray (#121212)
- **Error**: Red (#FF3366)
- **Warning**: Orange (#FF9500)
- **Info**: Blue (#0099FF)

## Future Enhancements

- Integration with C++ Crypto++ backend
- Network encryption capabilities
- Batch file processing
- Custom encryption profiles
- Performance benchmarking tools

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Screenshots

*Screenshots will be added once the application is running*

---

**Note**: This is the UI component of the CryptingTool. The C++ backend with Crypto++ integration is planned for future development.